extends CanvasLayer

onready var texto = $Painel/Label

func _ready():
	pass

func abrir(mensagem):
	visible = true
	texto.text = mensagem


func fechar():
	visible = false
	
func _on_FECHAR_pressed():
	fechar()
