extends Node2D

signal peixe_pego(valor)

enum Estado { MIRANDO, DISPARANDO, RETORNANDO }
var estado = Estado.MIRANDO

@onready var garra = $Garra
@onready var corda = $Corda
@onready var origem = $PontoDeOrigem

var velocidade_rotacao = 1.5
var angulo_maximo = 70.0 
var velocidade_disparo = 600.0
var velocidade_retorno = 400.0
var alcance_maximo = 1000.0

var direcao_rotacao = 1 
var alvo_atual = null 

func _ready():
	corda.points = [Vector2.ZERO, Vector2.ZERO]

func _physics_process(delta):
	atualizar_corda()
	
	match estado:
		Estado.MIRANDO:
			processar_mira(delta)
			if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				estado = Estado.DISPARANDO
		
		Estado.DISPARANDO:
			processar_disparo(delta)
			
		Estado.RETORNANDO:
			processar_retorno(delta)

func processar_mira(delta):
	rotation += velocidade_rotacao * direcao_rotacao * delta
	
	if rotation_degrees > angulo_maximo:
		direcao_rotacao = -1
	elif rotation_degrees < -angulo_maximo:
		direcao_rotacao = 1
		
	garra.position = Vector2(0, 50)

func processar_disparo(delta):
	garra.position.y += velocidade_disparo * delta
	
	if garra.position.y >= alcance_maximo:
		estado = Estado.RETORNANDO

func processar_retorno(delta):
	var vel_atual = velocidade_retorno
	if alvo_atual:
		vel_atual *= 0.5
	
	garra.position.y -= vel_atual * delta
	
	if garra.position.y <= 50:
		garra.position.y = 50
		finalizar_pesca()
		estado = Estado.MIRANDO

func atualizar_corda():
	corda.points[0] = Vector2.ZERO
	corda.points[1] = garra.position

func finalizar_pesca():
	if alvo_atual:
		emit_signal("peixe_pego", alvo_atual.pontos)
		alvo_atual.queue_free()
		alvo_atual = null

func _on_garra_area_entered(area):
	if estado == Estado.DISPARANDO and area.is_in_group("peixes"):
		estado = Estado.RETORNANDO
		alvo_atual = area
	
		area.reparent(garra)
		area.position = Vector2.ZERO 
		area.rotation = 0 

		area.set_deferred("monitorable", false)
		area.set_deferred("monitoring", false)
