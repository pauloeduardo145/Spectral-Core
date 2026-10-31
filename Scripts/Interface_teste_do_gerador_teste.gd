extends CanvasLayer

onready var label = $Label
onready var label2 = $Label2

func _ready():
	label.text = "O gerador está estragado"

func _on_consertar_pressed():
	if InventarioManager.slots[InventarioManager.slot_selecionado] == "Chave de fenda":
		label.text = "O gerador foi consertado\n\nA energia voltou"
		label2.text = ""
		MissoesManager.registrar("consertar", "gerador_teste")
	else:
		label2.add_color_override("font_color", Color.red)
		label2.text = "Você precisa de uma chave de fenda"

func _on_fechar_pressed():
	visible = not visible
