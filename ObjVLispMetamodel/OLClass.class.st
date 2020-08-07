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
	| remote remoteFormat remoteMethodDict remoteSuperclass |
	remote := self remote.
	self format.
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

{ #category : #testing }
OLClass >> test [
	self assert: true
]
