Class {
	#name : #KernelQuit,
	#superclass : #LanguageModel,
	#category : #ObjVLispMetamodel
}

{ #category : #'hooks-api' }
KernelQuit class >> classMetaclass [
	^ KernelQuitClass
]

{ #category : #hooks }
KernelQuit >> entryPointCode [ 
	^ 'System quit'
]

{ #category : #hooks }
KernelQuit >> hookInitializeSpecialObjectsArray [
	^ nil
]

{ #category : #hooks }
KernelQuit >> hookSetSpecialObjectsArray: anEP2RemoteArray [
	^ nil
]
