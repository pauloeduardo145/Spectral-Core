extends Node

export(NodePath) var spawn_atual

var PlayerScene = preload("res://Scenes/Player.tscn")
var FantasmaScene = preload("res://Scenes/Fantasma.tscn")
var SalasScript = preload("res://Scripts/Salas.gd")
var spawn_salas = {
	"sala_oeste": [Vector2(-122, 199), Vector2(198, 519)],
	"sala_centro": [Vector2(394, 212), Vector2(714, 532)],
	"sala_leste": [Vector2(862, 215), Vector2(1182, 535)],
	"sala_norte": [Vector2(356, -177), Vector2(676, 143)],
	"sala_sul": [Vector2(407, 652), Vector2(727, 972)]
}

var interfaces_paths = [
	"res://Scenes/Interface\'s/Monitor_sala_central1.tscn", # índice 0
	"res://Scenes/Interface\'s/InterfaceControle2.tscn", # índice 1
	"res://Scenes/Interface\'s/InterfaceControle3.tscn", # índice 2
	"res://Scenes/Interface\'s/InterfaceControle4.tscn", # índice 3
	"res://Scenes/Interface\'s/Interface_sala_oeste.tscn" # índice 4
]


var interfaces_instancias = []




func _ready():
	
	var player = PlayerScene.instance()
	var spawn = get_node(spawn_atual)
	
	player.global_position = spawn.global_position
		
	add_child(player)
	

	Global.spawn_position = spawn.global_position
	
	interfaces()
	ativar_pontos_de_spawn()
	
	Hud.visible = true
	yield(get_tree(), "idle_frame")   #espera 1 frame
	
	var carregou = false
	if Global.existe_save():
		carregou = Global.carregar_jogo()
	
	# Posição (0,0) = save sem posição válida (fica fora das salas): usa o spawn
	if carregou and Global.player_pos != Vector2.ZERO:
		player.global_position = Global.player_pos
	else:
		player.global_position = spawn.global_position
	
	remover_itens_ja_coletados()
	if carregou:
		restaurar_aliados()
	Hud.iniciar_partida()

# Recria os aliados salvos (com o item que cada um ainda carrega)
func restaurar_aliados():
	for dados in Global.carregar_aliados():
		if typeof(dados) != TYPE_DICTIONARY:
			continue
		var fantasma = FantasmaScene.instance()
		fantasma.position = Vector2(dados.get("x", 0.0), dados.get("y", 0.0))
		add_child(fantasma)
		fantasma.restaurar_aliado(dados)

# As áreas de spawn dos fantasmas estavam com a CollisionShape2D desligada
# (disabled = true) em Area_spawn_salas, e a sala sul nem tinha área.
# Aqui ligamos todas e criamos a da sala sul se faltar.
# (Onde ficam: Main.tscn > Area_spawn_salas > sala_norte/centro/leste/oeste >
#  "colison". O tamanho de cada sala está em Salas.gd, no dicionário spawn_salas.)
func ativar_pontos_de_spawn():
	var areas = get_node_or_null("Area_spawn_salas")
	if areas == null:
		return
	
	var tem_sul = false
	for sala in areas.get_children():
		if sala.name == "sala_sul":
			tem_sul = true
		for filho in sala.get_children():
			if filho is CollisionShape2D:
				filho.set_deferred("disabled", false)
	
	if not tem_sul:
		criar_area_sala_sul(areas)

func criar_area_sala_sul(areas):
	var area = Area2D.new()
	area.name = "sala_sul"
	area.collision_layer = 4
	area.set_script(SalasScript)
	area.set("nome_sala", "sala_sul")
	
	var forma = RectangleShape2D.new()
	forma.extents = Vector2(160, 160)
	var colisao = CollisionShape2D.new()
	colisao.shape = forma
	colisao.position = Vector2(567, 812)   # centro da região sala_sul em Salas.gd
	area.add_child(colisao)
	
	areas.add_child(area)

# Os itens do mapa não eram salvos: ao continuar, o item já coletado reaparecia
# e dava para pegar de novo (item duplicado no inventário).
func remover_itens_ja_coletados():
	var itens = get_node_or_null("Itens")
	if itens == null:
		return
	for item in itens.get_children():
		for slot in InventarioManager.slots:
			if slot != null and str(slot).to_lower() == item.name.to_lower():
				item.queue_free()
				break

func interfaces():
	for path in interfaces_paths:
		var cena = load(path)
		var instancia = cena.instance()
		
		add_child(instancia)
		instancia.visible = false
		
		interfaces_instancias.append(instancia)

func _physics_process(_delta):
	pass

func salvar(fantasma):
	var arquivo = File.new()
	if arquivo.open("user://save.dat",File.WRITE) == OK:
		arquivo.store_var(fantasma.get_save_data())
		arquivo.close()
		



func _on_Painel1_body_entered(body):
	if body.name == "Player":
		interfaces_instancias[0].abrir("Sistema da sala1")
		print("1")
func _on_Painel1_body_exited(body):
	if body.name == "Player":
		interfaces_instancias[0].fechar()
func _on_Painel2_body_entered(body):
	if body.name == "Player":
		interfaces_instancias[1].abrir("Sistema da sala2")
		print("2")
func _on_Painel2_body_exited(body):
	if body.name == "Player":
		interfaces_instancias[1].fechar()
func _on_Painel3_body_entered(_body):
	if _body.name == "Player":
		interfaces_instancias[2].abrir("Sistema da sala3")
		print("3")
func _on_Painel3_body_exited(_body):
	if _body.name == "Player":
		interfaces_instancias[2].fechar()
func _on_Painel4_body_entered(_body):
	if _body.name == "Player":
		interfaces_instancias[3].abrir("Sistema da sala4")
		print("4")
func _on_Painel4_body_exited(_body):
	if _body.name == "Player":
		interfaces_instancias[3].fechar()
func _on_Painel_interface_oeste_body_entered(body):
	if body.name == "Player":
		interfaces_instancias[4].abrir("sistema de energia")
		print("sala oeste abriu")
func _on_Painel_interface_oeste_body_exited(body):
	if body.name == "Player":
		interfaces_instancias[4].fechar()
