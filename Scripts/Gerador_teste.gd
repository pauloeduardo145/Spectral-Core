extends Area2D

var cena = load("res://Scenes/Interface_teste_do_gerador_teste.tscn")
var interface = cena.instance()

func _ready():
	get_tree().current_scene.call_deferred("add_child",interface)
	interface.visible = false

func _on_Gerador_teste_body_entered(body:Node):
	if body.name == "Player":
		interface.visible = true

func _on_Gerador_teste_body_exited(body:Node):
	if body.name == "Player":
		interface.visible = false
