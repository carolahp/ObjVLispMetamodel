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

{ #category : #hooks }
MPrototypes >> hookEntryPoint [
	| code |
	code := 'Prototype start'.
	^ self newInstruction 
		code: code
]

{ #category : #hooks }
MPrototypes >> loadCustomClasses [
	| package classPrototype classStudent classCaro methodAvg methodStart methodInstVarsDict |
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
	^ instVarsDict ifNil: [instVarsDict := IdentityDictionary new]';
		selector: #instVarsDict;
		yourself.
	methodStart := (self class methodMetaclass named: #start parent: classPrototype)
		sourceCode: 
'start
	| d |
	File log: '' Welcome to Prototypes ''.
	d := Dictionary new.
	d at: #hola put: 1.
	"File log: '' Prototype grades before ->'' , Prototype grades asString. 
	Prototype grades: 4.
	File log: '' Prototype grades after ->'' , Prototype grades asString. "
	System quit
	"Caro grades: 5.
	File log: '' Caro grades ->'' , Caro grades asString.
	System quit"';
		selector: #start;
		yourself.
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
