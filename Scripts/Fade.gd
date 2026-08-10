extends ColorRect

func fade_out():
	visible = true
	modulate.a = 0
	
	while modulate.a <1:
		modulate.a = 0.5
		yield(get_tree(), "idle_frame")
	
func fade_in():
	while modulate.a >0:
		modulate.a = 0.5
		yield(get_tree(), "idle_frame")
	visible = false
