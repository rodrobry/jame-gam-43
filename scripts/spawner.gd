extends Node

@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = %Player
@onready var texture_progress_bar: TextureProgressBar = $"../UI/ProgressBar/TextureProgressBar"
@onready var wave_label: Label = $"../UI/ProgressBar/WaveLabel"
@onready var upgrade_menu: Control = $"../UI/UpgradeMenu"

enum Sides {RIGHT, TOP, LEFT, BOTTOM}

var spawn_side : Sides
var dead_enemies := 0
var spawn_rate := 1.5
var current_wave := 1

var waves = {
	1:{"spawn_rate": 2, "enemies_in_wave": 5},
	2:{"spawn_rate": 1.4, "enemies_in_wave": 10},
	3:{"spawn_rate": 1.3, "enemies_in_wave": 15},
	4:{"spawn_rate": 1.2, "enemies_in_wave": 20},
	5:{"spawn_rate": 1.1, "enemies_in_wave": 30},
	6:{"spawn_rate": 1.0, "enemies_in_wave": 40},
	7:{"spawn_rate": 0.9, "enemies_in_wave": 50},
	8:{"spawn_rate": 0.8, "enemies_in_wave": 60},
	9:{"spawn_rate": 0.7, "enemies_in_wave": 70},
	10:{"spawn_rate": 0.6, "enemies_in_wave": 80},
	}

const CAT = preload("res://scenes/cat.tscn")

func _ready() -> void:
	spawn_enemy()
	timer.start(spawn_rate)

func _on_timer_timeout():
	spawn_enemy()
	timer.start(spawn_rate)
	
func spawn_enemy():
	var enemy = CAT.instantiate()
	enemy.global_position = generate_spawn_position()
	enemy.player = player
	add_child(enemy)
	enemy.enemy_died.connect(_on_enemy_died)

func generate_spawn_position() -> Vector2:
	var spawn_position: Vector2
	spawn_side = Sides.values().pick_random()
	match spawn_side:
		Sides.RIGHT:
			spawn_position.x = 300
			spawn_position.y = randi_range(-175, 175)
		Sides.TOP:
			spawn_position.x = randi_range(-300, 300)
			spawn_position.y = 175
		Sides.LEFT:
			spawn_position.x = randi_range(-175, 175)
			spawn_position.y = -300
		Sides.BOTTOM:
			spawn_position.x = randi_range(-300, 300)
			spawn_position.y = -175
	return spawn_position
	
func _on_enemy_died():
	dead_enemies += 1
	var enemies_in_wave = waves[current_wave]["enemies_in_wave"]
	print(str(dead_enemies) + " / " + str(enemies_in_wave))
	if dead_enemies >= enemies_in_wave:
		Engine.time_scale = 0
		upgrade_menu.visible = true
		current_wave += 1
		if current_wave > 10:
			print("You won!")
		dead_enemies = 0
		wave_label.text = "Wave: " + str(current_wave)
	texture_progress_bar.value = dead_enemies * 100 / enemies_in_wave
	
