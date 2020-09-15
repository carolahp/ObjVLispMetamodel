Class {
	#name : #MPrototypes,
	#superclass : #EP2MLanguage,
	#category : #ObjVLispMetamodel
}

{ #category : #'as yet unclassified' }
MPrototypes class >> classMetaclass [
	^ PPClass 
]

{ #category : #'as yet unclassified' }
MPrototypes class >> classPrototypeMetaclass [
	^ PPPrototype 
]

{ #category : #hooks }
MPrototypes >> defaultGlobalVariables [
	^ super defaultGlobalVariables
		add:
			((EP2MGlobalVariable named: #Smalltalk parent: self)
				role: #Smalltalk);
		yourself
]

{ #category : #hooks }
MPrototypes >> hookEntryPoint [
	| code |
	code := 'Prototype start'.
	^ self newInstruction 
		code: code
]

{ #category : #hooks }
MPrototypes >> hookInitalizeGlobals [
	^ ((self classNamed: #SystemDictionary) remote new) asRemoteSystemDictionary.
	
]

{ #category : #hooks }
MPrototypes >> hookInitializeProcessScheduler [ 
	
	|code|
	super hookInitializeProcessScheduler .
	code := 
		'Smalltalk globals at: #Processor put: Processor.
		Smalltalk at: #Processor.
		Smalltalk globals at: #MiGlobal put: 123456'.
	^ (self newInstruction
		code: code;
		temps: #();
		yourself ) evaluate

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
	| package classPrototype classStudent classCaro methodAvg methodStart methodInstVarsDict methodName |
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
	System log: (Smalltalk at: #MiGlobal) asString.
	Caro grades: #(7 7 6).
	System log: '' Caro grades after ->'' , Caro grades asString.
	System log: '' Size of an array ->'' , #(1 2 3 4) size asString.
	System log: '' Caro instVarsDict  ->'' , Caro instVarsDict asString.
	System log: '' Caro grades class ->'' , Caro grades class asString.
	
	caroAvg := Caro avg.
	System log: '' Caro grades average ->'' , caroAvg asString.
	
	
	"System log: '' Prototype grades before ->'' , Prototype grades asString. 
	Prototype grades: #(1 1 1).
	System log: '' Prototype grades after ->'' , Prototype grades asString. 
	
	System log: '' Student grades before ->'' , Student grades asString. 
	Student grades: #(4 2 3).
	System log: '' Student grades after ->'' , Student grades asString. 
	System log: '' Student grades after ->'' , Student avg asString.
	
	System log: '' Caro grades before ->'' , Caro grades asString. 
	studentAvg := Student avg.
	 
	System log: '' Student grades average ->'' , studentAvg asString. "
	
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
		sourceCode: 'avg ^ self grades average';
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
