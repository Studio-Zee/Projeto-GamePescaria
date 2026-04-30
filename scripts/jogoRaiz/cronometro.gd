extends Node2D

@onready var texto_tempo = $Interface/TextoTempo
@onready var timer_jogo = $TimerJogo
@onready var tela_fim_de_jogo = $Interface/TelaFimDeJogo
@onready var spawner_peixes = $SpawnerPeixes

# Referência para a nossa água!
@onready var superficie_mar = $SuperficieMar 
@export var player: Node2D 

func _ready():
	timer_jogo.timeout.connect(_on_tempo_esgotado)
	
	# Só roda a animação se a água existir na cena
	if superficie_mar:
		# === 1. BALANÇO VERTICAL DA ÁGUA (Sobe e desce) ===
		var pos_original = superficie_mar.position
		var tween_balanco_agua = create_tween().set_loops()
		
		# Sobe e desce 4 pixels em 2.5s (O barco faz 3px em 2.0s)
		tween_balanco_agua.tween_property(superficie_mar, "position:y", pos_original.y - 4, 2.5).set_trans(Tween.TRANS_SINE)
		tween_balanco_agua.tween_property(superficie_mar, "position:y", pos_original.y + 4, 2.5).set_trans(Tween.TRANS_SINE)

		# === 2. GANGORRA DA ÁGUA (Inclinação) ===
		var tween_gangorra_agua = create_tween().set_loops()
		
		# Inclina 1.5 graus em 3.0s (O barco faz 2.0 graus em 1.5s)
		tween_gangorra_agua.tween_property(superficie_mar, "rotation_degrees", 1.5, 3.0).set_trans(Tween.TRANS_SINE)
		tween_gangorra_agua.tween_property(superficie_mar, "rotation_degrees", -1.5, 3.0).set_trans(Tween.TRANS_SINE)
	else:
		print("AVISO: Nó 'SuperficieMar' não encontrado.")

func _process(_delta):
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
