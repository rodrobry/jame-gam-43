extends Control

func _on_go_again_pressed() -> void:
	get_tree().reload_current_scene()
