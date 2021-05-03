extends Control

var tree
onready var main = get_tree().get_current_scene()

func _ready():
	tree = get_tree()


func _on_Button_pressed():
	tree.change_scene("res://scenes/space.tscn")


func _on_Button2_pressed():
	tree.change_scene("res://scenes/mainMenu.tscn")
