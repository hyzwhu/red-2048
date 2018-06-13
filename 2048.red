Red []
grid-world: layout/tight [
    style b: base 30x30 
    at 0x0 b 	at 40x0 b 	at 80x0 b 	at 120x0 b 	
	at 0x40 b 	at 40x40 b 	at 80x40 b 	at 120x40 b 
    at 0x80 b	at 40x80 b 	at 80x80 b 	at 120x80 b
    at 0x120 b 	at 40x120 b at 80x120 b at 120x120 b
]

grid-block: [[2 2 4 4] [2 0 2 0] [0 4 0 4] [8 4 8 4]]

show-block: function [/local i j l][     ;--to bind the block value with the window's panes
	repeat i 4 [
		repeat j 4 [
			l: i - 1 * 4 + j
			either grid-block/:i/:j <> 0 [
				grid-world/pane/:l/text: form grid-block/:i/:j
				grid-world/pane/:l/visible?: true
			][
				grid-world/pane/:l/visible?: false 
			]
		]
	]
]

add-grid: function [/local i j f][
	f: true
	repeat i 4 [
		repeat j 4 [
			if 0 = grid-block/:i/:j [
				grid-block/:i/:j: either 1 <> random 4 [2][4]
				f: false
			]
			unless f [break]
		]
		unless f [break]
	]
]	

; init-grid: function [/local i j][
; 	i: random 16 
; 	j: random 16 
; 	while [j = i][
; 		j: random 16 
; 	]
; 	grid-world/pane/:i/text: "2" 
; 	grid-world/pane/:j/text: "2"
; ]
grid-world/actors: make object! [
	on-key-down: func [face [object!] event [event!]][
		switch event/key [
			up		
			down 
			left 	[move-left show-block]
			right	[move-right show-block]
		]
	]
]

move-left-one: func [rn [integer!] return: [logic!] /local col i j l y modified][
	col: -1
	i: 1
	j: 1
	modified: false  
	repeat i 4[	;--merge numbers
		if 0 = grid-block/:rn/:i [
			continue
		]
		if -1 = col [
			col: i
			continue
		]
		if grid-block/:rn/:i <> grid-block/:rn/:col [
			col: i 
			continue
		]
		if grid-block/:rn/:i = grid-block/:rn/:col [
			grid-block/:rn/:col: 2 * grid-block/:rn/:col
			grid-block/:rn/:i: 0
			col: -1 
			modified: true
		]
	]
	repeat j 16[
		y: j % 4
		l: y + 1
		if 4 = y [continue] 
		if all [grid-block/:rn/:y = 0 grid-block/:rn/:l <> 0][
			grid-block/:rn/:y: grid-block/:rn/:l
			grid-block/:rn/:l: 0
			modified: true
		]	
	]
	modified
]

move-left: function [][
	repeat i 4 [
		move-left-one i
	]
]

; move-right-one: func [rn [integer!] return: [logic!] /local i j y l modified col][
; 	col: -1 
; 	modified: false
; 	i: 4 
; 	j: 16 
; 	while [i > 0][
; 		if 0 = grid-block/:rn/:i [i: i - 1 continue]
; 		if -1 = col [
; 			col: i 
; 			i: i - 1 
; 			continue
; 		]
; 		if grid-block/:rn/:i <> grid-block/:rn/:col [
; 			col: i 
; 			i: i - 1 
; 			continue
; 		]
; 		if grid-block/:rn/:i = grid-block/:rn/:col [
; 			grid-block/:rn/:col: 2 * grid-block/:rn/:col
; 			grid-block/:rn/:i: 0
; 			col: -1 
; 			modified: true
; 		]
; 		i: i - 1
; 	]
; 	while [j > 0][
; 		y: j % 4 
; 		l: y - 1
; 		if 4 = y [j: j - 1 continue]
; 		if all [grid-block/:rn/:y = 0 grid-block/:rn/:l <> 0][
; 			grid-block/:rn/:y: grid-block/:rn/:l
; 			grid-block/:rn/:l: 0
; 			modified: true
; 		]
; 		j: j - 1
; 	]
; 	modified
; ]

; move-right: function [][
; 	repeat i 4 [
; 		move-right-one i
; 	]
; ]


show-block
view grid-world
?? grid-block







