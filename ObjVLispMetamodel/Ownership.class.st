Class {
	#name : #Ownership,
	#superclass : #LanguageModel,
	#category : #ObjVLispMetamodel
}

{ #category : #'hooks-api' }
Ownership class >> classMetaclass [
	" Return the subclass of EP2MClass that defines the metamodel for classes of the language "
	^ OwnershipClass 
]

{ #category : #hooks }
Ownership >> entryPointCode [ 
	^ 'Ownership start'
]

{ #category : #hooks }
Ownership >> hookInitializeSpecialObjectsArray [
	
	^nil
]

{ #category : #hooks }
Ownership >> loadCustomClasses [
	| package methodStart classOwnershipMeta classOwnership |
	super loadCustomClasses.
	" we have only one package to the moment "
	package := self ensurePackageNamed: 'Kernel-Ownership'.
	classOwnershipMeta := self class classMetaclass named: #OwnershipMeta parent: self.
	classOwnershipMeta	layout: (EP2FixedLayout on: classOwnershipMeta);
		superclass: (self classNamed: #Class);
		metaclass: (self classNamed: #Class);
		package: package.
		
	methodStart := (self class methodMetaclass named: #start parent: classOwnershipMeta)
		sourceCode: 
'start
	System log: ''asd''.
	System quit ';
		selector: #start;
		yourself.
	classOwnershipMeta addLocalMethod: methodStart.
	package addDefinedBehavior: classOwnershipMeta.
	self addBehavior: classOwnershipMeta.
	classOwnership := self class classMetaclass named: #Ownership parent: self.
	classOwnership	layout: (EP2FixedLayout on: classOwnership);
		metaclass: (self classNamed: #OwnershipMeta);
		superclass: (self classNamed: #Object);
		package: package.
	package addDefinedBehavior: classOwnership.
	self addBehavior: classOwnership.
	
	
]
