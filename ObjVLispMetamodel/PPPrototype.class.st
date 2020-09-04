Class {
	#name : #PPPrototype,
	#superclass : #EP2MClass,
	#instVars : [
		'instVarsNames'
	],
	#category : #ObjVLispMetamodel
}

{ #category : #bindings }
PPPrototype >> addInstVar: aString [
	(instVarsNames indexOf: aString) > 0 ifFalse: [ self error: 'Attempt to add two instance variables with the same name'. ^ false ].
	instVarsNames add: aString
]

{ #category : #accessing }
PPPrototype >> initialize [
	super initialize.
	instVarsNames := #() asOrderedCollection.
	
]

{ #category : #bindings }
PPPrototype >> innerBindingOf: aSymbol [ 
	^ nil
]

{ #category : #accessing }
PPPrototype >> installStub [
	self remote isNilObject
		ifFalse: [ ^ self ].
		
	"I am instance of myself, therefore I install myself directly as a metaclass stub"
	^ self installMetaclassStub
]

{ #category : #accessing }
PPPrototype >> metaclass [
	^ self 
]
