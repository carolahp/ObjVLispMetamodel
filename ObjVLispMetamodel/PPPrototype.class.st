Class {
	#name : #PPPrototype,
	#superclass : #MExplicitMetaclassesClass,
	#instVars : [
		'name',
		'instVarNames',
		'instVarsDict'
	],
	#category : #ObjVLispMetamodel
}

{ #category : #bindings }
PPPrototype >> addInstVar: aString [
	(instVarNames indexOf: aString) = 0 ifFalse: [ self error: 'Attempt to add two instance variables with the same name'. ^ false ].
	instVarNames add: aString
]

{ #category : #accessing }
PPPrototype >> hookInstall [
	super hookInstall.
	
	self remote 
		name: (self toRemoteObject: self name asSymbol);
		instVarNames: (self toRemoteObject: self instVarNames asArray).
	^ self remote
]

{ #category : #accessing }
PPPrototype >> initialize [
	super initialize.
	instVarNames := #() asOrderedCollection.
	
]

{ #category : #bindings }
PPPrototype >> innerBindingOf: aSymbol [ 
	^ nil
]

{ #category : #accessing }
PPPrototype >> installMethods [
	| getterCode setterCode getter setter testCode test |

	getterCode := 'grades ^self instVarsDict at: #grades ifAbsent: [nil]'.
	setterCode := 'grades:aValue self instVarsDict at: #grades put: aValue'.
	testCode := 'grades1 ^grades'.
	
	getter := (self parent class methodMetaclass named: #grades parent: self)
		sourceCode: getterCode;
		selector: #grades;
		yourself.
	setter := (self parent class methodMetaclass named: #grades: parent: self)
		sourceCode: setterCode;
		selector: #grades:;
		yourself.
	test := (self parent class methodMetaclass named: #grades1 parent: self)
		sourceCode: testCode;
		selector: #grades1;
		yourself.
	self addLocalMethod: getter.
	self addLocalMethod: setter.
	self addLocalMethod: test.
	
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
PPPrototype >> installStubCustom [
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

{ #category : #hooks }
PPPrototype >> parserClass [ 
	^ PrototypesParser
]
