Class {
	#name : #MPrototypes,
	#superclass : #EP2MLanguage,
	#category : #ObjVLispMetamodel
}

{ #category : #'as yet unclassified' }
MPrototypes class >> classMetaclass [
	^ PPClass 
]

{ #category : #'as yet unclassified' }
MPrototypes class >> classPrototypeMetaclass [
	^ PPPrototype 
]

{ #category : #'as yet unclassified' }
MPrototypes class >> indexedSlotMetaclass [
	^ EP2MIndexedSlot
]

{ #category : #'as yet unclassified' }
MPrototypes class >> instanceVariableSlotMetaclass [
	^ EP2MInstanceVariableSlot 
]

{ #category : #'as yet unclassified' }
MPrototypes class >> methodMetaclass [ 
	^ EP2MMethod
]

{ #category : #hooks }
MPrototypes >> hookEntryPoint [
	| code |
	code := 'Prototype start'.
	^ self newInstruction 
		code: code
]

{ #category : #hooks }
MPrototypes >> loadCustomClasses [
	| package classPrototype classStudent classCaro methodAvg methodStart methodLog methodInstVarsDict |
	" we have only one package to the moment "
	package := self packages anyOne.
	classPrototype := self class classPrototypeMetaclass named: #Prototype parent: self.
	classPrototype	layout: (EP2FixedLayout on: classPrototype);
		superclass: (self classNamed: #Object);
		package: package;
		addSlot: #superclass;
		addSlot: #methodDict;
		addSlot: #format;
		addSlot: #instVarsDict.
	methodInstVarsDict := (self class methodMetaclass named: #instVarsDict parent: classPrototype)
		sourceCode: 
'instVarsDict
	^ instVarsDict ifNil: [instVarsDict := IdentityDictionary basicNew init:4; yourself]';
		selector: #instVarsDict;
		yourself.
	methodLog := (self class methodMetaclass named: #log: parent: classPrototype)
		sourceCode: 
'log: aString
	| f path |
	f := File new. 
	path := f localFolderPath, ''.txt''.
	f openReadWrite: path.
	f position: f size.
	f nextPutAll: aString.
	f close';
		selector: #log:;
		yourself.
	methodStart := (self class methodMetaclass named: #start parent: classPrototype)
		sourceCode: 
'start
	self log: '' Welcome to Prototypes ''.
	self log: Prototype grades asString. 
	Prototype grades: 4.
	self log: '' Prototype grades ->'' , Prototype grades asString. 
	"Caro grades: 5.
	self log: '' Caro grades ->'' , Caro grades asString.
	Class quit"';
		selector: #start;
		yourself.
	classPrototype addLocalMethod: methodLog.
	classPrototype addLocalMethod: methodStart.
	classPrototype addLocalMethod: methodInstVarsDict.
	package addDefinedBehavior: classPrototype.
	self addBehavior: classPrototype.
	
	"classStudent := self class classPrototypeMetaclass named: #Student parent: self.
	classStudent layout: (EP2FixedLayout on: classStudent);
		superclass: classPrototype;
		package: package;
		addSlot: #superclass;
		addSlot: #methodDict;
		addSlot: #format;
		addInstVar: #grades.
	methodAvg := (self class methodMetaclass named: #avg parent: classStudent)
		sourceCode: 'avg ^ self grades avg';
		selector: #avg;
		yourself.
	classStudent addLocalMethod: methodAvg.
	self addBehavior: classStudent.
	package addDefinedBehavior: classStudent.
	
	classCaro := self class classPrototypeMetaclass named: #Caro parent: self.
	classCaro layout: (EP2FixedLayout on: classCaro);
		superclass: classStudent;
		package: package;
		addSlot: #superclass;
		addSlot: #methodDict;
		addSlot: #format.
	package addDefinedBehavior: classCaro.
	self addBehavior: classCaro"
]
