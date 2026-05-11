extends Node2D

@export var label_pontos: Label 

@export var velocidade_anzol: float = 400.0 
@export var velocidade_com_peixe: float = 150.0 

@onready var pescador_sprite = $PescadorSprite
@onready var barco_sprite = $BarcoSprite
@onready var anzol = $Anzol
@onready var linha_pesca = $LinhaPesca

@onready var ponto_vara_direita = $PontoVaraDireita
@onready var ponto_vara_esquerda = $PontoVaraEsquerda

@export var cena_splash: PackedScene

@onready var som_splash = $SomSplash
@onready var som_ponto = $SomPonto

var pescando = false
var pos_inicial_anzol = Vector2.ZERO
var tween_atual: Tween 

var tem_peixe_no_anzol: bool = false

var pontuacao: int = 0 

func _ready():
	pos_inicial_anzol = ponto_vara_direita.position
	anzol.position = pos_inicial_anzol
	
	linha_pesca.clear_points()
	linha_pesca.add_point(pos_inicial_anzol) 
	linha_pesca.add_point(anzol.position)
	
	if label_pontos:
		label_pontos.text = "Pontos: " + str(pontuacao)
	
	var pos_original = position
	var tween_balanco = create_tween().set_loops()
	
	tween_balanco.tween_property(self, "position:y", pos_original.y - 3, 2.0).set_trans(Tween.TRANS_SINE)
	tween_balanco.tween_property(self, "position:y", pos_original.y + 3, 2.0).set_trans(Tween.TRANS_SINE)

	var tween_gangorra = create_tween().set_loops()
	
	tween_gangorra.tween_property(self, "rotation_degrees", 2.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween_gangorra.tween_property(self, "rotation_degrees", -2.0, 1.5).set_trans(Tween.TRANS_SINE)

func _process(_delta):
	linha_pesca.set_point_position(0, pos_inicial_anzol)
	linha_pesca.set_point_position(1, anzol.position)

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		if not pescando:
			var posicao_alvo = to_local(get_global_mouse_position())
			
			if posicao_alvo.y < pos_inicial_anzol.y:
				return

			if posicao_alvo.x < 0:
				virar_personagem(true) 
			else:
				virar_personagem(false) 
				
			lancar_anzol(posicao_alvo)

func lancar_anzol(pos_alvo: Vector2):
	pescando = true
	
	if cena_splash:
		var splash = cena_splash.instantiate()
		
		get_tree().current_scene.add_child(splash) 
		
		splash.global_position = get_global_mouse_position() 
		
		splash.z_index = 100 
		splash.emitting = true
		
		if som_splash:
			som_splash.play()
	
	var distancia = pos_inicial_anzol.distance_to(pos_alvo)

	var tempo_movimento = distancia / velocidade_anzol 
	
	tween_atual = create_tween()
	tween_atual.tween_property(anzol, "position", pos_alvo, tempo_movimento).set_trans(Tween.TRANS_SINE)

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
		
		var tempo_volta = distancia_volta / velocidade_com_peixe 
		
		tween_atual = create_tween()
		tween_atual.tween_property(anzol, "position", pos_inicial_anzol, tempo_volta).set_trans(Tween.TRANS_SINE)
		
		tween_atual.tween_callback(func(): 
			pescando = false
			anzol.set_deferred("monitoring", true) 

			tem_peixe_no_anzol = false
			
			if is_instance_valid(area):
				var pontos_ganhos = 20
				if "pontos" in area:
					pontos_ganhos = area.pontos
				
				pontuacao += pontos_ganhos
				if label_pontos:
					label_pontos.text = "Pontos: " + str(pontuacao)
				
				_mostrar_texto_flutuante(pontos_ganhos)
				
				if som_ponto:
					som_ponto.play()
					
				area.queue_free() 
				
		)

func _grudar_peixe(peixe: Area2D):
	if tem_peixe_no_anzol == true:
		return 
		
	tem_peixe_no_anzol = true 

	if is_instance_valid(peixe):
		peixe.reparent(anzol)
		
		peixe.position = Vector2(0, 20)
	
		peixe.rotation_degrees = 90

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

func virar_personagem(para_esquerda: bool):
	if para_esquerda:
		barco_sprite.flip_h = true
		pescador_sprite.flip_h = true
		pos_inicial_anzol = ponto_vara_esquerda.position
	else:
		barco_sprite.flip_h = false
		pescador_sprite.flip_h = false
		pos_inicial_anzol = ponto_vara_direita.position
	
	anzol.position = pos_inicial_anzol
	linha_pesca.set_point_position(0, pos_inicial_anzol)
	linha_pesca.set_point_position(1, anzol.position)
