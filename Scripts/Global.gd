extends Node

var player_pos := Vector2.ZERO 
var tempo_total := 0.0
var jogador_id := 0
var pos_spawn := Vector2.ZERO
var spawn_position = null
var caminho_save = "user://save_game.dat"
var caminho_save_aliados = "user://save_aliados.dat"   # aliados + itens que carregam

var fantasmas_eliminados = 0
var essencia_fantasma = 0

var tem_prancheta := false

func _ready():
	pass

func _get_player():
	return get_tree().get_root().find_node("Player", true, false)

func salvar_jogo():
	# Fora do jogo (ex.: no menu) não há nada para salvar. Antes, salvar no menu
	# criava um save "vazio" com posição (0,0) e o botão Continuar aparecia.
	var player = _get_player()
	if player == null:
		return

	# Sempre grava a posição atual (antes ficava desatualizada nos saves feitos
	# pela interface da sala oeste)
	player_pos = player.global_position

	var arquivo = File.new()
	if arquivo.open(caminho_save, File.WRITE) == OK:
		var dados = {
			"tempo_total": tempo_total,
			"jogador_id": jogador_id,
			"player_pos": player_pos,
			"fantasmas_eliminados": fantasmas_eliminados,
			"prancheta": tem_prancheta,
			"vida_atual": vida_script.vida_atual,
			"vida_visual": vida_script.vida_visual,
			"energia_atual": EnergiaManeger.energia_atual,
			"essencia_fantasma": essencia_fantasma,
			"slots": InventarioManager.slots,
			"missoes": MissoesManager.dados_para_salvar()}
		arquivo.store_var(dados)
		arquivo.close()

	salvar_aliados()

# Salva todos os aliados (posição, atributos e item carregado) em arquivo próprio
func salvar_aliados():
	var lista = []
	for aliado in get_tree().get_nodes_in_group("aliado"):
		if is_instance_valid(aliado):
			lista.append(aliado.get_save_data())

	var arquivo = File.new()
	if arquivo.open(caminho_save_aliados, File.WRITE) == OK:
		arquivo.store_var({"aliados": lista})
		arquivo.close()

# Devolve a lista de dicionários dos aliados salvos (vazia se não houver/corrompido)
func carregar_aliados() -> Array:
	var arquivo = File.new()
	if not arquivo.file_exists(caminho_save_aliados):
		return []
	if arquivo.open(caminho_save_aliados, File.READ) != OK:
		return []

	var dados = arquivo.get_var()
	arquivo.close()

	if typeof(dados) != TYPE_DICTIONARY:
		return []
	var lista = dados.get("aliados", [])
	if typeof(lista) != TYPE_ARRAY:
		return []
	return lista

func carregar_jogo() -> bool:
	var arquivo = File.new()
	if not arquivo.file_exists(caminho_save):
		return false

	if arquivo.open(caminho_save, File.READ) != OK:
		return false

	var dados = arquivo.get_var()
	arquivo.close()

	# Save corrompido ou de versão antiga: não deixa o jogo crashar
	if typeof(dados) != TYPE_DICTIONARY:
		return false

	tempo_total = dados.get("tempo_total", 0.0)
	jogador_id = dados.get("jogador_id", 0)
	player_pos = dados.get("player_pos", Vector2.ZERO)
	fantasmas_eliminados = dados.get("fantasmas_eliminados", 0)
	vida_script.vida_atual = dados.get("vida_atual", vida_script.vida_maxima)
	vida_script.vida_visual = dados.get("vida_visual", vida_script.vida_atual)
	EnergiaManeger.energia_atual = dados.get("energia_atual", EnergiaManeger.energia_min)
	EnergiaManeger.ligado = EnergiaManeger.energia_atual > EnergiaManeger.energia_min
	tem_prancheta = dados.get("prancheta", false)
	essencia_fantasma = dados.get("essencia_fantasma", 0)
	MissoesManager.carregar( dados.get("missoes", {}))

	var slots = dados.get("slots", null)
	if typeof(slots) == TYPE_ARRAY and slots.size() == InventarioManager.slots.size():
		InventarioManager.slots = slots
	else:
		InventarioManager.slots = [null, null, null, null, null]

	# Save feito no meio da animação de morte: volta com vida cheia
	if vida_script.vida_atual <= vida_script.vida_minima:
		vida_script.vida_atual = vida_script.vida_maxima

	vida_script.morto = false
	vida_script.iniciar_regeneracao()
	vida_script.vida_visual = vida_script.vida_atual
	vida_script.limitar_vida()
	return true

func novo_jogo():
	tempo_total = 0.0
	jogador_id = 0
	player_pos = Vector2.ZERO
	fantasmas_eliminados = 0

	vida_script.vida_atual = vida_script.vida_maxima
	vida_script.vida_visual = vida_script.vida_maxima
	vida_script.morto = false
	EnergiaManeger.energia_atual = EnergiaManeger.energia_min
	EnergiaManeger.ligado = false
	InventarioManager.slots = [null, null, null, null, null]
	InventarioManager.slot_selecionado = 0
	tem_prancheta = false
	essencia_fantasma = 0
	MissoesManager.resetar()

	var dir = Directory.new()
	if dir.file_exists(caminho_save):
		dir.remove(caminho_save)
	if dir.file_exists(caminho_save_aliados):
		dir.remove(caminho_save_aliados)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("craftador", "devolver_tudo")
		salvar_jogo()  # só salva se estiver em jogo (ver salvar_jogo)
		get_tree().quit()

func existe_save() -> bool:
	var arquivo = File.new()
	return arquivo.file_exists(caminho_save)
