extends Node2D

@export var label_pontos: Label 

# Exportamos as velocidades para você ajustar direto no Inspector!
@export var velocidade_anzol: float = 400.0 # Velocidade normal (descendo ou voltando vazio)
@export var velocidade_com_peixe: float = 150.0 # Velocidade mais lenta puxando o peixe

@onready var pescador_sprite = $PescadorSprite
@onready var barco_sprite = $BarcoSprite
@onready var anzol = $Anzol
@onready var linha_pesca = $LinhaPesca

# Referências para os marcadores que você criou no editor
@onready var ponto_vara_direita = $PontoVaraDireita
@onready var ponto_vara_esquerda = $PontoVaraEsquerda

var pescando = false
var pos_inicial_anzol = Vector2.ZERO
var tween_atual: Tween 

var tem_peixe_no_anzol: bool = false

var pontuacao: int = 0 

func _ready():
	# Define a posição inicial usando o marcador da direita como padrão
	pos_inicial_anzol = ponto_vara_direita.position
	anzol.position = pos_inicial_anzol
	
	linha_pesca.clear_points()
	linha_pesca.add_point(pos_inicial_anzol) 
	linha_pesca.add_point(anzol.position)
	
	if label_pontos:
		label_pontos.text = "Pontos: " + str(pontuacao)
	
	# === 1. ANIMAÇÃO DE BALANÇO VERTICAL (Bobbing) ===
	var pos_original = position
	var tween_balanco = create_tween().set_loops()
	
	# Sobe e desce 3 pixels suavemente
	tween_balanco.tween_property(self, "position:y", pos_original.y - 3, 2.0).set_trans(Tween.TRANS_SINE)
	tween_balanco.tween_property(self, "position:y", pos_original.y + 3, 2.0).set_trans(Tween.TRANS_SINE)

	# === 2. NOVA ANIMAÇÃO DE GANGORRA HORIZONTAL (Rocking) ===
	var tween_gangorra = create_tween().set_loops()
	
	# Inclina 2 graus para frente e para trás
	tween_gangorra.tween_property(self, "rotation_degrees", 2.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween_gangorra.tween_property(self, "rotation_degrees", -2.0, 1.5).set_trans(Tween.TRANS_SINE)

func _process(_delta):
	# Garante que a base da linha sempre siga a variável correta (direita ou esquerda)
	linha_pesca.set_point_position(0, pos_inicial_anzol)
	linha_pesca.set_point_position(1, anzol.position)

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		if not pescando:
			var posicao_alvo = to_local(get_global_mouse_position())
			
			# === NOVA TRAVA DO CÉU (Bloqueio Total) ===
			# Se o clique (alvo.y) for mais alto que a ponta da vara...
			if posicao_alvo.y < pos_inicial_anzol.y:
				return # ... ABORTA A MISSÃO! Ele sai da função aqui e não faz nada.
			
			# Se passou da trava acima, é porque o clique foi na água!
			# Verifica de qual lado foi o clique
			if posicao_alvo.x < 0:
				virar_personagem(true)  # Clicou nas costas, vira pra esquerda
			else:
				virar_personagem(false) # Clicou na frente, vira pra direita
				
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
		
		# Usamos a velocidade lenta para calcular a volta
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
				area.queue_free() 
				
		)

func _grudar_peixe(peixe: Area2D):

	# === TRAVA DE SEGURANÇA ===
	if tem_peixe_no_anzol == true:
		return # Se já tem peixe, aborta a missão e ignora esse segundo peixe!
		
	tem_peixe_no_anzol = true # Agora o anzol está ocupado!

	if is_instance_valid(peixe):
		peixe.reparent(anzol)
		
		# Ajusta a posição do peixe para ficar pendurado um pouco abaixo do anzol
		peixe.position = Vector2(0, 20)
		
		# === NOVO: GIRA O PEIXE PARA CIMA ===
		# Colocamos -90 graus para a cabeça dele apontar para a linha!
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
		# Espelha as imagens para a esquerda
		barco_sprite.flip_h = true
		pescador_sprite.flip_h = true
		# Define a posição inicial usando o marcador da esquerda
		pos_inicial_anzol = ponto_vara_esquerda.position
	else:
		# Volta as imagens ao normal (olhando para a direita)
		barco_sprite.flip_h = false
		pescador_sprite.flip_h = false
		# Define a posição inicial usando o marcador da direita
		pos_inicial_anzol = ponto_vara_direita.position
	
	# Atualiza o anzol e a base da linha instantaneamente para o novo lado
	anzol.position = pos_inicial_anzol
	linha_pesca.set_point_position(0, pos_inicial_anzol)
	linha_pesca.set_point_position(1, anzol.position)
