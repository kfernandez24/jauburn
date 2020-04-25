Extension { #name : #JbFunctionCallNode }

{ #category : #'*Jauburn-Interpreter' }
JbFunctionCallNode >> executeIn: environment [ 
| j |
j := environment at: identifier .
j call: arguments in: environment. 
]
