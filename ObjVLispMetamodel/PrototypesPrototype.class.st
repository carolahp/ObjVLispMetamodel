Class {
	#name : #PrototypesPrototype,
	#superclass : #ExplicitMetaclassesClass,
	#instVars : [
		'name',
		'instVarNames',
		'instVarsDict'
	],
	#category : #ObjVLispMetamodel
}

{ #category : #bindings }
PrototypesPrototype >> addInstVar: aString [
	(instVarNames indexOf: aString) = 0 ifFalse: [ self error: 'Attempt to add two instance variables with the same name'. ^ false ].
	instVarNames add: aString
]

{ #category : #accessing }
PrototypesPrototype >> hookInstall [
	super hookInstall.
	
	self remote 
		name: (self toRemoteObject: self name asSymbol);
		instVarNames: (self toRemoteObject: self instVarNames asArray).
	^ self remote
]

{ #category : #accessing }
PrototypesPrototype >> initialize [
	super initialize.
	instVarNames := #() asOrderedCollection.
	
]

{ #category : #bindings }
PrototypesPrototype >> innerBindingOf: aSymbol [ 
	^ nil
]

{ #category : #accessing }
PrototypesPrototype >> installMethods [
	| getterCode setterCode getter setter testCode test |

	getterCode := 'grades ^self instVarsDict at: #grades ifAbsent: [nil]'.
	setterCode := 'grades:aValue self instVarsDict at: #grades put: aValue'.
	testCode := 'grades1 ^grades'.
		
	self addLocalMethodFromSource: getterCode selector: #grades.
	self addLocalMethodFromSource: setterCode selector: #'grades:'.
	self addLocalMethodFromSource: testCode selector: #grades1.
	
	super installMethods.


	"binding := {} asDictionary .
	"
		
	"self installPrototypeAccessor: getterCode selector: #grades binding: binding.
	self installPrototypeAccessor: setterCode selector: #grades: binding: binding"
]

{ #category : #'installing methods' }
PrototypesPrototype >> installPrototypeAccessor: code selector: selector binding: binding [
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
PrototypesPrototype >> installStubCustom [
	"I am instance of myself, therefore I install myself directly as a metaclass stub"
	^ self installMetacircularStub
]

{ #category : #accessing }
PrototypesPrototype >> isClass [
	^ true
]

{ #category : #accessing }
PrototypesPrototype >> metaclass [
	^ self 
]

{ #category : #hooks }
PrototypesPrototype >> parserClass [ 
	^ PrototypesParser
]
