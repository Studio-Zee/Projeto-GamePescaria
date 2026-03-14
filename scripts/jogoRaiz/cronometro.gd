extends Node2D

@onready var texto_tempo = $Interface/TextoTempo
@onready var timer_jogo = $TimerJogo
@onready var tela_fim_de_jogo = $Interface/TelaFimDeJogo
@onready var spawner_peixes = $SpawnerPeixes

# NOVO: Trocamos o @onready por @export. 
# Agora vai aparecer um campo no Inspector para você arrastar o Player!
@export var player: Node2D 

func _ready():
	timer_jogo.timeout.connect(_on_tempo_esgotado)

func _process(_delta):
	if not timer_jogo.is_stopped():
		var tempo_restante = int(timer_jogo.time_left)
		texto_tempo.text = "Tempo: " + str(tempo_restante)

func _on_tempo_esgotado():
	texto_tempo.text = "Tempo: 0"
	
	if spawner_peixes:
		spawner_peixes.queue_free() 
	
	# Verificação de segurança: checa se você conectou o Player antes de tentar ler a pontuação
	if player:
		tela_fim_de_jogo.mostrar_tela(player.pontuacao)
	else:
		print("ERRO: O script não achou o Player! Arraste ele no Inspector.")
