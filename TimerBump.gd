class_name TimerBump extends Node

enum ANIMATION_STATE { NONE, UP, DOWN }

@export var target:Node2D

var aniamtion_state: ANIMATION_STATE = ANIMATION_STATE.NONE
var scale_mult:float = 1.0

@export var frequency: float = 0.16
@export var amplitude: float = 1
@export var min: float = 0.5


var time:float

func _ready() -> void:
	target = get_parent()


func _process(delta: float) -> void:
	time = get_time()
	#print(str(Time.get_ticks_msec()/100)+" <-> "+str(time))
	#if aniamtion_state == ANIMATION_STATE.NONE and time >= time_between:
		#time = 0
		#aniamtion_state = ANIMATION_STATE.UP
	#
	#if aniamtion_state == ANIMATION_STATE.UP:
		#lerp(scale_mult,target_scale_mult,delta)
		#if scale_mult == target_scale_mult:
			#aniamtion_state = ANIMATION_STATE.DOWN
	#
	#if aniamtion_state == ANIMATION_STATE.DOWN:
		#lerp(scale_mult,1,delta*2)
		#if scale_mult == target_scale_mult:
			#aniamtion_state = ANIMATION_STATE.NONE
	
	target.scale = Vector2.ONE * time


func get_time() -> float:
	return abs(amplitude * sin(frequency * Time.get_ticks_msec()/100))+min
