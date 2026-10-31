extends Area2D

var cena = load("res://Scenes/Interface_craftador_teste.tscn")
var crafter = cena.instance()

func _ready():
	get_tree().current_scene.call_deferred("add_child",crafter)
	crafter.visible = false

func _on_Craftador_teste_body_entered(body:Node):
	if body.name == "Player":
		crafter.visible = true

func _on_Craftador_teste_body_exited(body:Node):
	if body.name == "Player":
		crafter.visible = false
