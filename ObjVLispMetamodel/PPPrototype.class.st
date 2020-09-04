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
	(instVarsNames indexOf: aString) = 0 ifFalse: [ self error: 'Attempt to add two instance variables with the same name'. ^ false ].
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
PPPrototype >> installMethods [
	| sourceCode binding classBinding localCompiledMethod remoteCompiledMethod |
	
	super installMethods.
	self remote.
	sourceCode := 'grades ^ grades'.
	binding := { #grades -> nil } asDictionary.
	classBinding := PPBinding new class: self; environment: self remote backend builder; yourself.
	localCompiledMethod := (OpalCompiler new
		source: sourceCode;
		environment: binding;
		class: classBinding;
		requestor: self remote backend objectSpace;
		failBlock: [ self error ];
		parse) generate.
	
	remoteCompiledMethod := localCompiledMethod asRemoteObjectInObjectSpace: self remote backend objectSpace.
	self remote methodDictionary at: #grades put: remoteCompiledMethod
]

{ #category : #accessing }
PPPrototype >> installStub [
	self remote isNilObject
		ifFalse: [ ^ self ].
		
	"I am instance of myself, therefore I install myself directly as a metaclass stub"
	^ self installMetaclassStub
]

{ #category : #accessing }
PPPrototype >> isClass [
	^ true
]

{ #category : #accessing }
PPPrototype >> metaclass [
	^ self 
]
