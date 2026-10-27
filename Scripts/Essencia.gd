extends Area2D

var player = null
var velocidade = 0.0
var aceleracao = 600.0
var velocidade_max = 400.0

func _ready():
	connect("body_entered", self, "_on_Essencia_body_entered")

func _physics_process(delta):
	if player == null or not is_instance_valid(player):
		return
	
	velocidade = min(velocidade + aceleracao * delta, velocidade_max)
	var direcao = (player.global_position - global_position).normalized()
	global_position += direcao * velocidade * delta

	if global_position.distance_to(player.global_position) < 12:
		Global.essencia_fantasma += 1
		queue_free()


func _on_Essencia_body_entered(body):
	if body.name == "Player":
		player = body