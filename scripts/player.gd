extends CharacterBody2D

@export var speed: float = 100.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

const BRUSH = preload("res://scenes/brush.tscn")

var numBrushes = 2

signal took_damage 

func _ready() -> void:
	for i in numBrushes:
		var startTheta = i * 2.0 * PI / numBrushes
		var newBrush = BRUSH.instantiate()
		newBrush.theta = startTheta
		add_child(newBrush)

func _physics_process(_delta: float) -> void:
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
		
	if input_vector != Vector2.ZERO:
		animated_sprite_2d.play(&"run")
	else:
		animated_sprite_2d.play(&"idle")
		
	#Move
	velocity = input_vector * speed
	move_and_slide()

func take_damage(damage: int) -> void:
	# Flash the player sprite red, on timeout changes back
	animated_sprite_2d.modulate = Color(0.9, 0.4, 0.4) # Reddish
	timer.start(0.15)
	
	# Signal damage taken to health controller
	took_damage.emit(damage)
	
func _on_timer_timeout() -> void:
	animated_sprite_2d.modulate = Color(1, 1, 1) # Reset color
