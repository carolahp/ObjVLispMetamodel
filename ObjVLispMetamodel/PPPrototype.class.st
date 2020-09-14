Class {
	#name : #PPPrototype,
	#superclass : #MExplicitMetaclassesClass,
	#instVars : [
		'name',
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
	| getterCode setterCode binding getter setter |

	getterCode := 'grades ^self instVarsDict at: #grades ifAbsent: [nil]'.
	setterCode := 'grades:aValue self instVarsDict at: #grades put: aValue'.
	
	getter := (self parent class methodMetaclass named: #grades parent: self)
		sourceCode: getterCode;
		selector: #grades;
		yourself.
	setter := (self parent class methodMetaclass named: #grades: parent: self)
		sourceCode: setterCode;
		selector: #grades:;
		yourself.
	
	self addLocalMethod: getter.
	self addLocalMethod: setter.
	
	
	super installMethods.


	"binding := {} asDictionary .
	"
		
	"self installPrototypeAccessor: getterCode selector: #grades binding: binding.
	self installPrototypeAccessor: setterCode selector: #grades: binding: binding"
]

{ #category : #'installing methods' }
PPPrototype >> installPrototypeAccessor: code selector: selector binding: binding [
	| classBinding localCompiledMethod remoteCompiledMethod |
	
	classBinding := PPBinding new class: self; environment: self remote backend builder; yourself.
	
	localCompiledMethod := (OpalCompiler new
	source: code;
	environment: binding;
	class: classBinding;
	requestor: self remote backend objectSpace;
	failBlock: [ self error ];
	parse) generate.

	remoteCompiledMethod := localCompiledMethod asRemoteObjectInObjectSpace: self remote backend objectSpace.
	self remote methodDictionary at: selector asSymbol put: remoteCompiledMethod	

]

{ #category : #accessing }
PPPrototype >> installStub [
	self remoteIsInstalled
		ifTrue: [ ^ self ].
		
	"I am instance of myself, therefore I install myself directly as a metaclass stub"
	^ self installMetacircularStub
]

{ #category : #accessing }
PPPrototype >> isClass [
	^ true
]

{ #category : #accessing }
PPPrototype >> metaclass [
	^ self 
]
