class_name UI extends CanvasLayer

@onready var score_label: Label = $UI/MarginContainer/ScoreLabel
@onready var pause_container: Control = $PauseContainer
@onready var subtitles_label: Label = $SubtitlesLabel

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

func add_subtitle(subtitle:String):
	subtitles_label.text = subtitle

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if get_tree().paused:
			hide_pause()
		else:
			show_pause()
