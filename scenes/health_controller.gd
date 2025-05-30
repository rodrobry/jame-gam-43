extends Control

@onready var heart_1: Sprite2D = $Heart1
@onready var heart_2: Sprite2D = $Heart2
@onready var heart_3: Sprite2D = $Heart3
@onready var timer: Timer = $Timer

var health = 3

const dark_shade = Color(0.15, 0.15, 0.15)  # Dark grey

func _on_player_took_damage(damage: int) -> void:
	# Decrease health and updateUI
	health -= damage
	update_ui()
	
	# Reset level if out of health
	if health <= 0:
		Engine.time_scale = 0.1
		timer.start(0.1)

func update_ui():
	match health:
		2:
			heart_3.modulate = dark_shade
		1:
			heart_2.modulate = dark_shade
		0:
			heart_1.modulate = dark_shade

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
