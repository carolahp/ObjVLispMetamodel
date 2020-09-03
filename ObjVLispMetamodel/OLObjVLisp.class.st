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
	^ MObjVLispClass
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
OLObjVLisp >> hookEntryPoint [
	| code |
	code := 'Class start'.
	^ self newInstruction 
		code: code
]
