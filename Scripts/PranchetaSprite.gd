extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		Global.tem_prancheta = true
		
		queue_free() # remove o item do mapa
