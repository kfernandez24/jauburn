Class {
	#name : #JbInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'interpreter',
		'parser'
	],
	#category : #'Jauburn-Interpreter-Tests'
}

{ #category : #tests }
JbInterpreterTest >> assertInterpreterVar: var equals: value [

self assert: (interpreter environment at: var) equals: value.
]

{ #category : #utilities }
JbInterpreterTest >> interpret: aString [

	| ast |
	ast :=  parser parse: aString.
	^interpreter interpret: ast.
	
]

{ #category : #running }
JbInterpreterTest >> setUp [ 

	parser := JbParser new.
	interpreter := JbInterpreter new
]

{ #category : #tests }
JbInterpreterTest >> testAssignmentStatementExecution [
	"Testing assigning values to variabls already declared"

	self interpret: 'var x = 2; x = 7;'.
	self assert: (interpreter environment at: 'x') equals: 7.
	self interpret: 'var dogAge = 7; dogAge = 14;'.
	self assert: (interpreter environment at: 'dogAge') equals: 14.
	
	self should: [ 	self interpret: 'age = 14;' ] raise: Error. 

	
]

{ #category : #running }
JbInterpreterTest >> testDeclarationBindsVariableToExpressionValue [
	"Testing addition and multiplication"

	self interpret: 'var x = 3 + 2 * 8;'.
	self assert: (interpreter environment at: 'x') equals: 19.

	"Testing nested variable binding"
	self interpret: 'var x = 6;var y = 2*x;'.
	self assert: (interpreter environment at: 'y') equals: 12.

	"Testing subtraction operator and division operator"
	self interpret: 'var x = 7 - 6 / 2;'.
	self assert: (interpreter environment at: 'x') equals: 4.

	"Testing unary negation operator"
	self interpret: 'var x = -10;'.
	self assert: (interpreter environment at: 'x') equals: -10.

]

{ #category : #running }
JbInterpreterTest >> testDeclarationCreatesVariable [

	self interpret: 'var x = 99;'.
	self assert: (interpreter environment includesKey: 'x')
]

{ #category : #tests }
JbInterpreterTest >> testEqualsEqualsComparison [

"Testing == operator"
	self interpret: 'var x = 2; var y = true; var z = x==y;'.
	self assert: (interpreter environment at: 'z') equals: false.
	
	self interpret: 'var x = 2; var y = 2; var z = x==y;'.
	self assert: (interpreter environment at: 'z') equals: true.
	

	

]

{ #category : #tests }
JbInterpreterTest >> testFunctionCall [
	self
		interpret:
			'
var x = 0; 
var f = function () {x=99;};
f();'.
	self assertInterpreterVar: 'x' equals: 99.
	self
		interpret:
			'
var x = 0; 
var f = function () {x=99;};'.
	self assertInterpreterVar: 'x' equals: 0.
	
]

{ #category : #tests }
JbInterpreterTest >> testFunctionCallWithArguments [
	self
		interpret:
			'
var x = 0; 
var f = function (monkey, zebra) {x = monkey + zebra;};
f(5, 2*6);'.
	self assertInterpreterVar: 'x' equals: 17.
	
"Nested test"
	self
		interpret:
			'
var x = -1; 
var y = 0;
var f = function () {y = x;};
var g = function(otherFunction) { 
	var x = 99;
	otherFunction();
	};
g(f);'.
	self assertInterpreterVar: 'y' equals: -1
]

{ #category : #tests }
JbInterpreterTest >> testFunctionNodeEvaluation [
	| p |
	self interpret: 'var f = function () {var z = 1;};'.
	self assert: (interpreter environment at: 'f') body size equals: 1.
	self assert: (interpreter environment at: 'f') parameters size equals: 0.
	self
		assert: (interpreter environment at: 'f') environment
		equals: interpreter environment.
	self
		interpret:
			'var f = function (monkey, tiger) {var z = 1; var y = 10; return z + y;};'.
	self assert: (interpreter environment at: 'f') body size equals: 3.
	p := (interpreter environment at: 'f') parameters.
	self assert: p size equals: 2.
	self assert: p first equals: 'monkey'.
	self assert: p second equals: 'tiger'
]

{ #category : #tests }
JbInterpreterTest >> testGreaterThanComparison [
	"Testing > operator"

	"False case, values are the same"

	self interpret: 'var x = 2; var y = 2; var z = x > y;'.
	self assert: (interpreter environment at: 'z') equals: false.

	"False case, values are different"
	self interpret: 'var x = 2; var y = 5; var z = x > y;'.
	self assert: (interpreter environment at: 'z') equals: false.

	"True case"
	self interpret: 'var x = 2; var y = 1; var z = x > y;'.
	self assert: (interpreter environment at: 'z') equals: true
]

{ #category : #tests }
JbInterpreterTest >> testGreaterThanEqualToComparison [
	"Testing <= operator"
	
	"True Case, values are the same"
	self interpret: 'var x = 2; var y = 2; var z = x>=y;'.
	self assert: (interpreter environment at: 'z') equals: true.
	
	"True case, values are different"
	self interpret: 'var x = 5; var y = 2; var z = x>=y;'.
	self assert: (interpreter environment at: 'z') equals: true.
	
	"False case"
	self interpret: 'var x = 9; var y = 10; var z = x>=y;'.
	self assert: (interpreter environment at: 'z') equals: false.
	

	

]

{ #category : #tests }
JbInterpreterTest >> testIfElseStatements [
	"Test explicit true and false cases"

	self interpret: 'var x = 5; if (true) { x = 99; } else {x = 0;};'.
	self assertInterpreterVar: 'x' equals: 99.
	self interpret: 'var x = 5; if (false) {x = 99;} else {x = 0;};'.
	self assertInterpreterVar: 'x' equals: 0.

	"Test simple true condition statement case"
	self
		interpret: 'var x = 0; y = 5; if (y > 3) {x = 99;} else {x = 1;};'.
	self assertInterpreterVar: 'x' equals: 99.

	"Test simple false condition statement case"
	self
		interpret: 'var x = 0; var y = 5; if (y < 3) {x = 99;} else {x = 1;};'.
	self assertInterpreterVar: 'x' equals: 1.

	"Test more complex true condition statement"
	self
		interpret: 'var x = 0; var y = 3; if ((y + 3 - 1) > 2) { x = 99;} else {x = 1;};'.
	self assertInterpreterVar: 'x' equals: 99.

	"Test more complex false condition statement"
	self
		interpret: 'var x = 0; var y = 10; if ((y + 3 - 1) < 5) { x = 99;} else {x = 1;};'.
	self assertInterpreterVar: 'x' equals: 1
]

{ #category : #tests }
JbInterpreterTest >> testIfStatements [
	"Test explicit true and false cases"

	self interpret: 'var x = 0; if (true) { x = 99;};'.
	self assertInterpreterVar: 'x' equals: 99.
	self interpret: 'var x = 0; if (false) { x = 99;};'.
	self assertInterpreterVar: 'x' equals: 0.

	"Test simple true condition statement case"
	self interpret: 'var x = 0; y = 5; if (y > 3) {x = 99;};'.
	self assertInterpreterVar: 'x' equals: 99.

	"Test simple false condition statement case
	self interpret: 'var x = 0; var y = 5; if (y < 3) {x = 99;};'.
	self assertInterpreterVar: 'x' equals: 0."

	"Test more complex true condition statement
	self
		interpret: 'var x = 0; var y = 3; if ((y + 3 - 1) > 2) { x = 99; }'.
	self assertInterpreterVar: 'x' equals: 99."

	"Test more complex false condition statement
	self
		interpret: 'var x = 0; var y = 10; if ((y + 3 - 1) < 5) { x = 99; }'.
	self assertInterpreterVar: 'x' equals: 0"
]

{ #category : #tests }
JbInterpreterTest >> testLessThanComparison [
	"Testing < operator"
	
	"False case, values are the same"
	self interpret: 'var x = 2; var y = 2; var z = x<y;'.
	self assertInterpreterVar: 'z' equals: false.
	
	"False case, values are different"
	self interpret: 'var x = 2; var y = 1; var z = x<y;'.
	self assert: (interpreter environment at: 'z') equals: false.
	
	"True case"
	self interpret: 'var x = 2; var y = 5; var z = x<y;'.
	self assert: (interpreter environment at: 'z') equals: true.
	

	

]

{ #category : #tests }
JbInterpreterTest >> testLessThanEqualToComparison [
	"Testing <= operator"
	
	"True Case, values are the same"
	self interpret: 'var x = 2; var y = 2; var z = x<=y;'.
	self assert: (interpreter environment at: 'z') equals: true.
	
	"True case, values are different"
	self interpret: 'var x = 2; var y = 5; var z = x<=y;'.
	self assert: (interpreter environment at: 'z') equals: true.
	
	"False case"
	self interpret: 'var x = 2; var y = 1; var z = x<=y;'.
	self assert: (interpreter environment at: 'z') equals: false.
	

	

]

{ #category : #tests }
JbInterpreterTest >> testNotEqualComparison [
	"Testing != operator"

	self interpret: 'var x = 2; var y = 2; var z = x!=y;'.
	self assert: (interpreter environment at: 'z') equals: false.
	self interpret: 'var x = 7; var y = 8; var z = x!=y;'.
	self assert: (interpreter environment at: 'z') equals: true.
]

{ #category : #tests }
JbInterpreterTest >> testReturnStatements [
	"Simple return"

	self
		interpret:
			'
var x = 1;
return x;'.
	self assertInterpreterVar: 'x' equals: 1.
	
	self
		assert:
			(self
				interpret:
					'
var x = 17;
var y = 7;
return x + y;')
		equals: 24
]
