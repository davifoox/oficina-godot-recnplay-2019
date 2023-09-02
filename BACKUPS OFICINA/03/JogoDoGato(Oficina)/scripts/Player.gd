extends KinematicBody2D

onready var jump_sound = preload("res://assets/sfx/jump.wav")
onready var hit_floor_sound = preload("res://assets/sfx/hit_floor.wav")
onready var step_sound = preload("res://assets/sfx/step.wav")

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var animation_player_effects = $AnimationPlayerEffects
onready var audio = $AudioStreamPlayer

var speed = 100
var acc = 30
var gravity = 1000
var velocity = Vector2()
var jump_force = 250
var floor_normal = Vector2(0, -1)
var current_anim = "idle"
var current_dir = "right"

var jump_press_delay = 0.1 #Default = 0.1
var jump_press_delay_time_left = 0

var was_on_floor = false
var was_on_floor_delay = 0.1 #Default = 0.1 (Coyote Time)
var was_on_floor_delay_time_left = 0

var step_sound_time = 0.2
var step_sound_time_left = 0

func _ready():
	audio.play()

func _physics_process(delta):
	
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + acc, speed)
		flip_player("right")
		if is_on_floor():
			animation("run")
			play_step_sound(delta)
	elif Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - acc, -speed)
		flip_player("left")
		if is_on_floor():
			animation("run")
			play_step_sound(delta)
	else:
		velocity.x = 0
		if is_on_floor():
			animation("idle")
		
	jump(delta)
		
	velocity = move_and_slide(velocity, floor_normal)

	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
		
func flip_player(direction):
	
	if direction == current_dir:
		return
	
	if direction == "right":
		sprite.flip_h = false
		collision_shape.position.x = 2
	elif direction == "left":
		sprite.flip_h = true
		collision_shape.position.x = -2
		
	current_dir = direction
		
func animation(anim_name):
	
	if current_anim == anim_name:
		return
	
	match anim_name:
		"idle":
			animation_player.play("idle")
		"run":
			animation_player.play("run")
		"jump":
			animation_player.play("jump")
		"fall":
			animation_player.play("fall")
			
	current_anim = anim_name
	
func jump(delta):
	
	jump_press_delay_time_left -= delta
	was_on_floor_delay_time_left -= delta
	
	if !is_on_floor():
		if was_on_floor:
			was_on_floor_delay_time_left = was_on_floor_delay
			was_on_floor = false
		if velocity.y > 16:
			animation("fall")
		if Input.is_action_just_pressed("jump"):
			jump_press_delay_time_left = jump_press_delay
			if was_on_floor_delay_time_left > 0:
				was_on_floor_delay_time_left = 0
				
				animation("jump")
				play_sprite_effect("jump")
				play_sound("jump")
				
				velocity.y = -jump_force
			
	if is_on_floor():
		if !was_on_floor:
			#EFEITO DE ANIMAÇÃO AMASSANDO
			play_sound("hit_floor")
			play_sprite_effect("hit_floor")
		was_on_floor = true
		if Input.is_action_just_pressed("jump") or jump_press_delay_time_left > 0:
			
			animation("jump")
			play_sprite_effect("jump")
			play_sound("jump")
			
			velocity.y = -jump_force
			
	elif Input.is_action_just_released("jump"):
		velocity.y *= 0.5
		animation("fall")
		
func play_sound(sound_name):
	match sound_name:
		"jump":
			sound_name = jump_sound
		"hit_floor":
			sound_name = hit_floor_sound
		"step":
			sound_name = step_sound
			
	if !audio.playing:
		audio.stream = sound_name
		audio.pitch_scale = rand_range(0.9, 1.1)
		audio.play()
	
func play_step_sound(delta):
	step_sound_time_left -= delta
	
	if step_sound_time_left < 0:
		play_sound("step")
		step_sound_time_left = step_sound_time
	
func play_sprite_effect(effect_name):
	match effect_name:
		"jump":
			animation_player_effects.play("jump")
		"hit_floor":
			animation_player_effects.play("hit_floor")
	
