extends Node2D

# Sinais para se comunicar com o GameManager (você conectará isso depois)
signal peixe_capturado(pontos)

# Estados da máquina de estados
enum Estado { MIRANDO, DISPARANDO, RETORNANDO }
var estado_atual = Estado.MIRANDO

# Referências aos nós filhos (baseado na sua imagem)
@onready var linha: Line2D = $Linha
@onready var ponta_gancho: Area2D = $PontaGancho

@export_group("Configurações do Gancho")
@export var velocidade_rotacao: float = 1.5 
@export var angulo_maximo_graus: float = 60.0 
@export var velocidade_disparo: float = 600.0 
@export var velocidade_retorno_vazio: float = 400.0
@export var velocidade_retorno_com_peixe: float = 200.0
@export var alcance_maximo: float = 800.0 

# Variáveis internas
var direcao_rotacao: int = 1
var objeto_preso: Node2D = null

func _ready():
	linha.points = [Vector2.ZERO, Vector2.ZERO]
	
	ponta_gancho.position = Vector2.ZERO

	if not ponta_gancho.area_entered.is_connected(_on_ponta_gancho_area_entered):
		ponta_gancho.area_entered.connect(_on_ponta_gancho_area_entered)

func _physics_process(delta):
	match estado_atual:
		Estado.MIRANDO:
			processar_mira(delta)
			if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				estado_atual = Estado.DISPARANDO

		Estado.DISPARANDO:
			processar_disparo(delta)

		Estado.RETORNANDO:
			processar_retorno(delta)

	linha.points[1] = ponta_gancho.position
	
func processar_mira(delta):
	rotation += velocidade_rotacao * direcao_rotacao * delta
	
	var angulo_atual_graus = rad_to_deg(rotation)

	if angulo_atual_graus > angulo_maximo_graus:
		rotation = deg_to_rad(angulo_maximo_graus)
		direcao_rotacao = -1
	elif angulo_atual_graus < -angulo_maximo_graus:
		rotation = deg_to_rad(-angulo_maximo_graus)
		direcao_rotacao = 1
		
	ponta_gancho.position = Vector2.ZERO

func processar_disparo(delta):
	ponta_gancho.position.y += velocidade_disparo * delta
	
	if ponta_gancho.position.y >= alcance_maximo:
		estado_atual = Estado.RETORNANDO

func processar_retorno(delta):
	var velocidade_atual = velocidade_retorno_vazio
	if objeto_preso != null:
		velocidade_atual = velocidade_retorno_com_peixe
		
	ponta_gancho.position.y -= velocidade_atual * delta
	
	if ponta_gancho.position.y <= 0:
		ponta_gancho.position = Vector2.ZERO
		finalizar_captura()
		estado_atual = Estado.MIRANDO

func finalizar_captura():
	if objeto_preso:
		var valor_peixe = objeto_preso.get("pontos") if "pontos" in objeto_preso else 10
	
		peixe_capturado.emit(valor_peixe)
		print("Peixe entregue! Pontos: ", valor_peixe)
		
		objeto_preso.queue_free()
		objeto_preso = null

func _on_ponta_gancho_area_entered(area):
	if estado_atual == Estado.DISPARANDO and area.is_in_group("peixes"):
		print("Atingiu peixe: ", area.name)
		estado_atual = Estado.RETORNANDO
		objeto_preso = area

		area.get_parent().remove_child(area)
		ponta_gancho.add_child(area)
		
		area.position = Vector2(0, 20) 
		area.rotation = 0
		
		area.set_deferred("monitorable", false)
		area.set_deferred("monitoring", false)
