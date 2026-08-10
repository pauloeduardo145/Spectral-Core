extends KinematicBody2D


#variação de estados
var corajoso = 100
var medroso = 100

# Dano
var dano_base := 10
var tipo_dano := "delay" # "instantaneo", "delay", "continuo"

# Controle
var pode_dar_dano := true


var alvo_em_contato = null
var velocidade = Vector2.ZERO
var player = null


func _ready():
	$anim.play("default")
	randomize()
	
	player = get_tree().get_root().find_node("Player", true, false)
	
	corajoso = randi() % 101
	medroso = randi() % 101
	
	
func get_save_data():
	return{
		
		"x": global_position.x,
		"y": global_position.y,
		"corajoso": corajoso,
		"medroso": medroso
	}

func _physics_process(_delta):
	if player == null:
		return
		
	tipo_de_fantasma()
		
	move_and_slide(velocidade)

func tipo_de_fantasma():
	if corajoso > medroso:
		var direcao = (player.global_position - global_position).normalized()
		velocidade = direcao * 100
		
	elif medroso > corajoso:
		var direcao = (global_position - player.global_position).normalized()
		velocidade = direcao * 10

	if velocidade.x < 0:
		$anim.flip_h = false
	elif velocidade.x > 0:
		$anim.flip_h = true

func _on_Dano_body_entered(body):
	if body.name == "Player":
		vida_script.levar_dano(20)
