extends Node2D

enum UpgradeTypes {MOVE_SPEED, BRUSH_NUMBER, FULL_HEAL}

@export var upgrade_menu : Control
@export var upgrade_type : UpgradeTypes
@export var player : Player

@onready var icon: Sprite2D = $Icon
@onready var name_label: Label = $Name
@onready var description_label: Label = $Description

var human_texture = preload("res://sprites/base_human.png")
var brush_texture = preload("res://sprites/brush.png")
var heart_texture = preload("res://sprites/heart.png")

func _ready() -> void:
	match upgrade_type:
		UpgradeTypes.MOVE_SPEED:
			icon.texture = human_texture
			name_label.text = "MOVE SPEED"
			description_label.text = "Remind yourself you are alergic to cats"
		UpgradeTypes.BRUSH_NUMBER:
			icon.texture = brush_texture
			name_label.text = "+1 BRUSH"
			description_label.text = "Remember what you learned working at the air salon"
		UpgradeTypes.FULL_HEAL:
			icon.texture = heart_texture
			name_label.text = "FULL HEAL"
			description_label.text = "Think of the pizza leftover you have on the fridge"

func _on_texture_button_pressed() -> void:
	match upgrade_type:
		UpgradeTypes.MOVE_SPEED:
			player.speed += 20
		UpgradeTypes.BRUSH_NUMBER:
			player.numBrushes +=1
			player.spawn_brushes()
		UpgradeTypes.FULL_HEAL:
			player.took_damage.emit(-5)
	upgrade_menu.visible = false
	Engine.time_scale = 1
