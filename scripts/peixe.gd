extends Area2D

@export var velocidade = 100.0
@export var pontos = 10
var direcao = 1 

func _process(delta):
	position.x += velocidade * direcao * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
