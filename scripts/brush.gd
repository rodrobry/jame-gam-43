extends Area2D

var theta: float = 0.0
var radius: float = 50.0
var speed: float = 1.5
var damage: int = 3

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _process(delta: float) -> void:
	position = radius * Vector2(cos(theta), sin(theta))
	theta += speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Cat:
		if body.life > 0:
			body.being_brushed = true
			gpu_particles_2d.emitting = true
			body.life -= damage
		
			# If cat has reached 0 life, make it vanish and be destroyed
			if body.life <= 0:
				var t = get_tree().create_tween()
				t.tween_property(body, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
				t.play()
				t.tween_callback(Callable(self, "_on_fade_complete").bind(body))
			
func _on_fade_complete(body: Cat) -> void:
	body.queue_free()

func _on_body_exited(body: Node2D) -> void:
	if body is Cat:
		body.being_brushed = false
		gpu_particles_2d.emitting = false
