extends Node2D

@onready var note_image: Sprite2D = $NoteImage

@export var center:Marker2D
@export var main:Node2D
var _arrow:Constants.INPUTS

func _ready() -> void:
	match (_arrow):
		Constants.INPUTS.LEFT:
			note_image.texture = load("res://images/arrow_left.png")
		Constants.INPUTS.RIGHT:
			note_image.texture = load("res://images/arrow_right.png")
		Constants.INPUTS.UP:
			note_image.texture = load("res://images/arrow_up.png")
		Constants.INPUTS.DOWN:
			note_image.texture = load("res://images/arrow_down.png")
		Constants.INPUTS.SPACE:
			note_image.texture = load("res://images/button.png")

func setup(arrow):
	_arrow = arrow

func _process(delta: float) -> void:
	global_position = global_position + (global_position.direction_to(center.global_position)*2)
	if global_position.distance_to(center.global_position) == 0:
		main.fail()
		queue_free()
