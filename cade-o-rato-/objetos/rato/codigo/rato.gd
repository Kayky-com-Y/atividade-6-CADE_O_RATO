extends CharacterBody2D 
 
@onready var animacao = $AnimatedSprite2D
@onready var timer = $Timer
@onready var timer_espera = $TimerEspera
@onready var tempo_do_fim = $TimerFim
@onready var tile_map_layer = $".." 
@onready var barulhinho = $AudioStreamPlayer
var queijo: bool = false 
var fim: bool = false 
var backtrap = Backtrap.new()
var caminho = Caminho.new()
var caminho_encontrado: bool = false

func _ready(): 
	position = tile_map_layer.map_to_local(tile_map_layer.local_to_map(position)) 
	timer.timeout.connect(tempo_acabou)
	timer.start()
	timer_espera.timeout.connect(tempo_espera_acabou)
	timer_espera.start()
	tempo_do_fim.timeout.connect(tempo_do_fim_acabou)
	tempo_do_fim.start()

func tempo_acabou(): 
	if queijo == false and fim == false: 
		
		if tile_map_layer.labirinto == null: 
			printerr("Nó do labirinto não encontrado")
		if caminho_encontrado == false:
			verificar_posicao()
	else:
		var posicao: Vector2i = tile_map_layer.local_to_map(position)
		animation(posicao)

func tempo_espera_acabou():
	
	if caminho_encontrado == true:
		avancar_posicao()
	else:
		voltar_posicao()

func tempo_do_fim_acabou():
	fim = true
	timer.start()

func verificar_posicao():
	var posicao: Vector2i = tile_map_layer.local_to_map(position)
	animation(posicao)
	if tile_map_layer.labirinto[posicao.y-1][posicao.x][2] != '1' and tile_map_layer.labirinto[posicao.y-1][posicao.x][3] == false:
		var no = No.new(posicao.x, posicao.y - 1, null)
		caminho.adicionar(no)
		caminho_encontrado = true
	if tile_map_layer.labirinto[posicao.y+1][posicao.x][2] != '1' and tile_map_layer.labirinto[posicao.y+1][posicao.x][3] == false:
		var no = No.new(posicao.x, posicao.y + 1, null)
		caminho.adicionar(no)
		caminho_encontrado = true
	if tile_map_layer.labirinto[posicao.y][posicao.x-1][2] != '1' and tile_map_layer.labirinto[posicao.y][posicao.x-1][3] == false:
		var no = No.new(posicao.x - 1, posicao.y, null)
		caminho.adicionar(no)
		caminho_encontrado = true
	if tile_map_layer.labirinto[posicao.y][posicao.x+1][2] != '1' and tile_map_layer.labirinto[posicao.y][posicao.x+1][3] == false:
		var no = No.new(posicao.x + 1, posicao.y, null)
		caminho.adicionar(no)
		caminho_encontrado = true
	timer_espera.start()

func voltar_posicao():
	var no = backtrap.retirar()
	if no == null:
		return false
	var vetor = Vector2i(no.posicao_x, no.posicao_y)
	move(vetor)
func avancar_posicao():
	var posicao: Vector2i = tile_map_layer.local_to_map(position)
	caminho_encontrado = false
	var no = caminho.retirar()
	var posicao_no = No.new(posicao.x, posicao.y, true)
	backtrap.adicionar(posicao_no)
	if no == null:
		fim = true
		return
	var vetor = Vector2i(no.posicao_x, no.posicao_y)
	tile_map_layer.editar_labirinto(vetor)
	move(vetor)

func move(posicao: Vector2i):
	animation(posicao)

	var nova_posicao = tile_map_layer.map_to_local(posicao)

	var tween = create_tween()
	tween.tween_property(self, "position", nova_posicao, timer.wait_time)
	timer.start()
	tempo_do_fim.start()

func animation(vetor):
	var estado: String = ''
	var posicao: Vector2i = tile_map_layer.local_to_map(position)
	if queijo == true:
		estado = "comendo"
	elif fim == true:
		estado = "chorando"
	elif vetor.x > posicao.x:
		estado = "correndo_frente"
	elif vetor.x < posicao.x:
		estado = "correndo_traz"
	elif vetor.y < posicao.y:
		estado = "correndo_cima"
	elif vetor.y > posicao.y:
		estado = "correndo_baixo"
	else:
		estado = "parado"
		barulhinho.play()
	match estado:
		"parado":
			animacao.play("default")
		"correndo_frente":
			animacao.play("correndo")
			animacao.flip_h = true
		"correndo_traz":
			animacao.play("correndo")
			animacao.flip_h = false
		"correndo_cima":
			animacao.play("correndo_cima")
		"correndo_baixo":
			animacao.play("correndo_baixo")
		"comendo":
			animacao.play("comendo")
		"chorando":
			animacao.play("chorando")

class No:
	var posicao_x
	var posicao_y
	var anterior: No
	func _init(posicao_x, posicao_y, anterior):
		self.posicao_x = posicao_x
		self.posicao_y = posicao_y
		self.anterior = null
class Caminho:
	var no_topo = null
	func adicionar(no):
		if no_topo == null:
			no_topo = no
			return
		no.anterior = no_topo
		no_topo = no
	func retirar():
		if no_topo == null:
			return null
		var no = no_topo
		no_topo = no_topo.anterior
		return no
class Backtrap:
	var no_topo = null
	func adicionar(no):
		if no_topo == null:
			no_topo = no
			return
		no.anterior = no_topo
		no_topo = no
	func retirar():
		if no_topo == null:
			return null
		var no = no_topo
		if no_topo.anterior == null:
			no_topo = null
			return no
		no_topo = no_topo.anterior
		return no
