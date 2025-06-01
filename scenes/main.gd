extends Node2D
@onready var main: Node2D = $"."
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	audio_stream_player.play()
