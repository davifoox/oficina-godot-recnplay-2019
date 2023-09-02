extends Area2D

export(String, FILE, "*.tscn") var next_level

func _on_House_body_entered(body):
	if body.name == "Player":
		if body.how_many_friends_left <= 0:
			$SFX/EnterSound.play()
			yield($SFX/EnterSound, "finished")
			get_tree().change_scene(next_level)
