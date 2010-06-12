Class {
	#name : #PPPredicateTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitTests-Tests'
}

{ #category : #utilities }
PPPredicateTest >> assertCharacterSets: aParser [
	"Assert the character set of aParser does not overlap with the character set with the negated parser, and that they both cover the complete character space."

	| positives negatives |
	positives := self parsedCharacterSet: aParser.
	negatives := self parsedCharacterSet: aParser negate.
	self charactersDo: [ :char | 
		| positive negative |
		positive := positives includes: char.
		negative := negatives includes: char.
		self 
			assert: ((positive and: [ negative not ])
				or: [ positive not and: [ negative ] ])
			description: char printString , ' should be in exactly one set' ]
]

{ #category : #private }
PPPredicateTest >> charactersDo: aBlock [
	1 to: 256 do: [ :index | aBlock value: (Character codePoint: index) ]
]

{ #category : #utilities }
PPPredicateTest >> parsedCharacterSet: aParser [
	| result |
	result := WriteStream on: String new.
	self charactersDo: [ :char |
		(aParser matches: (String with: char))
			ifTrue: [ result nextPut: char ] ].
	^ result contents
]

{ #category : #'testing-objects' }
PPPredicateTest >> testAny [
	| parser |
	parser := #any asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: ' ' to: $ .
	self assert: parser parse: '1' to: $1.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: ''
]

{ #category : #'testing-objects' }
PPPredicateTest >> testAnyOf [
	| parser |
	parser := PPPredicateObjectParser anyOf: #($a $z).
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: 'x'
]

{ #category : #'testing-objects' }
PPPredicateTest >> testBetweenAnd [
	| parser |
	parser := PPPredicateObjectParser between: $b and: $d.
	self assertCharacterSets: parser.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'b' to: $b.
	self assert: parser parse: 'c' to: $c.
	self assert: parser parse: 'd' to: $d.
	self assert: parser fail: 'e'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testBlank [
	| parser |
	parser := #blank asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character space) to: Character space.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: (String with: Character cr)
]

{ #category : #'testing-chars' }
PPPredicateTest >> testChar [
	| parser |
	parser := $* asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '*' to: $*.
	self assert: parser parse: '**' to: $* end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testControl [
	| parser |
	parser := #control asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character cr) to: Character cr.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testCr [
	| parser |
	parser := #cr asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character cr) to: Character cr
]

{ #category : #'testing-chars' }
PPPredicateTest >> testDigit [
	| parser |
	parser := #digit asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '9' to: $9.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'
]

{ #category : #'testing-objects' }
PPPredicateTest >> testExpect [
	| parser |
	parser := PPPredicateObjectParser expect: $a.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'.
	self assert: parser fail: ''
]

{ #category : #'testing-chars' }
PPPredicateTest >> testHex [
	| parser |
	parser := #hex asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '5' to: $5.
	self assert: parser parse: '9' to: $9.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'D' to: $D.
	self assert: parser parse: 'F' to: $F.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'e' to: $e.
	self assert: parser parse: 'f' to: $f.
	self assert: parser fail: ''.
	self assert: parser fail: 'g'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testLetter [
	| parser |
	parser := #letter asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: '0'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testLf [
	| parser |
	parser := #lf asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character lf) to: Character lf
]

{ #category : #'testing-chars' }
PPPredicateTest >> testLowercase [
	| parser |
	parser := #lowercase asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: ''.
	self assert: parser fail: 'A'.
	self assert: parser fail: '0'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testNewline [
	| parser |
	parser := #newline asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character cr) to: Character cr.
	self assert: parser parse: (String with: Character lf) to: Character lf.
	self assert: parser fail: ' '
]

{ #category : #testing }
PPPredicateTest >> testOnMessage [
	| block parser |
	block := [ :char | char = $* ].
	parser := PPPredicateObjectParser on: block message: 'starlet'.
	self assert: parser block = block.
	self assert: parser message = 'starlet'.
	
	self assertCharacterSets: parser.
	self assert: parser parse: '*' to: $*.
	self assert: parser parse: '**' to: $* end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testPunctuation [
	| parser |
	parser := #punctuation asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '.' to: $..
	self assert: parser parse: ',' to: $,.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '1'
]

{ #category : #'testing-sequence' }
PPPredicateTest >> testSequenceParser [
	| parser |
	parser := PPPredicateSequenceParser 
		on: [ :value | value first isUppercase ] 
		message: 'uppercase 3 letter words'
		size: 3.
	self assert: parser size = 3.
	self assert: parser parse: 'Abc'.
	self assert: parser parse: 'ABc'.
	self assert: parser parse: 'ABC'.
	self assert: parser fail: 'abc'.
	self assert: parser fail: 'aBC'.
	self assert: parser fail: 'Ab'.
	
	parser := parser negate.
	self assert: parser size = 3.
	self assert: parser fail: 'Abc'.
	self assert: parser fail: 'ABc'.
	self assert: parser fail: 'ABC'.
	self assert: parser parse: 'abc'.
	self assert: parser parse: 'aBC'.
	self assert: parser fail: 'Ab'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testSpace [
	| parser |
	parser := #space asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser parse: ' ' to: Character space.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testTab [
	| parser |
	parser := #tab asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character tab) to: Character tab
]

{ #category : #'testing-chars' }
PPPredicateTest >> testUppercase [
	| parser |
	parser := #uppercase asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '0'
]

{ #category : #'testing-chars' }
PPPredicateTest >> testWord [
	| parser |
	parser := #word asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: '0' to: $0.
	self assert: parser fail: ''.
	self assert: parser fail: '-'
]