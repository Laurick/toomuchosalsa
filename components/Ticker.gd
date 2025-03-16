class_name Ticker extends Node

signal on_tick_ticked(tick_number)

const time_tick = 0.6
var tick_number = 0
var time_ellapsed = 0

func _process(_delta):
	time_ellapsed += _delta
	if time_ellapsed >= time_tick:
		on_tick_ticked.emit(tick_number)
		tick_number += 1
