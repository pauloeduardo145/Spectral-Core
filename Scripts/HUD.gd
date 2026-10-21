extends CanvasLayer

onready var label = $Label
onready var ligado = $Ligado/Label

onready var slots_ui = [
	$Control/HBoxContainer/Slot0,
	$Control/HBoxContainer/Slot1,
	$Control/HBoxContainer/Slot2,
	$Control/HBoxContainer/Slot3,
	$Control/HBoxContainer/Slot4
]

var tempo_total := 0.0
var presente = ""
var slot_selecionado = 0

func _ready():
	visible = false
	vida_script.vida_bar = $vida/bar
	vida_script.label_vida = $print

	randomize()

func iniciar_partida():
	if Global.jogador_id == 0:
		Global.jogador_id = gerar_id()
	$"ID/Numero".text = str(Global.jogador_id)
	preparar_presente()
	entregar_presente()  # entrega automaticamente

func _physics_process(_delta):
	# O HUD é autoload e roda desde o menu: só conta o tempo durante o jogo
	if visible:
		Global.tempo_total += _delta
	atualizar_texto()
	atualizar_ui()
	vida_script.limitar_vida()

	if EnergiaManeger.ligado == true:
		ligado.text = str("1")


func atualizar_texto():
	var total = int(Global.tempo_total)
	var horas = total / 3600
	var minutos = (total % 3600) / 60
	var segundos = total % 60
	
	label.text = "%02d:%02d:%02d" % [horas, minutos, segundos]


func gerar_id():
	var minimo = 1000000000
	var maximo = 9999999999
	# randi() só vai até ~4,29 bilhões: o antigo "randi() % faixa" nunca passava
	# de ~5,29 bilhões. Combinando dois randi() cobre a faixa inteira.
	var aleatorio = ((randi() & 0x7FFFFFFF) << 32) | randi()
	return minimo + aleatorio % (maximo - minimo + 1)

func soma_digitos(id_numero):
	var soma = 0
	var id_string = str(id_numero)
	for caractere in id_string:
		soma += int(caractere)
	return soma

func definir_presente(id_numero):
		var total = soma_digitos(id_numero)
		if total % 2 == 0:
			return "amuleto_luz"
		else:
			return "fragmento_sombra"

func preparar_presente():
	presente = definir_presente(Global.jogador_id)

func entregar_presente():
	if presente == "amuleto_luz":
		print("Recebeu o Amuleto da Luz")
	else:
		print("Recebeu o Fragmento da Sombra")
#porque que diabos não sai um fragmento da sombra? 
#FINALMENTE

func salvar_manual():
	Global.salvar_jogo()
	print("Save manual realizado.")


func atualizar_ui():
	for i in range(slots_ui.size()):
		var item = InventarioManager.slots[i]
		
		# textura
		if item == null:
			slots_ui[i].texture = null
		else:
			slots_ui[i].texture = get_textura_do_item(item)
		
		# destaque
		if i == InventarioManager.slot_selecionado:
			slots_ui[i].get_node("Highlight").visible = true
		else:
			slots_ui[i].get_node("Highlight").visible = false


func get_textura_do_item(item):
	match item:
		"Chave de fenda":
			return preload("res://Assets/Ferramentas/Chave de fenda.png")
		"Chave Universal":
			return preload("res://Assets/Ferramentas/Chave Universal.png")
		"espada":
			return preload("res://Assets/Ferramentas/Martelo.png")
		"Aspirador":
			return preload("res://Assets/Aspirador de pó.png")
	
	return null
