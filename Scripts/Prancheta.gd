extends CanvasLayer

onready var lista_principal = $Control/VBoxContainer/VBoxContainer_TarefasPrincipais
onready var lista_secundaria = $Control/VBoxContainer/VBoxContainer_TarefasSecundarias
onready var fonte = $Control/VBoxContainer/Label_Titulo_Principal.get_font("font")
onready var fonte_2 = $Control/VBoxContainer/Label_Titulo_Secundario.get_font("font")


func _process(_delta):
	if Global.tem_prancheta:
		usar_prancheta()


func usar_prancheta():
	if Input.is_action_just_pressed("Abrir_prancheta"):
		visible = not visible
		if visible:
			atualizar_missoes()


func limpar(lista):
	for filho in lista.get_children():
		lista.remove_child(filho)
		filho.queue_free()


func atualizar_missoes():
	limpar(lista_principal)
	limpar(lista_secundaria)

	for id in MissoesManager.MISSOES:
		var missao = MissoesManager.MISSOES[id]
		if missao.get("categoria", "principal") == "principal":
			adicionar_linha(id, lista_principal, fonte)
		else:
			adicionar_linha(id, lista_secundaria, fonte_2)


func adicionar_linha(id, destino, fonte_da_linha):
	var feita = MissoesManager.estado[id]["feita"]
	var label = Label.new()
	label.text = ("[x] " if feita else "[ ] ") + MissoesManager.MISSOES[id]["titulo"]
	label.add_font_override("font", fonte_da_linha)
	label.add_color_override("font_color", Color(0, 0, 0))
	destino.add_child(label)