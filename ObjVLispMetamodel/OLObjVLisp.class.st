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
OLObjVLisp >> hookCreateInitialObjects [
	^ self newDummyInstruction 
]

{ #category : #hooks }
OLObjVLisp >> hookCreateMetaclassStubWithClassLoader: aClassLoader [ 
	| model loader metaclassIndex classIndex theNewMetaclass theNewMetaclassClass |
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
OLObjVLisp >> hookNewSystemDictionary [
	^ self newDummyInstruction 
]

{ #category : #hooks }
OLObjVLisp >> hookRegisterClass: anEP2RemoteClass fromDefinition: anOLClass [ 
	^ self newDummyInstruction 
]
