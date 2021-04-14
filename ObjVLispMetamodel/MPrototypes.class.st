"
|language|
	""instantiates the model""
	language := (MPrototypes 
		named: 'Prototypes' 
		withEntryPoint: 'System log: ''hola!''. System quit.').
	
	""generates the kernel and executes it using an external VM""
	language generateAndRun.
	
	""loads the generated kernel file into the host (current image) and executes it using the VM simulator""
	language runImageLoadedFromFile.
"
Class {
	#name : #MPrototypes,
	#superclass : #LanguageModel,
	#category : #ObjVLispMetamodel
}

{ #category : #'as yet unclassified' }
MPrototypes class >> classMetaclass [
	^ PrototypesClass 
]

{ #category : #'as yet unclassified' }
MPrototypes class >> classPrototypeMetaclass [
	^ PrototypesPrototype 
]

{ #category : #hooks }
MPrototypes >> defaultGlobalVariables [
	^ super defaultGlobalVariables
		add:
			((GlobalModel named: #Smalltalk parent: self)
				role: #Smalltalk);
		yourself
]

{ #category : #hooks }
MPrototypes >> hookCreateSmalltalkInstance [
	| smalltalkImageDef smalltalk remoteSystemDictionary |
	smalltalkImageDef := self
		classWithRole: #SmalltalkImage.
	remoteSystemDictionary := self remote objectSpace systemDictionary systemDictionary.
	smalltalkImageDef
		ifNotNil: [ 
			smalltalk := smalltalkImageDef remote basicNew.
			smalltalk instanceVariableAtIndex: 1 put: remoteSystemDictionary.
			remoteSystemDictionary
				at: (self globalWithRole: #Smalltalk) name
				put: smalltalk. ].
	^ smalltalk
]

{ #category : #hooks }
MPrototypes >> hookInitalizeGlobals [
	^ ((self classNamed: #SystemDictionary) remote new) asRemoteSystemDictionary.
	
]

{ #category : #hooks }
MPrototypes >> hookInitializeProcessScheduler [ 
	
	|code processor|
	processor := super hookInitializeProcessScheduler .
	code := 
		'Smalltalk globals at: #Processor put: processor.
		Smalltalk at: #Processor.
		Smalltalk globals at: #MiGlobal put: 123456.
		processor'.
	^ (self newInstruction
		code: code;
		temps: {#processor -> processor};
		yourself ) evaluate

]

{ #category : #hooks }
MPrototypes >> hookInitializeSpecialObjectsArray [
	
	self remote bootstrapInterpreter
		evaluateCode: 'Smalltalk specialObjectsArray: newArray.'
		withTemps: { 'newArray' -> self remote espellBackend specialObjectsArray }.
]

{ #category : #hooks }
MPrototypes >> hookNewSystemDictionary [
	self deprecated: 'return the system dictionary fom the hookInitializeGlobals'.
	^ self evaluateCode: 'Smalltalk globals'
]

{ #category : #hooks }
MPrototypes >> hookSetSpecialObjectsArray: anEP2RemoteArray [
		
	^ (self newInstruction 
		code: 'Smalltalk specialObjectsArray: anArray';
		temps: { 'anArray' -> anEP2RemoteArray };
		yourself)
	
]

{ #category : #hooks }
MPrototypes >> loadCustomClasses [
	| package classPrototype methodStart methodProperties methodName methodSetTo methodDoesNotUnderstand |
	super loadCustomClasses.
	" we have only one package to the moment "
	package := self ensurePackageNamed: 'Kernel-Prototypes'.

	"Prototype class"
	classPrototype := self class classPrototypeMetaclass
		named: #Prototype
		parent: self.
	package addDefinedBehavior: classPrototype.
	self addBehavior: classPrototype.
	
	classPrototype
		layout: (EP2FixedLayout on: classPrototype);
		superclass: (self classNamed: #Object);
		package: package;
		addSlot: #superclass;
		addSlot: #methodDict;
		addSlot: #format;
		addSlot: #name;
		addSlot: #instVarNames;
		addSlot: #properties.
	
	"Methods"
	classPrototype
		addLocalMethodFromSource: 'properties
	^ properties ifNil: [properties := IdentityDictionary new]'
		selector: #properties.
	
	classPrototype
		addLocalMethodFromSource: 'set: propertyName to: anObject
	self properties at: propertyName put: anObject'
		selector: #set:to:.
	
	classPrototype
		addLocalMethodFromSource: 'get: propertyName
	^ self properties at: propertyName'
		selector: #get:.
	
	classPrototype
		addLocalMethodFromSource: 'doesNotUnderstand: msg
	^ self properties at: msg selector'
		selector: #doesNotUnderstand.
	
	classPrototype
		addLocalMethodFromSource: 'name
	^ name'
		selector: #name.
		
	
	
(self classNamed: #BlockClosure)
addLocalMethodFromSource: 'on: exception do: handlerAction
	<primitive: 199>  
	^ self value' selector: #on:do:.
	

((self classNamed: #Object) methodDict at: #error:)
sourceCode: 'error: aString
	"The default behavior for error: is the same as halt:. The code is replicated in order to avoid having an extra message send on the stack. This additional message is the one a subclass should override in order to change the error handling behavior."
	| handler |
	System log: ''Error: '', aString asString.
	System log: Character cr asString, ''CallStack:''.
	System log: thisContext stringCallStack asString.
	
	(handler := (Smalltalk at: #Processor) activeProcess errorHandler)
		ifNil: [ self handleExceptionName: aString context: thisContext ]
		ifNotNil: [ handler value: aString value: self ]'
.
]

{ #category : #hooks }
MPrototypes >> loadCustomClassesOld [
	| package classPrototype classStudent classCaro methodAvg methodStart methodInstVarsDict methodName |
	super loadCustomClasses .
	" we have only one package to the moment "
	package := self ensurePackageNamed: 'Kernel-Prototypes'.
	classPrototype := self class classPrototypeMetaclass named: #Prototype parent: self.
	classPrototype	layout: (EP2FixedLayout on: classPrototype);
		superclass: (self classNamed: #Object);
		package: package;
		addSlot: #superclass;
		addSlot: #methodDict;
		addSlot: #format;
		addSlot: #name;
		addSlot: #instVarNames;
		addSlot: #instVarsDict.
	methodInstVarsDict := (self class methodMetaclass named: #instVarsDict parent: classPrototype)
		sourceCode: 
'instVarsDict
	^ instVarsDict ifNil: [instVarsDict := IdentityDictionary new]';
		selector: #instVarsDict;
		yourself.
	methodName := (self class methodMetaclass named: #name parent: classPrototype)
		sourceCode: 
'name
	^ name';
		selector: #name;
		yourself.
	methodStart := (self class methodMetaclass named: #start parent: classPrototype)
		sourceCode: 
'start
	| caroAvg studentAvg |
	System log: '' Welcome to Prototypes '', File new imageName asString.
	System log: thisContext stringCallStack.
	Caro grades: #(7 7 6).
	System log: '' Caro grades after ->'' , Caro grades asString.
	System log: '' Size of an array ->'' , #(1 2 3 4) size asString.
	System log: '' Caro instVarsDict  ->'' , Caro instVarsDict asString.
	System log: '' Caro grades class ->'' , Caro grades class asString.
	
	caroAvg := Caro grades average.
	System log: '' Caro grades average ->'' , caroAvg asString.
	
	
	System log: '' Prototype grades before ->'' , Prototype grades asString. 
	Prototype grades: #(1 1 1).
	System log: '' Prototype grades after ->'' , Prototype grades asString. 
	
	System log: '' Student grades before ->'' , Student grades asString. 
	Student grades: #(4 2 3).
	System log: '' Student grades after ->'' , Student grades asString. 
	System log: '' Student grades after ->'' , Student avg asString.
	
	System log: '' Caro grades after ->'' , Caro grades asString. 
	studentAvg := Student avg.
	 
	System log: '' Student grades average ->'' , studentAvg asString. 
	
	System snapshotAndQuit ';
		selector: #start;
		yourself.
	classPrototype addLocalMethod: methodStart.
	classPrototype addLocalMethod: methodInstVarsDict.
	classPrototype addLocalMethod: methodName.
	package addDefinedBehavior: classPrototype.
	self addBehavior: classPrototype.
	
	classStudent := self class classPrototypeMetaclass named: #Student parent: self.
	classStudent layout: (EP2FixedLayout on: classStudent);
		superclass: classPrototype;
		package: package.
	methodAvg := (self class methodMetaclass named: #avg parent: classStudent)
		sourceCode: 'avg 
		^ self grades average';
		selector: #avg;
		yourself.
	classStudent addLocalMethod: methodAvg.
	self addBehavior: classStudent.
	package addDefinedBehavior: classStudent.
	
	classCaro := self class classPrototypeMetaclass named: #Caro parent: self.
	classCaro layout: (EP2FixedLayout on: classCaro);
		superclass: classStudent;
		package: package.
	package addDefinedBehavior: classCaro.
	self addBehavior: classCaro
]
