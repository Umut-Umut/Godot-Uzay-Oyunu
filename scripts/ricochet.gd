extends Node2D

func animRico():
	$ricoAnim.play("rico")
	$ricoSound.play(0.3)


func animBoom():
	$boomAnim.play("boom")
	$boomSound.play(1)


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free() # Animasyondan sonra kendisini silmesi için.


func _on_boomAnim_animation_finished(_anim_name):
	queue_free()
