extends TileMapLayer
const rato_instanciado = preload("res://objetos/rato/rato.tscn")
const queijo_instanciado = preload("res://objetos/queijo/queijo.tscn")
var labirinto: Array = []

func _ready() -> void:
	Criar_labirinto()

func Criar_labirinto():
	var arquivo = FileAccess.open("res://arquivos/labirinto.txt", FileAccess.READ)
	var linhas = []
	var maior_largura = 0

	while not arquivo.eof_reached():
		var linha = arquivo.get_line()
		linhas.append(linha)

		if linha.length() > maior_largura:
			maior_largura = linha.length()

	arquivo.close()

	var borda_cima = []

	for x in range(maior_largura + 2):
		borda_cima.append([x, 0, "1", false])

	labirinto.append(borda_cima)

	var saida: bool = false
	var rato: bool = false
	var y = 1

	for linha in linhas:
		var labirinto_linha = []

		labirinto_linha.append([0, y, "1", false])

		for x in range(linha.length()):

			var caractere = linha[x]

			if caractere == "m":
				if rato == true:
					caractere = "1"
				else:
					rato = true

			elif caractere == "e":
				if saida == true:
					caractere = "1"
				else:
					saida = true

			labirinto_linha.append([x + 1, y, caractere, false])

			if caractere == "0":
				set_cell(Vector2i(x + 1, y), 0, Vector2i(1, 4))

			elif caractere == "1":
				set_cell(Vector2i(x + 1, y), 0, Vector2i(1, 1))

			elif caractere == "e" or caractere == "E":
				set_cell(Vector2i(x + 1, y), 0, Vector2i(1, 4))
				spawn_queijo(x + 1, y)

			elif caractere == "m" or caractere == "M":
				set_cell(Vector2i(x + 1, y), 0, Vector2i(5, 1))
				labirinto_linha[x + 1][3] = true
				spawn_rato(x + 1, y)

		for x in range(linha.length() + 1, maior_largura + 1):
			labirinto_linha.append([x, y, "1", false])
			set_cell(Vector2i(x, y), 1, Vector2i(1, 1))

		labirinto_linha.append([maior_largura + 1, y, "1", false])

		labirinto.append(labirinto_linha)

		y += 1
	if rato == false:
		labirinto[1][1] = [1, 1, "m", true]
		set_cell(Vector2i(1, 1), 0, Vector2i(5, 1))
		spawn_rato(1, 1)
		
	var borda_baixo = []

	for x in range(maior_largura + 2):
		borda_baixo.append([x, y, "1", false])

	labirinto.append(borda_baixo)

	for y_borda in range(labirinto.size()):
		for x_borda in range(labirinto[y_borda].size()):

			if labirinto[y_borda][x_borda][2] == "1":
				set_cell(Vector2i(x_borda, y_borda),0,Vector2i(1, 1))

func spawn_rato(x, y):
	var novo_rato = rato_instanciado.instantiate()
	novo_rato.position = map_to_local(Vector2i(x, y))
	novo_rato.z_index = 2
	add_child.call_deferred(novo_rato)

func spawn_queijo(x, y):
	var novo_queijo = queijo_instanciado.instantiate()
	novo_queijo.position = map_to_local(Vector2i(x, y))
	add_child.call_deferred(novo_queijo)
	
func editar_labirinto(vetor: Vector2i):
	if labirinto[vetor.y][vetor.x][0] == vetor.x and labirinto[vetor.y][vetor.x][1] == vetor.y:
		labirinto[vetor.y][vetor.x][3] = true
	set_cell(Vector2i(vetor.x, vetor.y), 0, Vector2i(5, 1))
