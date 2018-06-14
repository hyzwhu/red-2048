Red[]
alert: layout [
	text center 200x20 "Game over , do you want to try again?" return
	pad 70x0 button "yes"  	[
		init-block
		show-block unview] return
	pad 70x0 button "no"	[unview grid-world unview]	
]
alert/pane/1/text: "Congratulations! You win!"
view alert