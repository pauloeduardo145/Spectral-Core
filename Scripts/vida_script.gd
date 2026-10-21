extends Node


var vida_bar = null
var label_vida = null
var TimerRegeneracao = null

var timer_regeneracao: Timer
#vida
var vida_atual = 78.0
var vida_maxima = 78.0
var vida_visual = 78.0
var vida_minima = 0.0

#regeneração

var regenerando = false
var morto = false # evita morrer/respawnar várias vezes ao mesmo tempo
var tempo_para_regenerar = 3.0 #segundos
var velocidade_regeneracao = 1.0 #vida por segundo

#cores
var verde = Color(0, 1, 0)
var amarelo = Color(1, 1, 0)
var laranja = Color(1, 0.5, 0)
var vermelho = Color(1, 0, 0)


#largura
var largura_atual = 0.0
var largura_maxima = 78.0

func _ready():

	timer_regeneracao = Timer.new()
	timer_regeneracao.wait_time = tempo_para_regenerar
	timer_regeneracao.one_shot = true
	add_child(timer_regeneracao)
	timer_regeneracao.connect("timeout", self, "_on_timer_timeout")

func limitar_vida():
	vida_atual = clamp(vida_atual, vida_minima, vida_maxima)
	var porcentagem = vida_atual / vida_maxima
	
	largura_atual = largura_maxima * porcentagem
	
	# A barra só existe depois que o HUD carrega
	if vida_bar == null:
		return
	vida_bar.rect_size.x = largura_atual

	visual()


func iniciar_regeneracao():
	regenerando = false
	timer_regeneracao.stop()
	timer_regeneracao.wait_time = tempo_para_regenerar
	timer_regeneracao.start()

func _on_timer_timeout():
	regenerando = true

func visual():
	if vida_bar == null:
		return
	var porcentagem = vida_visual / vida_maxima
	if porcentagem > 0.8:
		vida_bar.color = verde
	elif porcentagem > 0.6:
		vida_bar.color = amarelo
	elif porcentagem > 0.3:
		vida_bar.color = laranja
	else:
		vida_bar.color = vermelho

func recuperar_vida(valor):
	vida_atual += valor
	vida_atual = min(vida_atual, vida_maxima)
	limitar_vida()

func _physics_process(_delta):

	if regenerando:
		vida_atual += velocidade_regeneracao * _delta
		vida_atual = min(vida_atual, vida_maxima)
		
		if vida_atual >= vida_maxima:
			regenerando = false
			timer_regeneracao.stop()
	
	vida_visual = lerp(vida_visual, vida_atual, 1 - pow(0.2, _delta))

func levar_dano(dano):
	if morto:
		return # já está morrendo: ignora dano extra
	vida_atual -= dano
	vida_atual = max(vida_atual, vida_minima) #evita vida negativa
	
	regenerando = false
	
	timer_regeneracao.stop()
	timer_regeneracao.wait_time = tempo_para_regenerar
	timer_regeneracao.start()
	
	if vida_atual <= vida_minima:
		morrer()

func morrer():
	if morto:
		return
	morto = true
	vida_atual = vida_minima
	
	yield(get_tree().create_timer(2), "timeout")
	
	respawn()

func respawn():
	morto = false
	regenerando = false
	timer_regeneracao.stop()
	vida_atual = vida_maxima
	vida_visual = vida_maxima
	
	var player = get_tree().get_root().find_node("Player", true, false)
	
	if player:
		player.global_position = Global.spawn_position


