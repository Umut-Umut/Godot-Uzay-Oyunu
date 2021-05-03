extends StaticBody2D

var is_spawn = false
onready var timer = get_node("Timer")

func _on_Timer_timeout():
	is_spawn = true
