class_name TimerBump extends Node

enum ANIMATION_STATE { NONE, UP, DOWN }

@export var target:Node2D

var aniamtion_state: ANIMATION_STATE = ANIMATION_STATE.NONE
var scale_mult:float = 1.0

@export var frequency: float = 10 # 100 bpm
@export var amplitude: float = 1.2


var time:float

func _ready() -> void:
	target = get_parent()


func _process(delta: float) -> void:
	time = get_time()
	target.scale = Vector2.ONE * time


func get_time() -> float:
	var v = max(1, (amplitude * sin(frequency * Time.get_ticks_msec()/1000)))
	return v
