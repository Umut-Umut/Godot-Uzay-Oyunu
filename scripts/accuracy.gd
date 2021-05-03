extends KinematicBody2D

var vel = Vector2(0, 100)


func _process(_delta):
	vel = move_and_slide(vel)


func buff(body):
	body.accuracy -= 5
	if body.accuracy < 0:
		body.accuracy = 0
