extends Area2D

var theta: float = 0.0
var radius: float = 50.0
var speed: float = 1.5
var damage: int = 3
var attack_rate := 0.5
var cats_being_brushed: Array[Cat] = []

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	attack()
	
func _process(delta: float) -> void:
	# Move around
	position = radius * Vector2(cos(theta), sin(theta))
	theta += speed * delta
	
	# Emit dust particles if there are cats being brushed
	if cats_being_brushed.size() > 0:
		gpu_particles_2d.emitting = true
	else:
		gpu_particles_2d.emitting = false

func _on_body_entered(body: Node2D) -> void:
	if body is Cat:
		if body.life > 0:
			body.being_brushed = true
			cats_being_brushed.append(body)
			audio_stream_player_2d.play()

func _on_body_exited(body: Node2D) -> void:
	if body is Cat:
		cats_being_brushed.erase(body)
		body.being_brushed = false
		
func attack():
	timer.start(attack_rate)
	for cat in cats_being_brushed:
		cat.take_damage(damage)

func _on_timer_timeout() -> void:
	attack()
