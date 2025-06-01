extends Control

@onready var start_menu: Control = $"../StartMenu"

func _on_go_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
