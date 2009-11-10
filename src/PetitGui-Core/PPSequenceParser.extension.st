Extension { #name : #PPSequenceParser }

{ #category : #'*petitgui-accessing' }
PPSequenceParser >> exampleOn: aStream [
	parsers do: [ :each | each exampleOn: aStream ]
]

{ #category : #'*petitgui-accessing' }
PPSequenceParser >> morphicShapeSeen: aSet depth: anInteger [
	| morph |
	^ (anInteger < 1 or: [ aSet includes: self ])
		ifTrue: [ super morphicShapeSeen: aSet depth: anInteger ]
		ifFalse: [
			aSet add: self.
			morph := RectangleMorph new.
			morph 
				borderWidth: 0;
				color: Color transparent;
				layoutPolicy: TableLayout new;
				cellPositioning: #leftCenter;
				listDirection: #leftToRight;
				hResizing: #shrinkWrap;
				vResizing: #spaceFill.
			morph addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) 	makeForwardArrow.
			self children
				do: [ :each | morph addMorphBack: (each morphicShapeSeen: aSet depth: anInteger - 1) ]
				separatedBy: [ morph addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) makeForwardArrow ].
			morph addMorphBack: ((LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) 
				"vResizing: #spaceFill;"
				makeForwardArrow;
				yourself).
			morph ]
]