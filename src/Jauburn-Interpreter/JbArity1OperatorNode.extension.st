Extension { #name : #JbArity1OperatorNode }

{ #category : #'*Jauburn-Interpreter' }
JbArity1OperatorNode >> evaluateIn: environment [

	self operator = $-
		ifTrue: [ ^ operand value negated].
]
