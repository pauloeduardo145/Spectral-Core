extends Control

var PopupAviso = preload("res://Scenes/PopupAviso.tscn")

func verificar_save():
	var botao_continue = get_node("ButtonsContainer/Continue")
	if not Global.existe_save():
		botao_continue.disabled = true
		botao_continue.visible = false

func _physics_process(_delta):
		verificar_save()

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", self, "on_button_pressed", [button])
		

func on_button_pressed(button: Button) -> void:
	match button.name:
		"NewGame":
			Global.novo_jogo()
			get_tree().change_scene("res://Scenes/Main.tscn")
		"Continue":
			if Global.carregar_jogo():
					get_tree().change_scene("res://Scenes/Main.tscn")
		"Controls":
			var aviso = PopupAviso.instance()
			Global.salvar_jogo()
			add_child(aviso)
			yield(get_tree().create_timer(2), "timeout")
			aviso.queue_free()
		"Quit":
			Global.salvar_jogo()
			get_tree().quit()
		"Sob":
			var aviso = PopupAviso.instance()
			add_child(aviso)
			yield(get_tree().create_timer(2), "timeout")
			aviso.queue_free()
