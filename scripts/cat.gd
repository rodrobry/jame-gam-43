extends Area2D

@export var speed: float = 100.0
@export var stop_distance: float = 15.0

@onready var player: AnimatableBody2D = %Player

func _process(delta: float) -> void:
	# Check direction towards player
	var direction = (player.global_position - global_position).normalized()
	
	# Don't move if close enough
	var distance = global_position.distance_to(player.global_position)
	if distance < stop_distance:
		return
	
	#Move
	global_position += direction * speed * delta
