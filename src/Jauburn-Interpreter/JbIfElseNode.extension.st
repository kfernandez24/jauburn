Extension { #name : #JbIfElseNode }

{ #category : #'*Jauburn-Interpreter' }
JbIfElseNode >> executeIn: environment [
	(condition evaluateIn: environment)
		ifTrue:
			[ trueStatements do: [ :statement | statement executeIn: environment ] ]
		ifFalse: 
			[ falseStatements do: [ :statement | statement executeIn: environment ] ].
]
