extends CanvasLayer

onready var ligado = $Fundo/ligado
onready var texto = $Painel/Label
onready var label = $energia
onready var desligado = $Fundo/desligado

func _process(_delta):
	ligado_desligado()
	label.text = str(EnergiaManeger.energia_atual)

func ligado_desligado():
	if EnergiaManeger.energia_atual == 1:
		ligado.visible = true
		desligado = false
	else:
		ligado.visible = false
		desligado = true

func abrir(mensagem):
	visible = true
	texto.text = mensagem

func fechar():
	visible = false
	
func _on_FECHAR_pressed():
	fechar()
