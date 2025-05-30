extends CharacterBody2D

@export var speed: float = 100.0
@export var stop_distance: float = 15.0

var player: AnimatableBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	# Check direction towards player
	var direction = (player.global_position - global_position).normalized()
	
	# Flip Sprite
	if direction.x >= 0:
		sprite_2d.flip_h = false
	else:
		sprite_2d.flip_h = true
		
	
	# Don't move if close enough
	var distance = global_position.distance_to(player.global_position)
	if distance < stop_distance:
		return
	
	#Move
	velocity = direction * speed
	move_and_slide()
