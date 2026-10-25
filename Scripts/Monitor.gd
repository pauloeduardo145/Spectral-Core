extends CanvasLayer

export (NodePath) var ligado_path
onready var ligado = get_node(ligado_path)
onready var texto = $Root/ForaMonitor/Label
onready var texto2 = $Root/ForaMonitor/Label2

func _process(_delta):
	texto2.text = str(EnergiaManeger.energia_atual)

func abrir(mensagem):
	visible = true
	texto.text = mensagem

func _on_LigaDesliga_pressed():
	ligado.visible = !ligado.visible

func fechar():
	visible = false
	
func _on_FECHAR_pressed():
	fechar()
