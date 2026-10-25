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

func _on_ligar_pressed():
	EnergiaManeger.energia_atual = clamp(EnergiaManeger.energia_atual + 1, EnergiaManeger.energia_min, EnergiaManeger.energia_max)
	EnergiaManeger.ligado = EnergiaManeger.energia_atual > EnergiaManeger.energia_min
	Global.salvar_jogo()

func _on_desligar_pressed():
	EnergiaManeger.energia_atual = clamp(EnergiaManeger.energia_atual - 1, EnergiaManeger.energia_min, EnergiaManeger.energia_max)
	EnergiaManeger.ligado = EnergiaManeger.energia_atual > EnergiaManeger.energia_min
	Global.salvar_jogo()
