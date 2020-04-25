"
I am the value that results from evaluating a function.  My i-vars

	parameters -- collection holding names of my parameters 
	environment -- a JbEnvironment instance holding the environment in effect when I was created (closures!)
	body -- an AST node for the body of this function
"
Class {
	#name : #JbFunction,
	#superclass : #Object,
	#instVars : [
		'body',
		'parameters',
		'environment'
	],
	#category : #'Jauburn-Interpreter-Core'
}

{ #category : #accessing }
JbFunction >> body [
	^ body
]

{ #category : #accessing }
JbFunction >> body: anObject [
	body := anObject
]

{ #category : #api }
JbFunction >> call: arguments in: callEnvironment [
	"You need to implement this method!  arguments will contain the arguments to pass to this function and callEnvironment will contain the environment in place when this function was called."

	| j argVals |
	j := JbEnvironment new.
	j outerEnvironment: environment.
	argVals := arguments
		collect: [ :arg | arg evaluateIn: callEnvironment ].
	1 to: argVals size do: [ :i | j at: (parameters at: i) put: (argVals at: i) ].
	body do: [ :stmt | stmt executeIn: j ]
]

{ #category : #accessing }
JbFunction >> environment [
	^ environment
]

{ #category : #accessing }
JbFunction >> environment: anObject [
	environment := anObject
]

{ #category : #accessing }
JbFunction >> parameters [
	^ parameters
]

{ #category : #accessing }
JbFunction >> parameters: anObject [
	parameters := anObject
]
