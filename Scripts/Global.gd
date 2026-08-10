extends Node

var player_pos := Vector2.ZERO 
var tempo_total := 0.0
var jogador_id := 0
var pos_spawn := Vector2.ZERO
var spawn_position = null
var caminho_save = "user://save_game.dat"

func _ready():
	pass

func salvar_jogo():

	var arquivo = File.new()
	
	if arquivo.open(caminho_save, File.WRITE) == OK:
		var dados = {
		"tempo_total": tempo_total,
		"jogador_id": jogador_id,
		"player_pos": player_pos,
		"vida_atual": vida_script.vida_atual,
		"vida_visual": vida_script.vida_visual,
		"energia_atual": EnergiaManeger.energia_atual,
		"slots": InventarioManager.slots}
		arquivo.store_var(dados)
		arquivo.close()
	else:
		pass

func carregar_jogo() -> bool:
	var arquivo = File.new()
	if not arquivo.file_exists(caminho_save):
		return false

	if arquivo.open(caminho_save, File.READ) == OK:
		var dados = arquivo.get_var()
		arquivo.close()
		
		tempo_total = dados["tempo_total"]
		jogador_id = dados["jogador_id"]
		player_pos = dados["player_pos"]
		vida_script.vida_atual = dados["vida_atual"]
		vida_script.vida_visual = dados["vida_visual"]
		EnergiaManeger.energia_atual = dados["energia_atual"]
		InventarioManager.slots = dados["slots"]
		
		vida_script.iniciar_regeneracao()
		vida_script.vida_visual = vida_script.vida_atual
		vida_script.limitar_vida()
		return true
	
	return false
	

func novo_jogo():
	tempo_total = 0.0
	jogador_id = 0
	
	var dir = Directory.new()
	if dir.file_exists(caminho_save):
		dir.remove(caminho_save)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var player = get_tree().get_root().find_node("Player", true, false)
		
		if player:
			player_pos = player.global_position
		get_tree().quit()

func existe_save() -> bool:
	var arquivo = File.new()
	return arquivo.file_exists(caminho_save)




