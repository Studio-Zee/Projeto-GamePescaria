extends Area2D

var velocidade: float = 200.0
var direcao: int = 1
@export var pontos: int = 20 

func _ready():
	velocidade += Global.adicional_velocidade
	
	if direcao == -1:
		$Sprite2D.flip_h = true

	var tween_nadar = create_tween().set_loops()
	
	var sprite = $Sprite2D
	
	tween_nadar.tween_property(sprite, "rotation_degrees", 5.0, 0.9)
	
	tween_nadar.tween_property(sprite, "rotation_degrees", -5.0, 0.9)

func _process(delta: float) -> void:
	position.x += velocidade * direcao * delta
	if position.x > 1000 or position.x < -200:
		queue_free()
