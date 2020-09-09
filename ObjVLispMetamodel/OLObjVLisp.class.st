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

{ #category : #hooks }
OLObjVLisp >> hookEntryPoint [
	| code |
	code := 'Class start'.
	^ self newInstruction 
		code: code
]
