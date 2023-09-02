extends Path2D

onready var follow = $PathFollow2D
onready var enemy_sprite = $PathFollow2D/Enemy/Sprite
export var backwards = false
export var seconds = 2
var tween

func _ready():
	tween = Tween.new()
	add_child(tween)
	play_tween()
	
	
func play_tween():
	var start; var end
	if !backwards:
		start = 0; end = 0.98
	else:
		start = 0.98; end = 0
	
	tween.interpolate_property(follow, "unit_offset",
								start, end, seconds,
								tween.TRANS_LINEAR,
								tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	backwards = !backwards
	enemy_sprite.flip_h = !backwards
	play_tween()