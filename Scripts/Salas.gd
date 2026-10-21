extends Area2D

export(String) var nome_sala

var FantasmaScene = preload("res://Scenes/Fantasma.tscn")
var fantasmas_spawnados = []
var spawn_salas = {
	"sala_oeste": [Vector2(-122, 199), Vector2(198, 519)],
	"sala_centro": [Vector2(394, 212), Vector2(714, 532)],
	"sala_leste": [Vector2(862, 215), Vector2(1182, 535)],
	"sala_norte": [Vector2(356, -177), Vector2(676, 143)],
	"sala_sul": [Vector2(407, 652), Vector2(727, 972)]
}

var ja_spawnou = false

func _ready():
	randomize()
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.is_in_group("player") and not ja_spawnou:
		call_deferred("spawn_fantasmas", 3)
		ja_spawnou = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		call_deferred("remover_fantasmas")
		ja_spawnou = false

func remover_fantasmas():
	for fantasma in fantasmas_spawnados:
		if is_instance_valid(fantasma) and not fantasma.is_in_group("aliado"):
			fantasma.call_deferred("queue_free")
	
	fantasmas_spawnados.clear()

func spawn_fantasmas(qtd):
	if not spawn_salas.has(nome_sala):
		return
	
	var area = spawn_salas[nome_sala]
	
	for _i in range(qtd):
		var fantasma = FantasmaScene.instance()
		fantasma.global_position = posicao_aleatoria(area)
		get_parent().add_child(fantasma)
		
		fantasmas_spawnados.append(fantasma)

func posicao_aleatoria(area):
	return Vector2(
		rand_range(area[0].x, area[1].x),
		rand_range(area[0].y, area[1].y)
	)