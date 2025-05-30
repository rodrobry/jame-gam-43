extends Area2D

var theta = 0.0
var radius = 50.0
var speed = 1.5
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _process(delta: float) -> void:
	position = radius * Vector2(cos(theta), sin(theta))
	theta += speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Cat:
		body.being_brushed = true
		gpu_particles_2d.emitting = true

func _on_body_exited(body: Node2D) -> void:
	if body is Cat:
		body.being_brushed = false
		gpu_particles_2d.emitting = false
