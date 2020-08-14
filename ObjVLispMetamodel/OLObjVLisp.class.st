"
I am the metamodel of the ObjVLisp language definition.
I require the PharoBootstrapGeneric and its dependencies.
"
Class {
	#name : #OLObjVLisp,
	#superclass : #EP2MLanguage,
	#category : #ObjVLispMetamodel
}

{ #category : #'as yet unclassified' }
OLObjVLisp class >> classMetaclass [
	^ OLClass
]

{ #category : #'hooks-api' }
OLObjVLisp class >> indexedSlotMetaclass [
	^ EP2MIndexedSlot
]

{ #category : #'hooks-api' }
OLObjVLisp class >> instanceVariableSlotMetaclass [
	^ EP2MInstanceVariableSlot 
]

{ #category : #'as yet unclassified' }
OLObjVLisp class >> methodMetaclass [ 
	^ EP2MMethod
]

{ #category : #hooks }
OLObjVLisp >> classByRoleOrName: aString ifAbsent: aBlock [
	"extending the original classByRoleOrName:ifAbsent: method to consider searching classes by system mapping"
	|class|
	
	class := super classByRoleOrName: aString ifAbsent: [nil].
	class ifNil: [ class := self classBySystemMapping: aString ifAbsent: [ nil ] ].
	class ifNil: [^ aBlock value].
	^ class
]

{ #category : #'accessing classes' }
OLObjVLisp >> classBySystemMapping: aString [ 
	^ self classBySystemMapping: aString ifAbsent: [  PBClassDefinitionNotFound signal ]
]

{ #category : #hooks }
OLObjVLisp >> classBySystemMapping: aString ifAbsent: aBlockClosure [ 
	"Classes in metamodel map classes in the system according to systemClassMapping definition"
	| className |
	className := self systemClassMapping at: aString ifAbsent: nil.
	className ifNil: [^ aBlockClosure value].
	^ self classNamed: className
]

{ #category : #hooks }
OLObjVLisp >> hookCreateInitialObjects [
	^ self newDummyInstruction 
]

{ #category : #hooks }
OLObjVLisp >> hookCreateMetaclassStubWithClassLoader: aClassLoader [ 
	| model loader metaclassIndex theNewMetaclass |
	" We need to create the metaclass and its respective metaclass (the metaclass class) "
	loader := aClassLoader.
	model := self classMetaclass.
	
	metaclassIndex := aClassLoader newClassIndex.
	
	"This is Metaclass"
	theNewMetaclass := loader
		createStubForClassNamed: model name
		metaclassIndex: metaclassIndex
		newClassIndex: metaclassIndex.
		
	loader registerClass: theNewMetaclass definition: model fullyLoaded: false.


	self assert: theNewMetaclass basicClass = theNewMetaclass.
	^ theNewMetaclass
]

{ #category : #hooks }
OLObjVLisp >> hookGlobalNotFound: aString [
	| localClass |
	"load missing class from the system"
	localClass := Smalltalk classNamed: aString.
	localClass ifNil: [ ^ nil ].
	(self
		confirm: 'Load class ' , aString , ' from host system to model?')
		ifTrue: [ | newClass |
			"getting the class from the system"
			newClass := self class classMetaclass new
				parent: self;
				initializeWithLocal: localClass;
				yourself.
			self addBehavior: newClass.
			^ newClass ]
]

{ #category : #hooks }
OLObjVLisp >> hookInitalizeGlobals [
	^ self newDummyInstruction
]

{ #category : #hooks }
OLObjVLisp >> hookInitializeClassStubs [
	^ self newDummyInstruction 
]

{ #category : #hooks }
OLObjVLisp >> hookInstallClass: aClassDefinition [
	
	aClassDefinition hookInstall.
	aClassDefinition test.
	^ aClassDefinition remote
]

{ #category : #hooks }
OLObjVLisp >> hookInstallMethods [
	self allClasses do: [ :class | class installMethods ]
]

{ #category : #hooks }
OLObjVLisp >> hookMainProcess [
	| code |
	code := 'Class start'.
	^ self newInstruction 
		code: code
]

{ #category : #hooks }
OLObjVLisp >> hookNewSystemDictionary [
	^ self newDummyInstruction 
]

{ #category : #hooks }
OLObjVLisp >> hookRegisterClass: anEP2RemoteClass fromDefinition: anOLClass [ 
	self classLoader
		registerClass: anEP2RemoteClass asRemoteClass
		definition: anOLClass
		fullyLoaded: true.
]
