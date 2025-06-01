extends Control

@onready var heart_1: Sprite2D = $Heart1
@onready var heart_2: Sprite2D = $Heart2
@onready var heart_3: Sprite2D = $Heart3
@onready var heart_4: Sprite2D = $Heart4
@onready var heart_5: Sprite2D = $Heart5
@onready var timer: Timer = $Timer
@onready var game_over_menu: Control = $"../GameOverMenu"

var health = 5

const dark_shade = Color(0.15, 0.15, 0.15)
const no_shade = Color(1, 1, 1)

func _on_player_took_damage(damage: int) -> void:
	# Decrease health and updateUI
	health -= damage
	if health > 5: health = 5
	update_ui()
	
	# Reset level if out of health
	if health <= 0:
		Engine.time_scale = 0.1
		timer.start(0.1)

func update_ui():
	match health:
		5:
			heart_1.modulate = no_shade
			heart_2.modulate = no_shade
			heart_3.modulate = no_shade
			heart_4.modulate = no_shade
			heart_5.modulate = no_shade
		4:
			heart_5.modulate = dark_shade
		3:
			heart_4.modulate = dark_shade
		2:
			heart_3.modulate = dark_shade
		1:
			heart_2.modulate = dark_shade
		0:
			heart_1.modulate = dark_shade

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().paused = true
	game_over_menu.visible = true
