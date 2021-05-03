extends Node2D

onready var animScene = preload("res://scenes/effects.tscn")
onready var liraScene = preload("res://scenes/lira.tscn")
onready var redLiraScene = preload("res://scenes/redLira.tscn")
onready var player = get_node("player")
onready var enemyScene = preload("res://scenes/enemy.tscn")
onready var hud = preload("res://scenes/hud.tscn").instance()

# BUFFS

var lira
var rlira
var enemy
var rico
var boom

var pos
var auto = false

var num
var enemyNum = 10
var count = 0
var change
var random = RandomNumberGenerator.new()

var score = 0
var level = 1
var killEnemy = 0

var spawners = []
var random_spawner
var can_spawn = true

func _ready():
	for i in get_tree().get_nodes_in_group("spawner"):
		spawners.append(i)
	
	add_child(hud)
	hud.startAnim()
	
	hud.updateHealth(player.health)
	
	random.randomize()
	
	$regFireTimer.start()
	$music.play()


func _process(_delta):
	attack()


# PLAYER ATTACK
var regularFire = false
var fire = false
var accuracy
var fire_timer = 0.5
func attack():
	if Input.is_action_just_pressed("ui_select"):
		lira = liraScene.instance()
		
		lira.position.x = player.position.x
		lira.position.y = player.position.y -20
		accuracy = player.accuracy
		lira.vel.x = random.randi_range(-accuracy, accuracy)
		
		add_child(lira)
		
		fire = false
		regularFire = false
		$regFireTimer.start(fire_timer)
	
	
	if Input.is_action_pressed("ui_select") and regularFire:
		lira = liraScene.instance()
		
		lira.position.x = player.position.x
		lira.position.y = player.position.y -20
		accuracy = player.accuracy
		lira.vel.x = random.randi_range(-accuracy, accuracy)
		
		add_child(lira)
		
		regularFire = false
		$regFireTimer.start($regFireTimer.wait_time)


func _on_regFireTimer_timeout(): # wait_time = 0.01 saniye
	regularFire = true


func _on_singFireTimer_timeout():
	fire = true


func enemyAttack(posParam):
	rlira = redLiraScene.instance()
	rlira.position = posParam + Vector2(0, 20)
	
	add_child(rlira)

#========================== Animation Effects ==========================#
func placeRico(posParam):
	rico = animScene.instance()
	rico.global_position = posParam
	
	add_child(rico)
	
	rico.animRico()


func placeBoom(posParam):
	boom = animScene.instance()
	boom.position = posParam
	
	add_child(boom)
	
	boom.animBoom()

#========================== Enemy Spawner ============================#
func select_spawner():
	random_spawner = spawners[random.randi_range(0, spawners.size()-1)]
	if random_spawner.is_spawn:
		random_spawner.is_spawn = false
		random_spawner.timer.start(5)
	else: random_spawner = null


func enemySpawn():
	select_spawner()
	
	if random_spawner == null:
		pass
	else:
		enemy = enemyScene.instance()
		enemy.speed = random.randi_range(30, 70)
		
		count += 1
		enemy.position = random_spawner.global_position
		
		enemy.get_node("Timer").wait_time = random.randi_range(1, 5)
		
		add_child(enemy)


func _on_Timer_timeout():
	# Enemy Spawn
	if count < enemyNum and can_spawn: # enemyNum first value is 10
		enemySpawn()
	
#========================== New Level ============================#
	elif killEnemy == enemyNum:
		$Timer.wait_time -= 0.1
		
		level += 1
		hud.updateLevel(level)
		hud.showMsg("Level ", str(level))
		
		count = 0
		killEnemy = 0
		enemyNum += 10

#======================= Buffs =======================#
var buffScenes = [ # List of Buffs
	preload("res://scenes/health.tscn"),
	preload("res://scenes/rlSpeed.tscn"),
	preload("res://scenes/accuracy.tscn")
	]
var buffScene
var buff
var buffsSize = buffScenes.size() - 1
func buffSpawn(globalPosParam):
	buffScene = buffScenes[ random.randi_range(0, buffsSize) ] # Random index
	buff = buffScene.instance()

	buff.global_position = globalPosParam
		
	call_deferred("add_child", buff) # It fixed the error of can't change this state.


# Enemy Bullet and Enemy Clear
func _on_clearBulletAndEnemy_body_entered(body):
	if body.collision_layer == 64:
		player.injure(20)
		killEnemy += 1
		body.free()
		
	elif body.collision_layer == 8:
		body.free()

# Player Bullet Clear
func _on_clearBullet_body_entered(body):
	body.free()

#======================== Player Collision Check ===========================#
func _on_Area2D_body_entered(body):
	# I got shot!
	if body.collision_layer == 8: # Enemy lira
		player.injure(10, body.global_position)
		body.free()
	
	# The enemy collided you
	elif body.collision_layer == 32:
		player.getDamage(10)
		body.dead()
	
	# Player collided the health pack
	elif body.collision_layer == 256:
		body.buff(player)
		body.queue_free()

#======================= Changes =========================#
func _on_change15_body_entered(body):
	body.change = 15


func _on_change50_body_entered(body):
	body.change = 50


func _on_change75_body_entered(body):
	body.change = 75


func _on_change90_body_entered(body):
	body.change = 90


# FINISH MUSIC
func _on_music_finished():
	$music.play()
