"
I am the metamodel of a class in ObjVLisp.
"
Class {
	#name : #MObjVLispClass,
	#superclass : #EP2MClass,
	#instVars : [
		'instVarNames'
	],
	#category : #ObjVLispMetamodel
}

{ #category : #'accessing-backend' }
MObjVLispClass >> classSide [
	^ self metaclass
]

{ #category : #hooks }
MObjVLispClass >> hookInstall [
	| remoteMethodDict remoteSuperclass |
	
	"we install an empty methodDict, it will be filled lated"
	remoteMethodDict := EP2RemoteMethodDictionary newWithBackend: self parent remote espellBackend.
	remoteSuperclass := self superclass ifNil: [nil] ifNotNil:[self parent remote classNamed: self superclass name].
	self remote 
		methodDictionary: remoteMethodDict;
		superclass: remoteSuperclass;
		format: self format.
	self remote instanceVariableNamed: #instVarNames put: self instVarNames asArray.
	self remote instanceVariableNamed: #name put: self name asSymbol
]

{ #category : #bindings }
MObjVLispClass >> innerBindingOf: aSymbol [ 
	"in ObjVLisp there are no class variables"
	^nil
]

{ #category : #accessing }
MObjVLispClass >> instVarNames: aCollection [ 
self halt.
	instVarNames := aCollection
]

{ #category : #hooks }
MObjVLispClass >> installMethods [
	| methods |
	methods := (self methodBuilder methodsFromDefinition: self)
		sorted: [ :a :b | a selector < b selector ].
	methods do:
			[ :method | self remote methodDictionary at: method selector put: method ]
]

{ #category : #'accessing-backend' }
MObjVLispClass >> metaclass [
	^ self parent classMetaclass
]

{ #category : #testing }
MObjVLispClass >> test [
	super test
]
