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
OLObjVLisp >> entryPointCode [
	^ '
	| p |
	p := Point new.
	System log: ''before garbage collection''.
	System garbageCollect.
	System log: ''after garbage collection''.
	p setPinnedInMemory: true. 
	System log: ''after pinning object collection''.
	System garbageCollect.
	System log: ''after pinning and garbage collection''.
	System snapshotAndQuit'
]

{ #category : #hooks }
OLObjVLisp >> hookInitializeSpecialObjectsArray [
	^ nil
]
