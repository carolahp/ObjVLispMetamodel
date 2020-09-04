Class {
	#name : #PPBinding,
	#superclass : #EP2CrossCompilerBinding,
	#category : #ObjVLispMetamodel
}

{ #category : #binding }
PPBinding >> binding [ 
	^ EP2GlobalBinding  new
			name: class name; 
			objectSpace: environment objectSpace;
			yourself 
]

{ #category : #binding }
PPBinding >> bindingOf: aString [
	"There are no class variables nor shared pools"
	"Therefore it is a temp or an instance variable"
	^ nil
]
