Class {
	#name : #PPClass,
	#superclass : #EP2MClass,
	#category : #ObjVLispMetamodel
}

{ #category : #bindings }
PPClass >> hookInstall [
	super hookInstall.
	self remote instanceVariableNamed: #instVarNames put: self instVarNames asArray.
	self remote instanceVariableNamed: #name put: self name asSymbol
]

{ #category : #bindings }
PPClass >> innerBindingOf: aSymbol [ 
	^ nil
]
