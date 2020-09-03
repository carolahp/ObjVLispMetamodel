"
I am the metamodel of a class in ObjVLisp.
"
Class {
	#name : #MObjVLispClass,
	#superclass : #EP2MClass,
	#category : #ObjVLispMetamodel
}

{ #category : #hooks }
MObjVLispClass >> hookInstall [
	super hookInstall.
	self remote instanceVariableNamed: #instVarNames put: self instVarNames asArray.
	self remote instanceVariableNamed: #name put: self name asSymbol
]

{ #category : #bindings }
MObjVLispClass >> innerBindingOf: aSymbol [ 
	"in ObjVLisp there are no class variables"
	^nil
]

{ #category : #testing }
MObjVLispClass >> test [
	super test
]
