extends Control

var tree

func _ready():
	tree = get_tree()

func _on_Button1_pressed():
	tree.change_scene("res://scenes/space.tscn")

func _on_Button3_pressed():
	tree.quit()
