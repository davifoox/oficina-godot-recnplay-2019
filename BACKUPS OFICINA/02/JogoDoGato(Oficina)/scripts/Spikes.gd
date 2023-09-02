extends Area2D

onready var audio = $AudioStreamPlayer

func _on_Spikes_body_entered(body):
	if body.is_in_group("player"):
		body.set_physics_process(false)
		audio.play()
		yield(audio, "finished")
		get_tree().reload_current_scene()
