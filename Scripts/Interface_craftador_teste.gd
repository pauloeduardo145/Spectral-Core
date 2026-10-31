extends CanvasLayer

# ---------- RECEITAS ----------
# Para criar uma receita nova, basta acrescentar uma linha aqui.
#   "itens":    materiais tirados do inventário (nome: quantidade)
#   "essencia": essência de fantasma gasta (do Global)
# O nome da receita é o nome do item que vai para o inventário.
# Atenção: o nome precisa ser igual ao usado em HUD.gd (get_textura_do_item),
# senão o item aparece como slot vazio no HUD.
const RECEITAS = {
	"Chave de fenda": {"itens": {}, "essencia": 3},
	"Fusível": {"itens": {"Sucata": 2}, "essencia": 0},
}

onready var lista = $Fundo/Receitas
onready var detalhes = $Fundo/Detalhes
onready var mensagem = $Fundo/Mensagem

var nomes = []          # nomes das receitas, na mesma ordem da lista na tela
var selecionada = -1    # índice da receita escolhida (-1 = nenhuma)


func _ready():
	for nome in RECEITAS:
		nomes.append(nome)
		lista.add_item(nome)
	atualizar_detalhes()


# Chame abrir() em vez de mudar só o visible: ela atualiza os números na tela.
func abrir():
	visible = true
	mensagem.text = ""
	atualizar_detalhes()


func fechar():
	visible = false


# ---------- CONSULTAS ----------
# Quantos slots do inventário têm este item
func contar(nome):
	var total = 0
	for item in InventarioManager.slots:
		if item == nome:
			total += 1
	return total


func tem_materiais(receita):
	for ingrediente in receita["itens"]:
		if contar(ingrediente) < receita["itens"][ingrediente]:
			return false
	return Global.essencia_fantasma >= receita["essencia"]


# O resultado precisa de um slot livre (os materiais gastos também liberam slots)
func tem_espaco(receita):
	var livres = 0
	for item in InventarioManager.slots:
		if item == null:
			livres += 1
	var liberados = 0
	for ingrediente in receita["itens"]:
		liberados += receita["itens"][ingrediente]
	return livres + liberados >= 1


# ---------- AÇÕES ----------
func consumir(receita):
	for ingrediente in receita["itens"]:
		var restante = receita["itens"][ingrediente]
		for i in range(InventarioManager.slots.size()):
			if restante == 0:
				break
			if InventarioManager.slots[i] == ingrediente:
				InventarioManager.slots[i] = null
				restante -= 1
	Global.essencia_fantasma -= receita["essencia"]


func fabricar():
	if selecionada == -1:
		aviso("Escolha uma receita", false)
		return

	var nome = nomes[selecionada]
	var receita = RECEITAS[nome]

	if not tem_materiais(receita):
		aviso("Faltam materiais", false)
		return
	if not tem_espaco(receita):
		aviso("Inventário cheio", false)
		return

	consumir(receita)
	InventarioManager.adicionar_item(nome)
	aviso("Fabricou: " + nome, true)
	atualizar_detalhes()


# ---------- TELA ----------
func atualizar_detalhes():
	if selecionada == -1:
		detalhes.text = "Escolha uma receita"
		return

	var nome = nomes[selecionada]
	var receita = RECEITAS[nome]
	var texto = nome + "\n\nPrecisa de:\n"

	for ingrediente in receita["itens"]:
		texto += "- %s: %d (você tem %d)\n" % [ingrediente, receita["itens"][ingrediente], contar(ingrediente)]
	if receita["essencia"] > 0:
		texto += "- Essência: %d (você tem %d)\n" % [receita["essencia"], Global.essencia_fantasma]
	if receita["itens"].empty() and receita["essencia"] == 0:
		texto += "- nada\n"

	detalhes.text = texto


func aviso(texto, sucesso):
	if sucesso:
		mensagem.add_color_override("font_color", Color(0.4, 1.0, 0.5))
	else:
		mensagem.add_color_override("font_color", Color.red)
	mensagem.text = texto


# ---------- SINAIS ----------
func _on_Receitas_item_selected(index):
	selecionada = index
	mensagem.text = ""
	atualizar_detalhes()


func _on_Fabricar_pressed():
	fabricar()


func _on_Fechar_pressed():
	fechar()
