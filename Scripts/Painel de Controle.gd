extends Area2D

func abrir_interface():
	get_tree().call_group("ui", "mostrar")

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_PainelControle_body_entered(body):
	if body.name == "Player":
		get_tree().call_group("ui", "mostrar")
		get_tree().call_group("ui", "mostrar")
