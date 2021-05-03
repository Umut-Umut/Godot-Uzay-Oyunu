extends KinematicBody2D

onready var main = get_tree().get_current_scene()
onready var animLayer = get_node("AnimationPlayer")

var random = RandomNumberGenerator.new()

var vel = Vector2()
var health = 100
var speed = 200
var accuracy = 60

func _ready():
	pass

func _process(_delta):
	controls()
	
	vel = vel.normalized()*speed
	vel = move_and_slide(vel)


func controls():
	if Input.is_action_pressed("ui_right"):
		vel.x = 1
	elif Input.is_action_pressed("ui_left"):
		vel.x = -1
	elif Input.is_action_pressed("d"):
		vel.x = 1
	elif Input.is_action_pressed("a"):
		vel.x = -1
	else: vel.x = 0
	
	# MENU CONTROLS
	if Input.is_key_pressed(16777217):
		var _s = get_tree().change_scene("res://scenes/mainMenu.tscn")

# Animations
func animInjure():
	if not animLayer.is_playing():
		animLayer.play("hurt")
func animHeal():
	if not animLayer.is_playing():
		animLayer.play("heal")
func animDead():
	animLayer.stop()
	animLayer.play("dead")


func injure(damage, coinGloPos=Vector2(0, 0)):
	health -= damage
	# Is Dead
	if health < 0:
		health = 0
	if health == 0:
		animDead()
	
	animInjure()
	if coinGloPos != Vector2(0, 0):
		main.placeRico(coinGloPos)
	main.hud.updateHealth(health)


func heal():
	health += 10
	if health > 100:
		health = 100
	
	animHeal()
	
	main.hud.updateHealth(health)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "dead":
		var _s = get_tree().change_scene("res://scenes/dead.tscn")
