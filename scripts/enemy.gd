extends KinematicBody2D

onready var enemyLira = preload("res://scenes/redLira.tscn")
var lira

onready var main = get_tree().get_current_scene()


var random = RandomNumberGenerator.new()
var isDead = false
var hLevel

var vel = Vector2(0, 1)
var speed # in space node/enemy spawn

func _ready():
	random.randomize()
	$AnimationPlayer.play("turn")


func _process(_delta):
	vel = vel.normalized()*speed
	vel = move_and_slide(vel)


var randomNum
var change = 0
func _on_Area2D_body_entered(body): # if body == bullet
	if body.collision_layer == 4 and not isDead: # layer 4 = lira
		randomNum = random.randi_range(0, 100)
		if randomNum > 100-change: # is hit?
			
			dead()
			body.free() # It will delete money

			
		else: # Iskaladi veya Mermi sekti
			randomNum = random.randi_range(0, 100)
			if randomNum > 75:
				body.queue_free()
				speed -= 10
				
				if speed <= 20:
					dead()
				
				main.placeRico(body.position)


func fire():
	lira = enemyLira.instance()
	
	lira.vel.x = random.randi_range(-10, 10)
	
	add_child(lira)
	
	lira.global_position = position + Vector2(0, 10)

var buffChange = 15
var randomChange
func dead(): # It kill the enemy
	isDead = true
	main.killEnemy += 1
	
	main.score += 1
	main.get_node("hud").updateScore(main.score)
	
	main.placeBoom(position)
	
	randomChange = random.randi_range(0, 100)
	if randomChange >= 100-buffChange:
		main.buffSpawn(global_position)
	
	queue_free()



func _on_Timer_timeout():
	$Timer.wait_time = random.randi_range(1, 4)
	main.enemyAttack(position)
