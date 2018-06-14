Red []
grid-world: layout/tight [
    style b: base 30x30 
    at 0x0 b 	at 40x0 b 	at 80x0 b 	at 120x0 b 	
	at 0x40 b 	at 40x40 b 	at 80x40 b 	at 120x40 b 
    at 0x80 b	at 40x80 b 	at 80x80 b 	at 120x80 b
    at 0x120 b 	at 40x120 b at 80x120 b at 120x120 b
]

original-block: [[0 0 0 0] [0 0 2 0] [2 0 0 0] [0 0 0 0]]
init-block: func [][  ;--the init-block can add random position, if you want to do it
	grid-block: copy/deep original-block
	fake-block: copy/deep original-block
]
show-block: function [/local i j l][     ;--to bind the block value with the window's panes
	repeat i 4 [
		repeat j 4 [
			l: i - 1 * 4 + j
			either grid-block/:i/:j <> 0 [
				grid-world/pane/:l/text: form grid-block/:i/:j
				grid-world/pane/:l/visible?: true
				switch grid-world/pane/:l/text [
					"2"		[grid-world/pane/:l/color: 0.255.204]
					"4"		[grid-world/pane/:l/color: 0.255.255]
					"8"		[grid-world/pane/:l/color: 51.204.255]
					"16"	[grid-world/pane/:l/color: 102.204.255]
					"32"	[grid-world/pane/:l/color: 204.204.255]
					"64"	[grid-world/pane/:l/color: 255.204.255]
					"128"	[grid-world/pane/:l/color: 255.153.204]
					"256"	[grid-world/pane/:l/color: 255.153.153]
					"512" 	[grid-world/pane/:l/color: 255.153.102]
					"1024" 	[grid-world/pane/:l/color: 255.153.51]
					"2048"	[grid-world/pane/:l/color: red]
				]
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

grid-world/actors: make object! [
	on-key-down: func [face [object!] event [event!]][
		switch event/key [
			up		[move-up 	show-block win? can-move]
			down 	[move-down 	show-block win? can-move]
			left 	[move-left 	show-block win? can-move]
			right	[move-right show-block win? can-move]
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

rotation: func [angle [integer!] /local offsetX offsetY sin cos rx ry][
	offsetX: offsetY: 5
	if 90 = angle [offsetY: 0]
	if 270 = angle [offsetX: 0]
	sin: to-integer sine angle
	cos: to-integer cosine angle 
	fake-block: copy/deep grid-block
	repeat x 4 [
		repeat y 4 [
			rx: x * cos - (y * sin) + offsetX
			ry: y * cos + (x * sin) + offsetY
			grid-block/:rx/:ry: fake-block/:x/:y
		]
	]
]

move-left: function [/lacal modified][
	modified: false
	repeat i 4 [
		modified: any [move-left-one i modified]
	]
	if modified [add-grid]
]

move-down: function [][
	rotation 270
	move-left 
	rotation 90 
]

move-up: function [][
	rotation 90
	move-left
	rotation 270
]

move-right: function [][
	rotation 180
	move-left
	rotation 180
]

can-move: func [return: [logic!] /local checkfull f u d l r][
	canmove: false
	f: true
	repeat i 3 [
		repeat j 3 [
			d: i + 1 
			r: j + 1
			if any [
					all [grid-block/:i/:j = grid-block/:i/:r j < 4] 
					all [grid-block/:i/:j = grid-block/:d/:j i < 4]
				][
					canmove: true 
					f: false
			] 
			unless f [break]
		]
		unless f [break]
	]
	if any [grid-block/4/4 = grid-block/3/4 grid-block/4/4 = grid-block/4/3][
		canmove: true 
	]
	unless canmove [
		alert/pane/1/text: "Game over , do you want to try again?"
		view alert
	]
]

win?: func [][
	repeat i 4 [
		repeat j 4 [
			if grid-block/:i/:j = 2048 [
				alert/pane/1/text: "Congratulations! You win! Do you want to play again"
				view alert
			]
		]
	]
]


alert: layout [
	text center 300x20 "Game over , do you want to try again?" return
	pad 100x0 button "yes"  	[
		init-block
		show-block unview] return
	pad 100x0 button "no"	[unview grid-world unview]	
]

init-block
show-block
view grid-world







