extends Node2D

@onready var texto_tempo = $Interface/TextoTempo
@onready var timer_jogo = $TimerJogo
@onready var tela_fim_de_jogo = $Interface/TelaFimDeJogo
@onready var spawner_peixes = $SpawnerPeixes

@onready var texto_meta: Label = $Interface/TextoMeta
@onready var texto_total: Label = $Interface/TextoTotal

@export var player: Node2D

# APAGAMOS AS VARIÁVEIS ANTIGAS DAQUI! Vamos usar o Global.

func _ready():
	timer_jogo.timeout.connect(_on_tempo_esgotado)
	
	timer_jogo.wait_time = Global.tempo_fase
	timer_jogo.start()
	
	# Puxa os valores direto do nosso script Global "fantasma"!
	if texto_meta: texto_meta.text = "Meta: " + str(Global.meta_atual)
	if texto_total: texto_total.text = "Total: " + str(Global.pontos_totais)

func _process(_delta):
	if not timer_jogo.is_stopped():
		var tempo_restante = int(timer_jogo.time_left)
		texto_tempo.text = "Tempo: " + str(tempo_restante)

func _on_tempo_esgotado():
	texto_tempo.text = "Tempo: 0"
	
	if spawner_peixes:
		spawner_peixes.queue_free()
	
	if player:
		# Verifica se a pontuação atingiu a meta GLOBAL
		if player.pontuacao >= Global.meta_atual:
			# === VITÓRIA: GUARDA OS PONTOS E AUMENTA A DIFICULDADE! ===
			Global.pontos_totais += player.pontuacao
			Global.meta_atual += 100 # Pula de 100 em 100 agora!
			
			Global.adicional_velocidade += 40.0
			
			# === NOVO: Tira 5 segundos do tempo, mas não deixa ficar menor que 20s ===
			if Global.tempo_fase > 20:
				Global.tempo_fase -= 5
			
			tela_fim_de_jogo.mostrar_vitoria(player.pontuacao)
			
		else:
			# === DERROTA: ZERA TUDO PARA O NOVO JOGO ===
			Global.pontos_totais = 0
			Global.meta_atual = 200
			Global.adicional_velocidade = 0.0 
			Global.tempo_fase = 60 # Volta o tempo para 1 minuto!
			
			tela_fim_de_jogo.mostrar_derrota(player.pontuacao)
