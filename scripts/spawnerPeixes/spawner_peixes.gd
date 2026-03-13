extends Node2D

# Mudamos de uma cena única para um Array (lista) de cenas!
@export var tipos_de_peixes: Array[PackedScene] 

@export var altura_minima: float = 600.0
@export var altura_maxima: float = 1100.0

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	# Verifica se a lista está vazia para não dar erro
	if tipos_de_peixes.is_empty():
		print("Coloque as cenas dos peixes na lista do Spawner!")
		return
		
	# Sorteia um peixe aleatório da sua lista
	var cena_escolhida = tipos_de_peixes.pick_random()
	
	# Cria a cópia do peixe sorteado
	var novo_peixe = cena_escolhida.instantiate()
	
	var altura_sorteada = randf_range(altura_minima, altura_maxima)
	var lado_sorteado = randi() % 2
	
	if lado_sorteado == 0:
		novo_peixe.position = Vector2(-100, altura_sorteada)
		novo_peixe.direcao = 1
	else:
		novo_peixe.position = Vector2(600, altura_sorteada) # Ajuste o 600 para a largura da sua tela
		novo_peixe.direcao = -1
		
	add_child(novo_peixe)
