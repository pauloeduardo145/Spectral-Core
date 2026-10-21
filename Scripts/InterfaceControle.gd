extends CanvasLayer

onready var texto = $Painel/Label
onready var ligado = $Fundo/ligado
onready var desligado = $Fundo/desligado

func _process(_delta):
   verificar_energia()

func abrir(mensagem):
	visible = true
	texto.text = mensagem

func fechar():
	visible = false

func _on_FECHAR_pressed():
	fechar()

func verificar_energia():

	if EnergiaManeger.ligado == true:
		ligado.visible = true
		desligado.visible = false
	else:
		desligado.visible = true
		ligado.visible = false