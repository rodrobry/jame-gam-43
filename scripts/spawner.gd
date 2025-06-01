extends Node

@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = %Player
@onready var texture_progress_bar: TextureProgressBar = $"../UI/ProgressBar/TextureProgressBar"
@onready var wave_label: Label = $"../UI/ProgressBar/WaveLabel"
@onready var upgrade_menu: Control = $"../UI/UpgradeMenu"
@onready var victory_menu: Control = $"../UI/VictoryMenu"

enum Sides {RIGHT, TOP, LEFT, BOTTOM}

var spawn_side : Sides
var dead_enemies := 0
var spawn_rate := 1.5
var current_wave := 10

var waves = {
	1:{"spawn_rate": 2, "enemies_in_wave": 5, "enemy_speed_multiplier": 1},
	2:{"spawn_rate": 1.5, "enemies_in_wave": 10, "enemy_speed_multiplier": 1.1},
	3:{"spawn_rate": 1.0, "enemies_in_wave": 15, "enemy_speed_multiplier": 1.2},
	4:{"spawn_rate": 0.75, "enemies_in_wave": 25, "enemy_speed_multiplier": 1.3},
	5:{"spawn_rate": 0.5, "enemies_in_wave": 35, "enemy_speed_multiplier": 1.4},
	6:{"spawn_rate": 0.375, "enemies_in_wave": 50, "enemy_speed_multiplier": 1.5},
	7:{"spawn_rate": 0.25, "enemies_in_wave": 65, "enemy_speed_multiplier": 1.6},
	8:{"spawn_rate": 0.1875, "enemies_in_wave": 85, "enemy_speed_multiplier": 1.7},
	9:{"spawn_rate": 0.125, "enemies_in_wave": 105, "enemy_speed_multiplier": 1.8},
	10:{"spawn_rate": 0.09375, "enemies_in_wave": 130, "enemy_speed_multiplier": 1.9},
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
	print(enemy.speed)
	enemy.speed *= waves[current_wave]["enemy_speed_multiplier"]
	print(waves[current_wave]["enemy_speed_multiplier"])
	print(enemy.speed * waves[current_wave]["enemy_speed_multiplier"])
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
		get_tree().paused = true
		current_wave += 1
		if current_wave > 10:
			victory_menu.visible = true
			return
		spawn_rate = waves[current_wave]["spawn_rate"]
		upgrade_menu.visible = true
		dead_enemies = 0
		wave_label.text = "Wave: " + str(current_wave)
	texture_progress_bar.value = dead_enemies * 100 / enemies_in_wave
	
