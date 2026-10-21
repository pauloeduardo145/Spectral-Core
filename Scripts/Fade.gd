extends ColorRect

# Velocidade do fade (alpha por segundo): 2.0 = 0,5 s para fade completo
const VELOCIDADE := 2.0

func _ready():
	# A cena tinha cor com alpha 0 (nunca apareceria) e bloqueava o mouse
	color = Color(0, 0, 0, 1)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	modulate.a = 0.0
	visible = false

func fade_out():
	visible = true
	modulate.a = 0.0

	while modulate.a < 1.0:
		modulate.a = min(modulate.a + VELOCIDADE * get_process_delta_time(), 1.0)
		yield(get_tree(), "idle_frame")

func fade_in():
	while modulate.a > 0.0:
		modulate.a = max(modulate.a - VELOCIDADE * get_process_delta_time(), 0.0)
		yield(get_tree(), "idle_frame")
	visible = false
