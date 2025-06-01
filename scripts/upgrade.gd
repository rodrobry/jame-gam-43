extends Node2D

enum UpgradeTypes {MOVE_SPEED, BRUSH_SPEED, FULL_HEAL}

@export var upgrade_menu : Control
@export var upgrade_type : UpgradeTypes
@onready var icon: Sprite2D = $Icon

var human_texture = preload("res://sprites/base_human.png")
var brush_texture = preload("res://sprites/brush.png")
var heart_texture = preload("res://sprites/heart.png")

func _ready() -> void:
	print(upgrade_type)
	match upgrade_type:
		UpgradeTypes.MOVE_SPEED:
			icon.texture = human_texture
		UpgradeTypes.BRUSH_SPEED:
			icon.texture = brush_texture
		UpgradeTypes.FULL_HEAL:
			icon.texture = heart_texture

func _on_texture_button_pressed() -> void:
	upgrade_menu.visible = false
	Engine.time_scale = 1
