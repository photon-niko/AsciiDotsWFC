extends Control

onready var text_box = $HBoxContainer/RichTextLabel
onready var ticks_label = $HBoxContainer/VBoxContainer/Ticks
onready var asciidotsery = $AsciiDotsery

onready var init_button = $HBoxContainer/VBoxContainer/InitButton
onready var step_button = $HBoxContainer/VBoxContainer/StepButton

var ticks = 0

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var DOT_COLOR = Color(1, 0, 0)
var wfc

var do_magic = false

var dots = []

export(int,0,90) var wave_function_width = 90
export(int,0,25) var wave_function_height = 25

func _ready():
	seed(69420)
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
	wfc = WFC.new(Vector2(wave_function_width,wave_function_height),Global.module_data)
	var s = "01234"
	s[0]=""
	s=s.insert(0, "asd")
	print(s)

func _process(_delta):
	text_box.bbcode_text = highlight_dots(wfc.as_string())
	ticks_label.text = str(ticks)
	if wfc.is_broken():
		redo_magic()
	
	if not wfc.is_collapsed() and do_magic:
		ticks+=1
		wfc.iterate()
	else:
		do_magic = false
		init_button.disabled=false

func highlight_dots(wf_str:String):
	var wf_lines = Array(wf_str.split("\n"))

	var highlighted_lines = wf_lines.duplicate()
	
	for dot_pos in dots:
		var wf_char = wf_lines[dot_pos.y][dot_pos.x]
		var wf_line = wf_lines[dot_pos.y]
		var highlighted_char = "[color=#"+DOT_COLOR.to_html(false)+"]"+wf_char+"[/color]"
		
		wf_line[dot_pos.x]=0
		wf_line=wf_line.insert(dot_pos.x, highlighted_char)
		
		highlighted_lines[dot_pos.y] = wf_line
		
	var combined_highlighted = ""
	for line in highlighted_lines:
		var combined_line = ""
		
		for character in line:
			combined_line+=character
			
		combined_highlighted+=combined_line+"\n"
		
	return combined_highlighted

func redo_magic():
	dots=[]
	init_button.disabled=true
	ticks = 0
	wfc.initialize()
	do_magic = true

func _on_GenerateButton_pressed():
	redo_magic()

func _on_InitButton_pressed():
	asciidotsery.initialize(wfc.as_string())
	step_button.disabled=false

func _on_StepButton_pressed():
	asciidotsery.step()
	dots=asciidotsery.get_dots()
	print(dots)
