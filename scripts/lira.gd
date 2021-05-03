extends KinematicBody2D

var vel = Vector2(0, -800)
var speed = 600


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if speed < 100:
		queue_free()
	
	vel = vel.normalized()*speed
	vel = move_and_slide(vel)
