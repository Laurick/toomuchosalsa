class_name UI extends CanvasLayer

const NORMAL_SUBTITLES_FORMAT = "[color=white]%s[/color][color=#FFB6ED]%s[/color]"
const AZUCAR_SUBTITLES_FORMAT = "[color=white]%s[/color][color=#00B3EE]%s[/color]"

@onready var score_label: Label = $UI/MarginContainer/ScoreLabel
@onready var pause_container: Control = $PauseContainer
@onready var subtitles_label: RichTextLabel = $SubtitlesLabel
@onready var ui_button: TextureButton = $UI/MarginContainer/UiButton
@onready var stage: Label = $VBoxContainer/Stage
@onready var h_box_container: HBoxContainer = $VBoxContainer/HBoxContainer
@onready var v_box_container: VBoxContainer = $VBoxContainer

var pause_available = false

func _ready() -> void:
	score_label.text = "0"

func update_score_label(score:int):
	score_label.text = str(score)

func show_pause():
	if !pause_container.visible:
		get_tree().paused = true
		pause_container.show()
	else:
		get_tree().paused = false
		pause_container.hide()

func show_pause_button():
	pause_available = true
	ui_button.show()

func hide_pause_button():
	pause_available = false
	ui_button.hide()

func hide_pause():
	pause_container.hide()
	get_tree().paused = false

func add_subtitle(subtitle:SubtitleEntry = null, time:float = 0):
	if !subtitle:
		subtitles_label.text = ""
		return
	var t = time-subtitle.start_time
	var p = t/subtitle.total_time
	var index_readed:int = subtitle.text.length()*p
	var green_text:String = subtitle.text.substr(0, index_readed)
	var white_text:String = subtitle.text.substr(index_readed, subtitle.text.length())
	subtitles_label.text = NORMAL_SUBTITLES_FORMAT % [green_text, white_text]

func _input(event: InputEvent) -> void:
	if pause_available and event.is_action_pressed("Pause"):
		if get_tree().paused:
			hide_pause()
		else:
			show_pause()


func on_stage_changed(new_stage:String, song_idx:int):
	v_box_container.show()
	stage.text = new_stage
	var new_index = song_idx-1
	var color = Color.from_string("#00b3ee", Color.BLUE_VIOLET)
	for i in range(0, new_index):
		h_box_container.get_child(i).self_modulate = color
	if new_index < h_box_container.get_child_count():
		h_box_container.get_child(new_index).self_modulate = Color.from_string("#ffb6ec", Color.BLUE_VIOLET)

func hide_panel():
	v_box_container.hide()
