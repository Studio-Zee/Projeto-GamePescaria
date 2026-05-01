extends Node2D

@onready var texto_tempo = $Interface/TextoTempo
@onready var timer_jogo = $TimerJogo
@onready var tela_fim_de_jogo = $Interface/TelaFimDeJogo
@onready var spawner_peixes = $SpawnerPeixes

# Mantemos a referência caso você queira fazer algo com a água no futuro
@onready var superficie_mar = $SuperficieMar 
@export var player: Node2D 

func _ready():
	# Conecta o timer para acabar o jogo
	timer_jogo.timeout.connect(_on_tempo_esgotado)
	
	# (O código de balanço da água foi totalmente removido daqui!)

func _process(_delta):
	# Atualiza o cronômetro na tela
	if not timer_jogo.is_stopped():
		var tempo_restante = int(timer_jogo.time_left)
		texto_tempo.text = "Tempo: " + str(tempo_restante)

func _on_tempo_esgotado():
	texto_tempo.text = "Tempo: 0"
	
	if spawner_peixes:
		spawner_peixes.queue_free() 
	
	if player:
		tela_fim_de_jogo.mostrar_tela(player.pontuacao)
	else:
		print("ERRO: O script não achou o Player! Arraste ele no Inspector.")
