extends Control

@onready var voltar = $Button

func _ready() -> void:
	voltar.pressed.connect(_on_voltar_pressed)
	
func _on_voltar_pressed():
	get_tree().change_scene_to_file("res://interface/index/index.tscn")
