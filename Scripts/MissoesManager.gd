extends Node

const MISSOES = {
	"gerador_teste": {
		"titulo": "Consertar o gerador",
		"requisitos": [],
		"objetivos": [{"tipo": "consertar", "alvo": "gerador_teste", "qtd": 1}],
		"recompensas": [{"tipo": "essencia", "qtd": 5}],
		"categoria": "principal",
	},
	"obter_essencias": {
		"titulo": "Pegar 5 essências",
		"categoria": "secundaria",
		"requisitos": [],
		"objetivos": [{"tipo": "pegar", "alvo": "essencia", "qtd": 5}],
		"recompensas": [{"tipo": "essencia", "qtd": 5}],
	},
}

var estado = {} # id -> {"feita": false, "progresso": [0]}

func _ready():
	resetar()

func resetar():
	estado = {}

	for id in MISSOES:
		var progresso = []
		for objetivo in MISSOES[id]["objetivos"]:
			progresso.append(0)
		estado[id] = {"feita": false, "progresso": progresso}

func dados_para_salvar():
	return estado.duplicate(true)

func carregar(dados):
	resetar()
	if typeof(dados) != TYPE_DICTIONARY:
		return
	for id in estado:
		if dados.has(id) and typeof(dados[id]) == TYPE_DICTIONARY:
			estado[id]["feita"] = dados[id].get("feita",false)
			var progresso = dados[id].get("progresso", null)
			if typeof(progresso) == TYPE_ARRAY and progresso.size() == estado[id]["progresso"].size():
				estado[id]["progresso"] = progresso

signal missao_concluida(id)


# Chamada por quem faz a ação. Ex.: registrar("consertar", "gerador_teste")
func registrar(tipo, alvo, qtd = 1):
	for id in MISSOES:
		if estado[id]["feita"] or not disponivel(id):
			continue

		var objetivos = MISSOES[id]["objetivos"]
		for i in range(objetivos.size()):
			var obj = objetivos[i]
			if obj["tipo"] == tipo and obj["alvo"] == alvo:
				estado[id]["progresso"][i] = min(estado[id]["progresso"][i] + qtd, obj["qtd"])

		if objetivos_completos(id):
			concluir(id)


# Só conta se todas as missões exigidas já estiverem feitas
func disponivel(id):
	for requisito in MISSOES[id]["requisitos"]:
		if not estado[requisito]["feita"]:
			return false
	return true


func objetivos_completos(id):
	var objetivos = MISSOES[id]["objetivos"]
	for i in range(objetivos.size()):
		if estado[id]["progresso"][i] < objetivos[i]["qtd"]:
			return false
	return true


func concluir(id):
	estado[id]["feita"] = true   # primeiro marca, depois entrega: evita entregar duas vezes
	entregar_recompensas(id)
	emit_signal("missao_concluida", id)


func entregar_recompensas(id):
	for recompensa in MISSOES[id]["recompensas"]:
		match recompensa["tipo"]:
			"essencia":
				Global.essencia_fantasma += recompensa["qtd"]
			"item":
				InventarioManager.adicionar_item(recompensa["nome"])
			_:
				print("Recompensa desconhecida: ", recompensa["tipo"])
