extends CanvasLayer

func _process(_delta):
	
	if Global.tem_prancheta:
		usar_prancheta()

func usar_prancheta():
	if Input.is_action_just_pressed("Abrir_prancheta"):
		visible = not visible