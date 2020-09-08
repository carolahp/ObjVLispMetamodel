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
	
	| remoteMetaclassClass newClass |
	remoteMetaclassClass := self metaclass remote.
	remoteMetaclassClass isNilObject
		ifTrue: [ "install class with role metaclass"
			remoteMetaclassClass := self metaclass installMetacircularStub ].
	newClass := self metaclass newStubWithFormat: self format.
	^ newClass
]

{ #category : #accessing }
MObjVLispClass >> metaclass [ 
	^ self parent classMetaclass
]
