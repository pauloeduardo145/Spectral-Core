extends KinematicBody2D

const SPEED = 300

var aspirador = false
var motion = Vector2()
var fantasma_perto = null
var ultima_direcao = "down"

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
	
	print("ITEM:",item)
	
	if item == null:
		print("Slot vazio")
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
				return
			alvo = alvo.get_parent()
