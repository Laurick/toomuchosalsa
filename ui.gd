class_name UI extends CanvasLayer

@onready var score_label: Label = $UI/MarginContainer/ScoreLabel
@onready var pause_container: Control = $PauseContainer
@onready var subtitles_label: RichTextLabel = $SubtitlesLabel

func _ready() -> void:
	score_label.text = "0"

func update_score_label(score:int):
	score_label.text = str(score)

func show_pause():
	get_tree().paused = true
	pause_container.show()

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
	subtitles_label.text = "[color=green]%s[/color][color=white]%s[/color]" % [green_text, white_text]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if get_tree().paused:
			hide_pause()
		else:
			show_pause()
