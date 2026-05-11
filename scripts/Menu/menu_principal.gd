extends Control

# Vai criar um campo no Inspector para você arrastar a cena do jogo
@export var cena_do_jogo: PackedScene 

@onready var botao_play = $BotaoJogar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# 1. === NOVA VARIÁVEL AQUI ===
# Precisamos salvar a cena dos créditos numa variável que o script inteiro consiga ver,
# para podermos apagá-ela depois na hora de fechar.
var cena_creditos_instancia: Node = null

func _ready():
	# Conecta o clique do botão
	botao_play.pressed.connect(_on_botao_play_pressed)

func _on_botao_play_pressed():
	if not cena_do_jogo:
		print("Você esqueceu de arrastar a cena do jogo no Inspector do Menu!")
		return
		
	# 1. Desliga o botão para o jogador não clicar duas vezes sem querer
	botao_play.disabled = true
	
	# 2. Cria o jogo na memória
	var jogo = cena_do_jogo.instantiate()
	
	# 3. Descobre a largura exata da tela do celular
	var largura_tela = get_viewport_rect().size.x
	
	# 4. Coloca o jogo escondido lá na esquerda (posição X negativa)
	jogo.position = Vector2(-largura_tela, 0)
	
	# 5. Adiciona o jogo na raiz do projeto (para ele existir de verdade)
	get_tree().root.add_child(jogo)
	
	# 6. FAZ A MÁGICA DA GAVETA
	var tween = create_tween()
	
	# O jogo vem da esquerda (-largura) para o centro (0)
	tween.tween_property(jogo, "position", Vector2.ZERO, 0.6).set_trans(Tween.TRANS_CUBIC)
	
	# Ao mesmo tempo (parallel), o menu vai do centro (0) para a direita (+largura)
	tween.parallel().tween_property(self, "position", Vector2(largura_tela, 0), 0.6).set_trans(Tween.TRANS_CUBIC)
	
	# 7. Quando a animação terminar, arrumamos a casa!
	tween.tween_callback(func():
		# Avisa a Godot que o jogo é a cena oficial agora 
		# (Isso é obrigatório para aquele botão de "Jogar Novamente" do Game Over funcionar depois!)
		get_tree().current_scene = jogo
		
		# Deleta o menu para liberar memória
		self.queue_free()
	)

func _on_botao_creditos_pressed() -> void:
	# 2. === ATUALIZADO: Guardamos a cena na nossa variável nova ===
	cena_creditos_instancia = preload("res://cenas/creditos/creditos.tscn").instantiate()
	var largura = get_viewport_rect().size.x
	
	# Começa escondida na direita
	cena_creditos_instancia.position = Vector2(largura, 0)
	get_tree().root.add_child(cena_creditos_instancia)
	
	# === NOVA LINHA AQUI ===
	# O Menu fica "escutando" o grito da tela de créditos pedindo para fechar!
	cena_creditos_instancia.fechar_tela.connect(_fechar_creditos)
	
	var tween = create_tween()
	# Menu foge para a esquerda
	tween.tween_property(self, "position", Vector2(-largura, 0), 0.5).set_trans(Tween.TRANS_CUBIC)
	# Créditos entram vindo da direita
	tween.parallel().tween_property(cena_creditos_instancia, "position", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_CUBIC)

# 3. === NOVA FUNÇÃO AQUI ===
# Esta é a animação de gaveta voltando ao normal!
func _fechar_creditos():
	var largura = get_viewport_rect().size.x
	var tween = create_tween()
	
	# O Menu volta para o centro da tela (0)
	tween.tween_property(self, "position", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_CUBIC)
	
	# Os Créditos fogem de volta para a direita
	tween.parallel().tween_property(cena_creditos_instancia, "position", Vector2(largura, 0), 0.5).set_trans(Tween.TRANS_CUBIC)
	
	# Quando terminar de deslizar, joga a cena de créditos no lixo para limpar a memória
	tween.tween_callback(func():
		cena_creditos_instancia.queue_free()
	)
