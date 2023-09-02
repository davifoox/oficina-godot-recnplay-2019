extends Area2D

func _on_Friend_body_entered(body):
	if body.name == "Player":
		body.pick_friend(self)
		
func animations(anim_name):
	$AnimatedSprite.play(anim_name)

func flip_sprite(boolean):
	if boolean:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false