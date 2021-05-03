extends CanvasLayer

onready var healthBar = get_node("ProgressBar")
onready var animLayer = get_node("AnimationPlayer")

func updateHealth(health):
	healthBar.value = health


func updateScore(score):
	$score.text = "Score = " + str(score)


func updateLevel(level):
	$level.text = "Level = " + str(level)


func showMsg(title="", msg=""):
	$message.text = title + msg
	$msgTimer.start()


func clearMsg():
	$message.text = ""


func _on_msgTimer_timeout():
	clearMsg()


func startAnim():
	animLayer.play("start")


func endAnim():
	animLayer.play("end")
