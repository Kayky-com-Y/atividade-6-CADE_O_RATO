extends Node

@onready var reprodutor_de_musica = $AudioStreamPlayer
var ligado = true

func _ready() -> void:
	reprodutor_de_musica.play()

func ligar_desligar():
	if ligado == true:
		ligado = false
		reprodutor_de_musica.stop()
	elif ligado == false:
		ligado = true
		reprodutor_de_musica.play()
