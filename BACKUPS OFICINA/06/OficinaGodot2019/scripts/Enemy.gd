extends Area2D

export var flipped = false

func _ready():
	$Sprite.flip_h = flipped

func _on_Enemy_body_entered(body):
	if body.name == "Player":
		body.die()
