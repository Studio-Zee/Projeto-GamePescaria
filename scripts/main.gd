extends Node2D

@export var cena_do_peixe: PackedScene 

@onready var container_peixes = $GameManager/PeixesContainer
@onready var sistema_gancho = $GameManager/PlayerBoat/GanchoSystem

var tempo_spawn = 0.0

func _ready():
	sistema_gancho.peixe_capturado.connect(_on_pontuar)

func _process(delta):
	tempo_spawn += delta
	if tempo_spawn > 2.0:
		spawn_peixe()
		tempo_spawn = 0.0

func spawn_peixe():
	if cena_do_peixe == null:
		print("ERRO: Você esqueceu de colocar a cena do peixe no Inspector da Main!")
		return

	var novo_peixe = cena_do_peixe.instantiate()
	container_peixes.add_child(novo_peixe)
	
	var altura = randf_range(300, 1000)
	
	if randi() % 2 == 0:
		novo_peixe.position = Vector2(-50, altura) 
		if "velocidade" in novo_peixe: novo_peixe.velocidade = 150
	else:
		novo_peixe.position = Vector2(750, altura) 
		if "velocidade" in novo_peixe: novo_peixe.velocidade = -150
		novo_peixe.scale.x = -1 

func _on_pontuar(pontos):
	print("Jogador ganhou: ", pontos)
