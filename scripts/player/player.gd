extends Node2D

@onready var anzol = $Anzol
@onready var linha_pesca = $LinhaPesca

var pescando = false
var pos_inicial_anzol = Vector2.ZERO
var profundidade_maxima = 600.0 
var tempo_descida = 1.0 
var velocidade_anzol = 400.0

func _ready():
	# O anzol nasce no posição do barco
	pos_inicial_anzol = anzol.position

	linha_pesca.clear_points()
	linha_pesca.add_point(Vector2.ZERO)
	linha_pesca.add_point(anzol.position)

func _process(_delta):
	# Atualizando a ponta da linha para seguir o anzol em tempo real
	linha_pesca.set_point_position(1, anzol.position)

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		if not pescando:
			# Pega a posição que clico e manda para o player
			var posicao_alvo = to_local(get_global_mouse_position())
			lancar_anzol(posicao_alvo)

func lancar_anzol(pos_alvo: Vector2):
	pescando = true

	var distancia = pos_inicial_anzol.distance_to(pos_alvo)
	
	# (Tempo = Distância / Velocidade)
	var tempo_movimento = distancia / velocidade_anzol
	
	var tween = create_tween()
	
	# Vai até o ponto clicado
	tween.tween_property(anzol, "position", pos_alvo, tempo_movimento).set_trans(Tween.TRANS_SINE)
	
	# Volta para o barco
	tween.tween_property(anzol, "position", pos_inicial_anzol, tempo_movimento).set_trans(Tween.TRANS_SINE)
		
	tween.tween_callback(func(): pescando = false)

func _on_anzol_area_entered(area: Area2D) -> void:
	if area.is_in_group("peixes"):
		print("Peixe fisgado!")
		area.queue_free()
