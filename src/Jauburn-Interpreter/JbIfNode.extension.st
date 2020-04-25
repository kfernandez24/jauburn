Extension { #name : #JbIfNode }

{ #category : #'*Jauburn-Interpreter' }
JbIfNode >> executeIn: environment [
	(condition evaluateIn: environment)
		ifTrue:
			[ trueStatements do: [ :statement | statement executeIn: environment ] ]
]
