extends TileMapLayer

class_name Pilha_labirinto

var no_labirinto = null
var no_labirinto_atual = null

class NoLabirinto:
	var posicao_x
	var posicao_y
	var no_anterior
	var identificador
	var percorrido

	func _init(posicao_x, posicao_y, no_anterior, identificador, percorrido):
		self.posicao_x = posicao_x
		self.posicao_y = posicao_y
		self.no_anterior = no_anterior
		self.identificador = identificador
		self.percorrido = percorrido

func pegar_posicao_atual():
	if no_labirinto_atual == null:
		return null
	return no_labirinto_atual

func avancar_pilha():
	if no_labirinto_atual == null:
		return null
	var no_anterior = no_labirinto_atual.no_anterior
	no_labirinto_atual = no_anterior
	if no_anterior == null:
		no_labirinto_atual = no_labirinto
	return true
	
func reset_pilha():
	if no_labirinto_atual == null:
		return null
	no_labirinto_atual = no_labirinto

func adicionar(no):
	if no_labirinto != null:
		no.no_anterior = no_labirinto
	no_labirinto_atual = no
	no_labirinto = no

func remover():
	var no = no_labirinto_atual
	if no == null:
		return null
	elif no.no_anterior == null:
		no_labirinto_atual = null
		no_labirinto = null
		return no
	no_labirinto_atual = no.no_anterior
	no_labirinto = no.no_anterior
	return no
