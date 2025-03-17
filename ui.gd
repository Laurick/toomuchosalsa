class_name UI extends CanvasLayer

const NORMAL_SUBTITLES_FORMAT = "[color=white]%s[/color][color=#FFB6ED]%s[/color]"
const AZUCAR_SUBTITLES_FORMAT = "[color=white]%s[/color][color=#00B3EE]%s[/color]"

@onready var score_label: Label = $UI/MarginContainer/ScoreLabel
@onready var pause_container: Control = $PauseContainer
@onready var subtitles_label: RichTextLabel = $SubtitlesLabel
@onready var ui_button: TextureButton = $UI/MarginContainer/UiButton

func _ready() -> void:
	score_label.text = "0"

func update_score_label(score:int):
	score_label.text = str(score)

func show_pause():
	get_tree().paused = true
	pause_container.show()

func show_pause_button():
	ui_button.show()

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
	if event.is_action_pressed("Pause"):
		if get_tree().paused:
			hide_pause()
		else:
			show_pause()
