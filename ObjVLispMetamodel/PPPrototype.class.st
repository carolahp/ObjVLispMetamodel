Class {
	#name : #PPPrototype,
	#superclass : #EP2MClass,
	#category : #ObjVLispMetamodel
}

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
