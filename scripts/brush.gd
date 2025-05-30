extends Area2D

@onready var player: CharacterBody2D = %Player

var theta = 0.0
var radius = 50.0
var speed = 1.5

func _process(delta: float) -> void:
	position = radius * Vector2(cos(theta), sin(theta))
	theta += speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Cat:
		body.being_brushed = true

func _on_body_exited(body: Node2D) -> void:
	if body is Cat:
		body.being_brushed = false
