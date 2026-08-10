extends Node

# Constantes (ESSENCIAL para comparação correta)
const MOBILE = "Mobile"
const PC = "PC"
const DESCONHECIDO = "Desconhecido"

var tipo_dispositivo := DESCONHECIDO
var entrada_atual := "Desconhecida"
var controle_conectado := false
var nome_controle := ""

func _ready():
	detectar_dispositivo()
	detectar_controle()

func detectar_dispositivo():
	var sistema = OS.get_name()
	
	if sistema == "Android" or sistema == "iOS":
		tipo_dispositivo = MOBILE
	elif sistema == "Windows" or sistema == "Linux" or sistema == "OSX":
		tipo_dispositivo = PC
	else:
		tipo_dispositivo = DESCONHECIDO

	return tipo_dispositivo  # 🔥 importante!

func detectar_controle():
	var joypads = Input.get_connected_joypads()
	
	if joypads.size() > 0:
		controle_conectado = true
		nome_controle = Input.get_joy_name(joypads[0])
		entrada_atual = "Controle"
	else:
		controle_conectado = false
		entrada_atual = "Teclado/Mouse"

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		entrada_atual = "Teclado/Mouse"
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		entrada_atual = "Controle"
