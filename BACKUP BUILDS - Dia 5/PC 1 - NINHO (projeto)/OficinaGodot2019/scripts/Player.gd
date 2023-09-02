extends KinematicBody2D

var max_speed = 250      #500rápido #250lento
var acc = 1500           #200000rápido #1500smooth
var velocity = Vector2.ZERO
onready var how_many_friends_left = get_tree().get_nodes_in_group("friend").size()
var child_friend


func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(acc * delta)
		
	else:
		apply_movement(axis * acc * delta)
		
	velocity = move_and_slide(velocity)
	
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	#Set animations
	if axis.x != 0 or axis.y != 0:
		animations("walk")
		if child_friend != null:
			child_friend.animations("walk")
		if axis.x == 1:
			flip_sprite(false)
			if child_friend != null:
				child_friend.flip_sprite(false)
		elif axis.x == -1:
			flip_sprite(true)
			if child_friend != null:
				child_friend.flip_sprite(true)
	else:
		animations("idle")
		if child_friend != null:
			child_friend.animations("idle")
	
		
	return axis.normalized()
	
func apply_friction(ammount):
	if velocity.length() > ammount:
		velocity -= velocity.normalized() * ammount
	else:
		velocity = Vector2.ZERO
		
func apply_movement(acceleration):
	velocity += acceleration
	velocity = velocity.clamped(max_speed)


func die():
	set_physics_process(false)
	$SFX/HurtSound.play()
	yield($SFX/HurtSound, "finished")
	get_tree().reload_current_scene()
	
func pick_friend(friend):
	if friend.get_parent().name == name:
		return
	$SFX/ObjectiveCompletedSound.play()
	how_many_friends_left -= 1
	get_parent().remove_child(friend)
	add_child(friend)
	friend.position = $Position2DFriend.position
	child_friend = friend
	
func animations(anim_name):
	$AnimatedSprite.play(anim_name)

func flip_sprite(boolean):
	if boolean:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false