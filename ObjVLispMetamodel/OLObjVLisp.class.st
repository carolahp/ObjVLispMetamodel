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
	loader registerClass: theNewMetaclass named: model name.

	self assert: theNewMetaclass basicClass = theNewMetaclass.
	^ theNewMetaclass
]
