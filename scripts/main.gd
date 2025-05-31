extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	Engine.time_scale = 0 if Engine.time_scale == 1 else 1
