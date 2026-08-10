extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		var pegou = InventarioManager.adicionar_item("Aspirador")
		
		
		if pegou:
			queue_free() # remove o item do mapa
