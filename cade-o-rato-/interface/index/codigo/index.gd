extends Control

@onready var jogar = $HBoxContainer/VBoxContainer2/VBoxContainer/Jogar
@onready var creditos = $HBoxContainer/VBoxContainer2/VBoxContainer/Creditos
@onready var mute = $HBoxContainer/VBoxContainer3/HBoxContainer/Button

func _ready() -> void:
	jogar.pressed.connect(_on_jogar_pressed)
	creditos.pressed.connect(_on_creditos_pressed)
	mute.pressed.connect(_on_mute_pressed)

func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/mapaConfiguracao/mapa_configuracao.tscn")
func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/creditos/creditos.tscn")
func _on_mute_pressed() -> void:
	MusicaDeFundo.ligar_desligar()
	
