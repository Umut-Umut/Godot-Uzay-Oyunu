extends KinematicBody2D


var vel = Vector2(0, 200)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(_delta):
	vel = move_and_slide(vel)
