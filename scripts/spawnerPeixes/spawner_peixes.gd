extends Node2D

@export var tipos_de_peixes: Array[PackedScene] 

@export var altura_minima: float = 600.0
@export var altura_maxima: float = 1100.0

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if tipos_de_peixes.is_empty():
		print("Coloque as cenas dos peixes na lista do Spawner!")
		return
		
	var cena_escolhida = tipos_de_peixes.pick_random()
	
	var novo_peixe = cena_escolhida.instantiate()
	
	var altura_sorteada = randf_range(altura_minima, altura_maxima)
	var lado_sorteado = randi() % 2
	
	if lado_sorteado == 0:
		novo_peixe.position = Vector2(-100, altura_sorteada)
		novo_peixe.direcao = 1
	else:
		novo_peixe.position = Vector2(600, altura_sorteada) 
		novo_peixe.direcao = -1
		
	add_child(novo_peixe)
