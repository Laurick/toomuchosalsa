class_name BehaivourOnHover extends Node

var target:Control

func _ready() -> void:
	target = get_parent()
	target.mouse_entered.connect(on_mouse_entered)
	target.mouse_exited.connect(on_mouse_exited)
	target.button_down.connect(on_mouse_pressed)

func on_mouse_entered():
	pass #create_tween().tween_property(target, "scale", Vector2(1.1,1.1), 0.1)

func on_mouse_exited():
	pass #if is_inside_tree():
		#create_tween().tween_property(target, "scale", Vector2.ONE, 0.1)

func on_mouse_pressed():
	pass #target.scale = Vector2(0.9,0.9)
