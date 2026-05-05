extends Area2D

var velocidade: float = 200.0 
var direcao: int = 1
@export var pontos: int = 20 # Agora você pode mudar esse valor no Inspector!

func _ready():
	# Se a direção for -1 (indo para a esquerda), vira a imagem do peixe
	if direcao == -1:
		$Sprite2D.flip_h = true

	# Cria um Tween infinito
	var tween_nadar = create_tween().set_loops()
	
	# Pega o nó da imagem do peixe (ajuste o nome se o seu for diferente)
	var sprite = $Sprite2D 
	
	# Inclina 15 graus para cima muito rápido (0.2 segundos)
	tween_nadar.tween_property(sprite, "rotation_degrees", 5.0, 0.9)
	# Inclina 15 graus para baixo muito rápido (0.2 segundos)
	tween_nadar.tween_property(sprite, "rotation_degrees", -5.0, 0.9)

func _process(delta: float) -> void:
	# Move o peixe
	position.x += velocidade * direcao * delta
	
	# Autodestruição: se o peixe sair muito da tela, ele é deletado
	# Ajuste esses valores (-200 e 1000) dependendo da largura da sua tela
	if position.x > 1000 or position.x < -200:
		queue_free()
