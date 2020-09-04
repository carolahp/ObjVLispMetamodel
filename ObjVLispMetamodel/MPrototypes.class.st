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
	| package classPrototype classProtoPrototype classStudent classCaro methodAvg |
	" we have only one package to the moment "
	package := self packages anyOne.
	classProtoPrototype := self class classPrototypeMetaclass named: #ProtoPrototype parent: self.
	classProtoPrototype	layout: (EP2FixedLayout on: classProtoPrototype);
		superclass: (self classNamed: #Object);
		package: package;
		addSlot: #superclass;
		addSlot: #methodDict;
		addSlot: #format.
	package addDefinedBehavior: classProtoPrototype.
	self addBehavior: classProtoPrototype.
	
	"classPrototype := self class classPrototypeMetaclass named: #Prototype parent: self.
	classPrototype	layout: (EP2FixedLayout on: classPrototype);
		superclass: (self classNamed: #ProtoPrototype);
		package: package.
	package addDefinedBehavior: classPrototype.
	self addBehavior: classPrototype.
	
	classStudent := self class classPrototypeMetaclass named: #Student parent: self.
	classStudent layout: (EP2FixedLayout on: classStudent);
		superclass: classPrototype;
		package: package;
		addSlot: #grades.
	methodAvg := (self class methodMetaclass named: #avg parent: classStudent)
		sourceCode: 'avg ^ grades avg';
		selector: #avg;
		yourself.
	classStudent addLocalMethod: methodAvg.
	self addBehavior: classStudent.
	package addDefinedBehavior: classStudent.
	
	classCaro := self class classPrototypeMetaclass named: #Caro parent: self.
	classCaro layout: (EP2FixedLayout on: classCaro);
		superclass: classStudent;
		package: package.
	package addDefinedBehavior: classCaro.
	self addBehavior: classCaro.
	"
]
