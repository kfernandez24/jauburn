Extension { #name : #JbFunctionNode }

{ #category : #'*Jauburn-Interpreter' }
JbFunctionNode >> evaluateIn: environment [
	| f |
	f := JbFunction new.
	f body: body.
	f parameters: (parameters collect: [ :p | p identifier]).
	f environment: environment.
	^ f
]
