extends Node

func _ready():
	$Control/ButtonBack.grab_focus()

func _on_ButtonBack_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
