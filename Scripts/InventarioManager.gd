extends Node

var slots = [null, null,null,null,null]
var slot_selecionado = 0

func adicionar_item(item):
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = item
			return true
	return false
