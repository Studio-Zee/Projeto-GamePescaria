extends Node2D

@onready var texto_tempo = $Interface/TextoTempo
@onready var timer_jogo = $TimerJogo

func _process(_delta):
	# Atualiza o texto na tela pegando o tempo que falta no Timer
	if not timer_jogo.is_stopped():
		var tempo_restante = int(timer_jogo.time_left)
		texto_tempo.text = "Tempo: " + str(tempo_restante)
	else:
		texto_tempo.text = "Tempo: 0"

func _ready():
	# Quando o tempo acabar, chama a função de Game Over
	timer_jogo.timeout.connect(_on_tempo_esgotado)

func _on_tempo_esgotado():
	print("Fim de Jogo!")
	# Aqui você pode parar o Spawner ou mostrar uma tela de pontuação final
	$SpawnerPeixes.queue_free() # Destrói o spawner para parar de vir peixes
