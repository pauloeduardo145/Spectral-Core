extends Control

var PopupAviso = preload("res://Scenes/PopupAviso.tscn")

func verificar_save():
	var botao_continue = get_node("ButtonsContainer/Continue")
	var tem_save = Global.existe_save()
	botao_continue.disabled = not tem_save
	botao_continue.visible = tem_save

func _ready() -> void:
	verificar_save()
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
			add_child(aviso)
			yield(get_tree().create_timer(2), "timeout")
			aviso.queue_free()
		"Quit":
			get_tree().quit()
		"Sob":
			var aviso = PopupAviso.instance()
			add_child(aviso)
			yield(get_tree().create_timer(2), "timeout")
			aviso.queue_free()
