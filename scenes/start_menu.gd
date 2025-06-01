extends Control

func _ready() -> void:
	get_tree().paused = true

func _on_start_pressed() -> void:
	get_tree().paused = false
	self.visible = false
