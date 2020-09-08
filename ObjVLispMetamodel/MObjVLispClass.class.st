"
I am the metamodel of a class in ObjVLisp.
"
Class {
	#name : #MObjVLispClass,
	#superclass : #EP2MClass,
	#category : #ObjVLispMetamodel
}

{ #category : #bindings }
MObjVLispClass >> extendWithMonticelloCustom: aMCClassDefinition [
	^ self
]

{ #category : #hooks }
MObjVLispClass >> hookInstall [
	super hookInstall.
	self remote instanceVariableNamed: #instVarNames put: self instVarNames asArray.
	self remote instanceVariableNamed: #name put: self name asSymbol
]

{ #category : #initialization }
MObjVLispClass >> initializeWithTemplateCustom: aClass [ 
	^ self
]

{ #category : #bindings }
MObjVLispClass >> innerBindingOf: aSymbol [ 
	"in ObjVLisp there are no class variables"
	^nil
]

{ #category : #hooks }
MObjVLispClass >> installStubCustom [
	self metaclass = self
		ifTrue: [ ^ self installMetacircularStub ].
	"first install the stub of my metaclass"
	self metaclass installStub.
	"instantiate my metaclass to create a stub of me"
	^ self metaclass newStubWithFormat: self format
	
]

{ #category : #accessing }
MObjVLispClass >> metaclass [ 
	^ self parent classMetaclass
]
