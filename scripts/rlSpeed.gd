extends KinematicBody2D

var vel = Vector2(0, 100)

func _process(_delta):
	vel = move_and_slide(vel)


func buff(body):
	body.speed += 10
