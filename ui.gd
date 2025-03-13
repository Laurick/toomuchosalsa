class_name UI extends CanvasLayer

@onready var score_label: Label = $UI/ScoreLabel

func _ready() -> void:
	score_label.text = "0"

func update_score_label(score:int):
	score_label.text = str(score)
