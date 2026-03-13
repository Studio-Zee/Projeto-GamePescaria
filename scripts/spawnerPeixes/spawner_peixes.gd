extends Node2D

# Isso cria um campo no Inspector para você arrastar a cena do peixe
@export var peixe_cena: PackedScene
@onready var timer = $Timer

# Ajuste essas alturas dependendo de onde começa e termina a sua água na tela
var altura_minima = 300.0
var altura_maxima = 700.0

func _ready():
	# Conecta o sinal de tempo esgotado do Timer a este script
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if not peixe_cena:
		print("Você esqueceu de colocar a cena do peixe no Spawner!")
		return
		
	# Cria uma cópia da cena do peixe
	var novo_peixe = peixe_cena.instantiate()
	
	# Sorteia uma altura (Y) aleatória para o peixe nascer
	var altura_sorteada = randf_range(altura_minima, altura_maxima)
	
	# Sorteia se ele nasce na esquerda (0) ou direita (1)
	var lado_sorteado = randi() % 2
	
	if lado_sorteado == 0:
		# Nasce na esquerda (fora da tela) e vai para a direita
		novo_peixe.position = Vector2(-100, altura_sorteada)
		novo_peixe.direcao = 1
	else:
		# Nasce na direita (fora da tela) e vai para a esquerda
		# Troque o '600' pela largura máxima da sua tela + um chorinho
		novo_peixe.position = Vector2(600, altura_sorteada)
		novo_peixe.direcao = -1
		
	# Finalmente, coloca o peixe no mundo
	add_child(novo_peixe)
