Class {
	#name : #KernelQuit,
	#superclass : #EP2MLanguage,
	#category : #ObjVLispMetamodel
}

{ #category : #'hooks-api' }
KernelQuit class >> classMetaclass [
	^ KernelQuitClass
]

{ #category : #hooks }
KernelQuit >> entryPointCode [ 
	^ 'Class start'
]

{ #category : #hooks }
KernelQuit >> hookInitializeSpecialObjectsArray [
	^ nil
]

{ #category : #hooks }
KernelQuit >> hookSetSpecialObjectsArray: anEP2RemoteArray [
	^ nil
]
