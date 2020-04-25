Extension { #name : #JbReturnStatementNode }

{ #category : #'*Jauburn-Interpreter' }
JbReturnStatementNode >> executeIn: environment [
	^ (expression evaluateIn: environment)
]
