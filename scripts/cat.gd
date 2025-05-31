extends CharacterBody2D
class_name Cat

@export var speed: float = 25.0
@export var attack_range: float = 15.0
@onready var attack_timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var life: int = 5

var player: CharacterBody2D
var attack_on_cooldown := false

var being_brushed = false
var exit_direction = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# If cat's life has reached 0, it will run away from the player until it vanishes
	if life <= 0:
		die()
		return
	
	# Change cat speed if being brushed
	speed = 10.0 if being_brushed else 25.0
	
	# Check direction towards player
	var direction = (player.global_position - global_position).normalized()
	
	# Flip Sprite
	if direction.x >= 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	
	# Attack if close enough, move if not
	var distance = global_position.distance_to(player.global_position)
	if distance < attack_range:
		if !attack_on_cooldown:
			attack()
	else:
		animated_sprite_2d.play("run")
		velocity = direction * speed
		move_and_slide()
	
func attack():
	player.take_damage(1)
	animated_sprite_2d.play("attack")
	attack_timer.start(1.2)
	attack_on_cooldown = true

func die():
	# Check if exit direction was set
	if exit_direction.length_squared() < 0.1:
		exit_direction = (global_position - player.global_position).normalized()

		# Flip Sprite according to exit direction
		if exit_direction.x >= 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true

		# Set exit speed, run animation with custom speed, and remove collision component
		speed = 75.0
		animated_sprite_2d.play("run", 2.0)
		$CollisionShape2D.queue_free()

	velocity = exit_direction * speed
	move_and_slide()


func _on_timer_timeout() -> void:
	attack_on_cooldown = false
