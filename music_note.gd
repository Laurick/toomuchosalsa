extends Node2D

signal note_failed()

@onready var note_image: Sprite2D = $NoteImage

@export var center:Marker2D

var _arrow:Constants.INPUTS
var _color:Color

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
	note_image.modulate = _color

func setup(arrow:Constants.INPUTS, color:Color):
	_arrow = arrow
	_color = color

func _process(delta: float) -> void:
	global_position = global_position + (global_position.direction_to(center.global_position)*2)
	if global_position.distance_to(center.global_position) == 0:
		note_failed.emit()
		queue_free()
