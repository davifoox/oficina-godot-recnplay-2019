extends Node

func _ready():
	$Control/ButtonStart.grab_focus()

func _on_ButtonStart_pressed():
	get_tree().change_scene("res://scenes/Level01.tscn")


func _on_ButtonTutorial_pressed():
	get_tree().change_scene("res://scenes/Tutorial.tscn")


func _on_ButtonExit_pressed():
	get_tree().quit()
