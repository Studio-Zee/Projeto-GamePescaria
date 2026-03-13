extends Area2D

var velocidade: float = 200.0 
var direcao: int = 1 

func _ready():
	# Se a direção for -1 (indo para a esquerda), vira a imagem do peixe
	if direcao == -1:
		$Sprite2D.flip_h = true

func _process(delta: float) -> void:
	# Move o peixe
	position.x += velocidade * direcao * delta
	
	# Autodestruição: se o peixe sair muito da tela, ele é deletado
	# Ajuste esses valores (-200 e 1000) dependendo da largura da sua tela
	if position.x > 1000 or position.x < -200:
		queue_free()
