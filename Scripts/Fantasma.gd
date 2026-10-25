extends KinematicBody2D


#variação de estados
var corajoso = 100
var medroso = 100

var dano_base := 10            # dano de cada "tick" (no player e nos aliados)
var intervalo_dano := 1.0      # segundos entre um tick e outro no mesmo alvo
var tempo_atual := 0.0
var proximo_dano = {}          # id do alvo -> momento em que pode levar dano de novo

export var Chance_F = 0.1

const MAX_ALIADOS = 3              # máximo de aliados vivos ao mesmo tempo
const VIDA_ALIADO = 30             # vida de um aliado (3 ticks de dano_base = morre)
const COR_ALIADO = Color(0.6, 1.0, 0.8)
const COR_DANO = Color(1.0, 0.3, 0.3)

var aliado := false
var morto := false
var vida := VIDA_ALIADO
var tempo_flash := 0.0
var item_carregado = null      # item que o fantasma carrega (null = nenhum)

const ITENS_POSSIVEIS = ["Chave Universal"]
const CHANCE_CARREGAR_ITEM = 0.1   # chance de um fantasma nascer carregando item

const VELOCIDADE_ALIADO = 120
const DISTANCIA_SEGUIR = 60.0      # o aliado para de andar quando chega perto
const DISTANCIA_ENTREGA = 90.0     # distância para entregar o item ao player
const COOLDOWN_BEIJO = 1.5         # segundos até poder tentar de novo no mesmo fantasma

var tempo_cooldown_beijo := 0.0

var velocidade = Vector2.ZERO
var player = null


func _ready():
	$anim.play("default")
	randomize()
	
	# Fantasmas NÃO colidem com o player (nem entre si): só com a camada "mundo"
	# (layer 3 = valor 4). O dano é detectado pela área "Dano", que enxerga o
	# player (layer 1) e os fantasmas/aliados (layer 2).
	collision_mask = 4
	$Dano.collision_mask = 1 | 2
	
	player = get_tree().get_root().find_node("Player", true, false)
	
	corajoso = randi() % 101
	medroso = randi() % 101
	
	if randf() < CHANCE_CARREGAR_ITEM:
		item_carregado = ITENS_POSSIVEIS[randi() % ITENS_POSSIVEIS.size()]
	
func get_save_data():
	return{
		
		"x": global_position.x,
		"y": global_position.y,
		"corajoso": corajoso,
		"medroso": medroso,
		"aliado": aliado,
		"vida": vida,
		"item": item_carregado   # item que ele ainda carrega (null = nenhum)
	}

func restaurar_aliado(dados):
	corajoso = dados.get("corajoso", corajoso)
	medroso = dados.get("medroso", medroso)
	item_carregado = dados.get("item", null)
	virar_aliado()
	vida = dados.get("vida", VIDA_ALIADO)

func _physics_process(_delta):
	if tempo_cooldown_beijo > 0.0:
		tempo_cooldown_beijo -= _delta
	
	# Fim do "flash" vermelho de dano
	if tempo_flash > 0.0:
		tempo_flash -= _delta
		if tempo_flash <= 0.0:
			$anim.modulate = COR_ALIADO if aliado else Color(1, 1, 1)
	
	if player == null or not is_instance_valid(player):
		return
	
	if aliado:
		comportamento_aliado()
	else:
		tipo_de_fantasma()
		aplicar_dano_continuo(_delta)
		
	atualizar_flip()
	move_and_slide(velocidade)

func tipo_de_fantasma():
	if corajoso > medroso:
		# Persegue o alvo mais próximo: o player ou um aliado dele
		var alvo = alvo_mais_proximo()
		var direcao = (alvo.global_position - global_position).normalized()
		velocidade = direcao * 100
		
	elif medroso > corajoso:
		var direcao = (global_position - player.global_position).normalized()
		velocidade = direcao * 10

func alvo_mais_proximo():
	var melhor = player
	var menor = global_position.distance_to(player.global_position)
	for a in get_tree().get_nodes_in_group("aliado"):
		if is_instance_valid(a):
			var d = global_position.distance_to(a.global_position)
			if d < menor:
				menor = d
				melhor = a
	return melhor

func atualizar_flip():
	if velocidade.x < 0:
		$anim.flip_h = false
	elif velocidade.x > 0:
		$anim.flip_h = true

func aplicar_dano_continuo(delta):
	tempo_atual += delta
	var novos = {}
	
	for body in $Dano.get_overlapping_bodies():
		if body == self:
			continue
		var eh_player = body.name == "Player"
		var eh_aliado = body.is_in_group("aliado")
		if not eh_player and not eh_aliado:
			continue
		
		var id = body.get_instance_id()
		var proximo = proximo_dano.get(id, 0.0)
		if tempo_atual >= proximo:
			proximo = tempo_atual + intervalo_dano
			if eh_player:
				vida_script.levar_dano(dano_base)
			else:
				body.levar_dano(dano_base)
		novos[id] = proximo
	
	# Só guarda quem ainda está em contato (ao sair e voltar, leva dano na hora)
	proximo_dano = novos

# Sinal ainda conectado na cena (Fantasma.tscn); o dano agora é feito acima
func _on_Dano_body_entered(_body):
	pass

# ---------- Aliado ----------
func limite_aliados_atingido() -> bool:
	return get_tree().get_nodes_in_group("aliado").size() >= MAX_ALIADOS

# Chamado pelo Player quando aperta B perto do fantasma.
# Retorna true se o fantasma virou aliado.
func tentar_aliar() -> bool:
	if aliado or tempo_cooldown_beijo > 0.0:
		return false
	if limite_aliados_atingido():
		return false
	
	tempo_cooldown_beijo = COOLDOWN_BEIJO
	
	if randf() < Chance_F:
		virar_aliado()
		return true
	return false

func virar_aliado():
	aliado = true
	vida = VIDA_ALIADO
	proximo_dano.clear()
	velocidade = Vector2.ZERO
	
	# Sai do grupo "fantasma": o aspirador não suga mais aliados
	remove_from_group("fantasma")
	add_to_group("aliado")
	
	# Para de causar dano
	$Dano.set_deferred("monitoring", false)
	
	# Visual de aliado
	$anim.modulate = COR_ALIADO

# Aliados podem ser atacados pelos fantasmas hostis
func levar_dano(dano):
	if not aliado or morto:
		return
	
	vida -= dano
	$anim.modulate = COR_DANO
	tempo_flash = 0.15
	
	if vida <= 0:
		morrer_aliado()

func morrer_aliado():
	morto = true
	# Sai do grupo na hora: libera o "slot" para o player conseguir outro aliado
	# e impede que o aliado morto seja salvo. O item que ele carregava se perde.
	remove_from_group("aliado")
	queue_free()

func comportamento_aliado():
	var distancia = global_position.distance_to(player.global_position)
	
	if distancia > DISTANCIA_SEGUIR:
		velocidade = (player.global_position - global_position).normalized() * VELOCIDADE_ALIADO
	else:
		velocidade = Vector2.ZERO
	
	if item_carregado != null and distancia <= DISTANCIA_ENTREGA:
		entregar_item()

func entregar_item():
	# Se o inventário estiver cheio, continua carregando e tenta de novo depois
	if InventarioManager.adicionar_item(item_carregado):
		item_carregado = null