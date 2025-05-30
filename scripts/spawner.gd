extends Node

@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = %Player

enum Sides {RIGHT, TOP, LEFT, BOTTOM}

var spawn_side : Sides

const CAT = preload("res://scenes/cat.tscn")

func _ready() -> void:
	spawn_enemy()
	timer.start

func _on_timer_timeout():
	spawn_enemy()
	timer.start()
	
func spawn_enemy():
	var enemy = CAT.instantiate()
	enemy.global_position = generate_spawn_position()
	enemy.player = player
	add_child(enemy)

func generate_spawn_position() -> Vector2:
	var spawn_position: Vector2
	spawn_side = randi_range(0, 3)
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
	
	
