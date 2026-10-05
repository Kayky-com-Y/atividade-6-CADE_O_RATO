extends Control

@onready var jogar = $HBoxContainer/VBoxContainer/HBoxContainer/Jogar
@onready var criar = $HBoxContainer/VBoxContainer/HBoxContainer/CriarLabirinto
@onready var labirinto = $HBoxContainer/VBoxContainer/TextEdit

func _ready() -> void:
	criar.pressed.connect(_on_voltar_pressed)
	jogar.pressed.connect(_on_jogar_pressed)

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/index/index.tscn")

func _on_jogar_pressed() -> void:
	var texto = labirinto.text
	var arquivo = FileAccess.open("res://arquivos/labirinto.txt", FileAccess.WRITE)
	if arquivo:
		arquivo.store_string(texto)
		arquivo.close()
	get_tree().change_scene_to_file("res://mapa/mapa.tscn")
