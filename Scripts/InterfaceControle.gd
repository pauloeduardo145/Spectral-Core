extends CanvasLayer

onready var ligado = $Fundo/ligado
onready var desligado = $Fundo/desligado

onready var texto = $Painel/Label

func abrir(mensagem):
	visible = true
	texto.text = mensagem

func fechar():
	visible = false

func _on_FECHAR_pressed():
	fechar()
