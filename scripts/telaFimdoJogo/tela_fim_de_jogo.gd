extends Control

# Verifique se os nomes dos nós estão certinhos com a sua cena!
@onready var texto_titulo = $TextoTitulo # O Label que diz "FIM DO JOGO"
@onready var texto_pontuacao = $TextoPontuacaoFinal # O Label que diz "Pontos: 0"
@onready var botao_jogar = $BotaoJogar

func _ready():
	hide() # Esconde quando o jogo começa
	botao_jogar.pressed.connect(_on_botao_jogar_pressed)

# Criamos uma função específica para quando GANHA
func mostrar_vitoria(pontos_finais: int):
	texto_titulo.text = "VITÓRIA!"
	texto_titulo.add_theme_color_override("font_color", Color.GREEN) # Fica verdinho
	texto_pontuacao.text = "Pontos: " + str(pontos_finais)
	botao_jogar.text = "Próxima Fase" # Muda o texto do botão!
	show()

# Criamos uma função específica para quando PERDE
func mostrar_derrota(pontos_finais: int):
	texto_titulo.text = "FIM DE JOGO"
	texto_titulo.add_theme_color_override("font_color", Color.RED) # Fica vermelho
	texto_pontuacao.text = "Pontos: " + str(pontos_finais)
	botao_jogar.text = "Tentar Novamente" # Muda o texto do botão!
	show()

func _on_botao_jogar_pressed():
	# Reinicia a fase atual do zero!
	get_tree().reload_current_scene()
