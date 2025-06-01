class_name Cat

extends CharacterBody2D

@export var speed: float = 25.0
@export var attack_range: float = 15.0
@onready var attack_timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player: CharacterBody2D
var life: int = 5
var being_brushed = false
var is_dying = false
var attack_on_cooldown := false
var exit_direction = Vector2.ZERO

signal enemy_died

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
	animated_sprite_2d.play("attack")
	attack_timer.start(1.2)
	attack_on_cooldown = true

func die():
	# Emit death signal once
	if !is_dying:
		$AnimatedSprite2D/GPUParticles2D.emitting = true
		enemy_died.emit()
		is_dying = true
	
	# Check if exit direction was set
	if exit_direction.length_squared() < 0.1:
		exit_direction = (global_position - player.global_position).normalized()

		# Flip Sprite according to exit direction
		if exit_direction.x >= 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true

		if self.life <= 0:
			var t = get_tree().create_tween()
			t.tween_property(self, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
			t.play()
			t.tween_callback(Callable(self, "_on_fade_complete"))
			

		# Set exit speed, run animation with custom speed, and remove collision component
		speed = 75.0
		animated_sprite_2d.play("run", 2.0)
		$CollisionShape2D.queue_free()

	velocity = exit_direction * speed
	move_and_slide()

func take_damage(damage: int) -> void:
	life -= damage
	being_brushed = true
	var t = get_tree().create_tween()
	t.tween_property(self, "modulate", Color(1, 0.5, 1), 0.125).set_trans(Tween.TRANS_LINEAR)
	t.play()
	t.tween_callback(Callable(self, "_modulate_back"))

func _modulate_back() -> void:
	var t = get_tree().create_tween()
	t.tween_property(self, "modulate", Color.WHITE, 0.125).set_trans(Tween.TRANS_LINEAR)
	t.play()

func _on_timer_timeout() -> void:
	attack_on_cooldown = false

func _on_fade_complete() -> void:
	queue_free()

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "attack" and animated_sprite_2d.frame == 3:
		player.take_damage(1)
