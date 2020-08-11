"
I am the metamodel of a class in ObjVLisp.
I am used to bootstrap ObjVLisp using the PharoBootstrapGeneric.
I require PharoBootstrapGeneric and its dependencies (including Espell2).
"
Class {
	#name : #OLClass,
	#superclass : #EP2MClass,
	#instVars : [
		'instVarNames'
	],
	#category : #ObjVLispMetamodel
}

{ #category : #'accessing-backend' }
OLClass >> classSide [
	^ self parent classMetaclass
]

{ #category : #hooks }
OLClass >> hookInstall [
	| remoteMethodDict remoteSuperclass |
	
	"we install an empty methodDict, it will be filled lated"
	remoteMethodDict := EP2RemoteDictionary newWithBackend: self parent remote espellBackend.
	remoteSuperclass := self superclass ifNil: [nil] ifNotNil:[self parent remote classNamed: self superclass name].
	self remote 
		methodDictionary: remoteMethodDict;
		superclass: remoteSuperclass;
		format: self format.
	
	self remote instanceVariableNamed: #instVarNames put: self instVarNames
	
]

{ #category : #accessing }
OLClass >> instVarNames: aCollection [ 
	instVarNames := aCollection
]

{ #category : #hooks }
OLClass >> installMethods [
	| methods remoteClass |
	methods := (self methodBuilder methodsFromDefinition: self)
		sorted: [ :a :b | a selector < b selector ].
	methods do:
			[ :method | self remote methodDictionary at: method selector put: method ]
]

{ #category : #testing }
OLClass >> test [
	self assert: true
]
