extends Node2D

@export var center:Marker2D


var succeded = false
var velocity = 500
var direction:Vector2

var time = 0.0
func _ready() -> void:
	direction = global_position.direction_to(center.global_position)

func _process(delta: float) -> void:
	time += delta
	global_position = global_position + (velocity*delta*direction)
	if global_position.distance_to(center.global_position) < 8:
		#print("me voy: "+str(time))
		queue_free()
