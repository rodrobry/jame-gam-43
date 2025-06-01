extends Control

@onready var resume_button: TextureButton = $Resume

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		resume_button.visible = true

func _on_resume_pressed() -> void:
		get_tree().paused = false
		resume_button.visible = false
