extends Node2D

@export var label_pontos: Label 

# NOVO: Exportamos as velocidades para você ajustar direto no Inspector!
@export var velocidade_anzol: float = 400.0 # Velocidade normal (descendo ou voltando vazio)
@export var velocidade_com_peixe: float = 150.0 # Velocidade mais lenta puxando o peixe

@onready var anzol = $Anzol
@onready var linha_pesca = $LinhaPesca

var pescando = false
var pos_inicial_anzol = Vector2.ZERO
var tween_atual: Tween 

var pontuacao: int = 0 

func _ready():
	pos_inicial_anzol = anzol.position
	
	linha_pesca.clear_points()
	linha_pesca.add_point(Vector2.ZERO)
	linha_pesca.add_point(anzol.position)
	
	if label_pontos:
		label_pontos.text = "Pontos: " + str(pontuacao)

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
	# Usa a velocidade normal para descer
	var tempo_movimento = distancia / velocidade_anzol 
	
	tween_atual = create_tween()
	tween_atual.tween_property(anzol, "position", pos_alvo, tempo_movimento).set_trans(Tween.TRANS_SINE)
	# Usa a velocidade normal para subir se não pegar nada
	tween_atual.tween_property(anzol, "position", pos_inicial_anzol, tempo_movimento).set_trans(Tween.TRANS_SINE)
	tween_atual.tween_callback(func(): pescando = false)

func _on_anzol_area_entered(area: Area2D) -> void:
	if area.is_in_group("peixes"):
		anzol.set_deferred("monitoring", false)
		
		area.set_process(false)
		area.set_deferred("monitoring", false)
		area.set_deferred("monitorable", false)
		
		call_deferred("_grudar_peixe", area)
		
		if tween_atual and tween_atual.is_running():
			tween_atual.kill()
		
		var distancia_volta = anzol.position.distance_to(pos_inicial_anzol)
		
		# NOVO: Aqui está o segredo! Usamos a velocidade lenta para calcular a volta
		var tempo_volta = distancia_volta / velocidade_com_peixe 
		
		tween_atual = create_tween()
		tween_atual.tween_property(anzol, "position", pos_inicial_anzol, tempo_volta).set_trans(Tween.TRANS_SINE)
		
		tween_atual.tween_callback(func(): 
			pescando = false
			anzol.set_deferred("monitoring", true) 
			
			if is_instance_valid(area):
				var pontos_ganhos = 20
				if "pontos" in area:
					pontos_ganhos = area.pontos
				
				pontuacao += pontos_ganhos
				if label_pontos:
					label_pontos.text = "Pontos: " + str(pontuacao)
				
				_mostrar_texto_flutuante(pontos_ganhos)
				area.queue_free() 
		)

func _grudar_peixe(peixe: Area2D):
	if is_instance_valid(peixe):
		peixe.reparent(anzol)
		peixe.position = Vector2(0, 20)

func _mostrar_texto_flutuante(valor: int):
	var texto = Label.new()
	texto.text = str(valor)
	texto.add_theme_font_size_override("font_size", 40)
	texto.add_theme_color_override("font_color", Color(1, 0, 0)) 
	
	texto.position = $BarcoSprite.position + Vector2(30, -10)
	add_child(texto)
	
	var tween = create_tween()
	tween.tween_property(texto, "position", texto.position + Vector2(0, -50), 0.6)
	tween.parallel().tween_property(texto, "modulate:a", 0.0, 0.6)
	tween.tween_callback(texto.queue_free)
