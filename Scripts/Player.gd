extends KinematicBody2D

const SPEED = 300
const RAIO_BEIJO = 70.0

var aspirador = false
var motion = Vector2()
var fantasma_perto = null
var ultima_direcao = "down"
var chance_drop = 25

func _ready():
	$anim.play("idle_down")
	yield(get_tree(), "idle_frame")

func salvar():
	Global.player_pos = global_position
	Global.salvar_jogo()

# Andar
func _physics_process(_delta):
	slot()
	motion = Vector2.ZERO
	
	if Input.is_action_just_pressed("f"):
		usar()
	
	if Input.is_action_just_pressed("Bejar"):
		bejar()

	# Movimento
	if Input.is_action_pressed("ui_up"):
		motion.y = -1
		ultima_direcao = "up"
	elif Input.is_action_pressed("ui_down"):
		motion.y = 1
		ultima_direcao = "down"

	if Input.is_action_pressed("ui_left"):
		motion.x = -1
		ultima_direcao = "left"
	elif Input.is_action_pressed("ui_right"):
		motion.x = 1
		ultima_direcao = "right"

	motion = motion.normalized() * SPEED
	
	if motion == Vector2.ZERO:
		# Só usa idle se existir
		if ultima_direcao == "up":
			$anim.play("idle_up")
		elif ultima_direcao == "down":
			$anim.play("idle_down")
	else:
		if abs(motion.x) > abs(motion.y):
			if motion.x > 0:
				$anim.play("walk_right")
			else:
				$anim.play("walk_left")
		else:
			if motion.y > 0:
				$anim.play("walk_down")
			else:
				$anim.play("walk_up")

	move_and_slide(motion)
# PAULO DO FUTURO NAO IMPOTA O QUE ACONTEÇAR
#NAO MEXA NO CODIGO DO JOGO

func slot():
	if Input.is_action_just_pressed("slot_1"):
		InventarioManager.slot_selecionado = 0
	if Input.is_action_just_pressed("slot_2"):
		InventarioManager.slot_selecionado = 1 
	if Input.is_action_just_pressed("slot_3"):
		InventarioManager.slot_selecionado = 2
	if Input.is_action_just_pressed("slot_4"):
		InventarioManager.slot_selecionado = 3
	if Input.is_action_just_pressed("slot_5"):
		InventarioManager.slot_selecionado = 4

func usar():
	var item = InventarioManager.slots[InventarioManager.slot_selecionado]
	
	if item == null:
		return
	
	if item == "Aspirador":
		usar_aspirador()

func usar_aspirador():
	var area = $Aspirador
	var corpos = area.get_overlapping_bodies()
	
	for body in corpos:
		var alvo = body
		while alvo != null:
			if alvo.is_in_group("fantasma"):
				alvo.queue_free()
				Global.fantasmas_eliminados += 1
				ao_aspirar()
				return
			alvo = alvo.get_parent()

func bejar():
	# Pega o fantasma hostil mais próximo dentro do alcance
	var alvo = null
	var menor_distancia = RAIO_BEIJO
	
	for fantasma in get_tree().get_nodes_in_group("fantasma"):
		var d = global_position.distance_to(fantasma.global_position)
		if d <= menor_distancia:
			menor_distancia = d
			alvo = fantasma
	
	if alvo == null:
		return
	
	if alvo.limite_aliados_atingido():
		return
	
	if alvo.tentar_aliar():
		print("O fantasma virou aliado!")
	else:
		print("O fantasma não aceitou (ou ainda está em cooldown)")

func dropar_item():
	print("Dropou")
	Global.essencia_fantasma = Global.essencia_fantasma + 1

func ao_aspirar():
	if randf() * 100 < chance_drop:
		dropar_item()
