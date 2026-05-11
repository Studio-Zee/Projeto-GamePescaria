extends Control

@onready var texto_titulo = $TextoTitulo 
@onready var texto_pontuacao = $TextoPontuacaoFinal 
@onready var botao_jogar = $BotaoJogar

func _ready():
	hide()
	botao_jogar.pressed.connect(_on_botao_jogar_pressed)

func mostrar_vitoria(pontos_finais: int):
	texto_titulo.text = "VITÓRIA!"
	texto_titulo.add_theme_color_override("font_color", Color.GREEN) 
	texto_pontuacao.text = "Pontos: " + str(pontos_finais)
	botao_jogar.text = "Próxima Fase" 
	show()

func mostrar_derrota(pontos_finais: int):
	texto_titulo.text = "FIM DE JOGO"
	texto_titulo.add_theme_color_override("font_color", Color.RED) 
	texto_pontuacao.text = "Pontos: " + str(pontos_finais)
	botao_jogar.text = "Tentar Novamente" 
	show()

func _on_botao_jogar_pressed():

	get_tree().reload_current_scene()
