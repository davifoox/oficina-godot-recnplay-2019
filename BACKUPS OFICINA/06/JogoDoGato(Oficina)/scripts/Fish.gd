extends Area2D

export(String, FILE, "*.tscn") var next_scene

onready var audio = $AudioStreamPlayer
onready var sprite = $Sprite

func _on_Fish_body_entered(body):
	if body.is_in_group("player"):
		sprite.hide()
		Engine.time_scale = 0.25
		audio.play()
		yield(audio, "finished")
		Engine.time_scale = 1
		get_tree().change_scene(next_scene)