extends Area2D

var theta: float = 0.0
var radius: float = 30.0
var speed: float = 2
var damage: int = 2
var attack_rate := 0.5
var arch_offset := 0.0
var cats_being_brushed: Array[Cat] = []

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	attack()
	
func _process(delta: float) -> void:
	
	position = radius * Vector2(1.0, 0.0).rotated(arch_offset + theta)
	theta += speed * delta 
	
	# Emit dust particles if there are cats being brushed
	if cats_being_brushed.size() > 0:
		gpu_particles_2d.emitting = true
	else:
		gpu_particles_2d.emitting = false

func _on_body_entered(body: Node2D) -> void:
	if body is Cat:
		#attack()
		body.take_damage(damage)
		audio_stream_player_2d.pitch_scale = randf_range(0.85, 1.25)
		audio_stream_player_2d.volume_db = randf_range(-10.0, -5.0)
		audio_stream_player_2d.play()
		if body.life > 0:
			body.being_brushed = true
			cats_being_brushed.append(body)

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
