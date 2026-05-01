extends Node2D

@onready var texto_tempo = $Interface/TextoTempo
@onready var timer_jogo = $TimerJogo
@onready var tela_fim_de_jogo = $Interface/TelaFimDeJogo
@onready var spawner_peixes = $SpawnerPeixes

# Referências dos textos superiores
@onready var texto_meta: Label = $Interface/TextoMeta
@onready var texto_total: Label = $Interface/TextoTotal

@export var player: Node2D 
var meta_fase: int = 200
var pontos_totais: int = 0

func _ready():
	timer_jogo.timeout.connect(_on_tempo_esgotado)
	
	# Atualiza os textos da tela usando as nossas variáveis!
	if texto_meta: texto_meta.text = "Meta: " + str(meta_fase)
	if texto_total: texto_total.text = "Total: " + str(pontos_totais)

func _process(_delta):
	if not timer_jogo.is_stopped():
		var tempo_restante = int(timer_jogo.time_left)
		texto_tempo.text = "Tempo: " + str(tempo_restante)

func _on_tempo_esgotado():
	texto_tempo.text = "Tempo: 0"
	
	if spawner_peixes:
		spawner_peixes.queue_free() 
	
	if player:
		# === LÓGICA DE METAS ===
		if player.pontuacao >= meta_fase:
			# Chama a função de Vitória lá do script do Painel!
			tela_fim_de_jogo.mostrar_vitoria(player.pontuacao) 
		else:
			# Chama a função de Derrota lá do script do Painel!
			tela_fim_de_jogo.mostrar_derrota(player.pontuacao)
	else:
		print("ERRO: O script não achou o Player!")
