extends AnimatableBody2D

@export var speed: float = 100.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement.
	var input_vector := Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		input_vector.x = 1
		animated_sprite_2d.flip_h = false
	elif Input.is_action_pressed("move_left"):
		input_vector.x = -1
		animated_sprite_2d.flip_h = true

	if Input.is_action_pressed("move_down"):
		input_vector.y = 1
	elif Input.is_action_pressed("move_up"):
		input_vector.y = -1

	global_position += input_vector * speed * delta
	
