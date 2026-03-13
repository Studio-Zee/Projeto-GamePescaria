extends Node2D

@onready var anzol = $Anzol
@onready var linha_pesca = $LinhaPesca

var pescando = false
var pos_inicial_anzol = Vector2.ZERO
var velocidade_anzol = 400.0

# NOVO: Variável para guardar o movimento atual e podermos cancelá-lo
var tween_atual: Tween 

func _ready():
	pos_inicial_anzol = anzol.position

	linha_pesca.clear_points()
	linha_pesca.add_point(Vector2.ZERO)
	linha_pesca.add_point(anzol.position)

func _process(_delta):
	linha_pesca.set_point_position(1, anzol.position)

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		if not pescando:
			var posicao_alvo = to_local(get_global_mouse_position())
			lancar_anzol(posicao_alvo)

func lancar_anzol(pos_alvo: Vector2):
	pescando = true

	var distancia = pos_inicial_anzol.distance_to(pos_alvo)
	var tempo_movimento = distancia / velocidade_anzol
	
	# NOVO: Usamos a variável global em vez de criar uma local ("var tween = ...")
	tween_atual = create_tween()
	
	tween_atual.tween_property(anzol, "position", pos_alvo, tempo_movimento).set_trans(Tween.TRANS_SINE)
	tween_atual.tween_property(anzol, "position", pos_inicial_anzol, tempo_movimento).set_trans(Tween.TRANS_SINE)
		
	tween_atual.tween_callback(func(): pescando = false)

func _on_anzol_area_entered(area: Area2D) -> void:
	if area.is_in_group("peixes"):
		print("Peixe fisgado!")
		
		# Desliga a colisão do anzol temporariamente (já seguro com set_deferred)
		anzol.set_deferred("monitoring", false)
		
		# Para a movimentação do peixe e desliga a colisão dele
		area.set_process(false)
		area.set_deferred("monitoring", false)
		area.set_deferred("monitorable", false)
		
		# CHAMA A FUNÇÃO DE GRUDAR DE FORMA SEGURA (DEFERRED)
		call_deferred("_grudar_peixe", area)
		
		# Cancela o movimento de descida
		if tween_atual and tween_atual.is_running():
			tween_atual.kill()
		
		var distancia_volta = anzol.position.distance_to(pos_inicial_anzol)
		var tempo_volta = distancia_volta / velocidade_anzol
		
		tween_atual = create_tween()
		tween_atual.tween_property(anzol, "position", pos_inicial_anzol, tempo_volta).set_trans(Tween.TRANS_SINE)
		
		tween_atual.tween_callback(func(): 
			pescando = false
			anzol.set_deferred("monitoring", true) 
			
			if is_instance_valid(area):
				area.queue_free()
		)

# Nova função dedicada apenas a trocar o peixe de pai com segurança
func _grudar_peixe(peixe: Area2D):
	if is_instance_valid(peixe):
		peixe.reparent(anzol)
		peixe.position = Vector2(0, 20) # Posiciona o peixe um pouco abaixo do anzol
