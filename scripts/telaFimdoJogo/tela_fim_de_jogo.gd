extends Control

@onready var texto_pontuacao = $TextoPontuacaoFinal
@onready var botao_jogar = $BotaoJogar

func _ready():
	# Esconde essa tela inteira assim que o jogo começa
	hide()
	
	# Conecta o clique do botão para reiniciar a cena
	botao_jogar.pressed.connect(_on_botao_jogar_pressed)

func mostrar_tela(pontos_finais: int):
	# Atualiza o texto com a pontuação que o jogador fez e mostra a tela
	texto_pontuacao.text = "Sua Pontuação: " + str(pontos_finais)
	show()

func _on_botao_jogar_pressed():
	# Reinicia a fase atual do zero!
	get_tree().reload_current_scene()
