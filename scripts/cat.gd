extends CharacterBody2D
class_name Cat

@export var speed: float = 25.0
@export var attack_range: float = 15.0
@onready var attack_timer: Timer = $Timer

var player: CharacterBody2D
var attack_on_cooldown := false

var being_brushed = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Change cat speed if being brushed
	speed = 10.0 if being_brushed else 50.0
	
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

func _on_timer_timeout() -> void:
	attack_on_cooldown = false
