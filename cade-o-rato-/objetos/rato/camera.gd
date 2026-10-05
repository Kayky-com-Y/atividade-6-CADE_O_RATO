extends Camera2D

@onready var voltar = $voltar
@onready var acelerar = $acelerar
@onready var rato = $".."
var vezes: int = 0

func _ready() -> void:
	voltar.pressed.connect(_on_voltar_pressed)
	acelerar.pressed.connect(_on_acelerar_pressed)

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/index/index.tscn")
	
func _on_acelerar_pressed() -> void:
	if vezes == 0:
		rato.timer_espera.wait_time = 0.2
		rato.timer.wait_time = 0.2
	elif vezes == 1:
		rato.timer_espera.wait_time = 0.01
		rato.timer.wait_time = 0.01
	elif vezes == 2:
		rato.timer_espera.wait_time = 0.5
		rato.timer.wait_time = 0.5
	vezes+= 1
	if vezes == 3:
		vezes = 0
