extends Control

@export var cena_do_jogo: PackedScene 

@onready var botao_play = $BotaoJogar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var cena_creditos_instancia: Node = null

func _ready():
	# Conecta o clique do botão
	botao_play.pressed.connect(_on_botao_play_pressed)

func _on_botao_play_pressed():
	if not cena_do_jogo:
		return
		
	botao_play.disabled = true
	
	var jogo = cena_do_jogo.instantiate()
	
	var largura_tela = get_viewport_rect().size.x
	
	jogo.position = Vector2(-largura_tela, 0)
	
	get_tree().root.add_child(jogo)
	
	var tween = create_tween()
	
	tween.tween_property(jogo, "position", Vector2.ZERO, 0.6).set_trans(Tween.TRANS_CUBIC)
	
	tween.parallel().tween_property(self, "position", Vector2(largura_tela, 0), 0.6).set_trans(Tween.TRANS_CUBIC)

	tween.tween_callback(func():
		get_tree().current_scene = jogo
		
		self.queue_free()
	)

func _on_botao_creditos_pressed() -> void:
	cena_creditos_instancia = preload("res://cenas/creditos/creditos.tscn").instantiate()
	var largura = get_viewport_rect().size.x
	
	cena_creditos_instancia.position = Vector2(largura, 0)
	get_tree().root.add_child(cena_creditos_instancia)
	
	cena_creditos_instancia.fechar_tela.connect(_fechar_creditos)
	
	var tween = create_tween()

	tween.tween_property(self, "position", Vector2(-largura, 0), 0.5).set_trans(Tween.TRANS_CUBIC)

	tween.parallel().tween_property(cena_creditos_instancia, "position", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_CUBIC)

func _fechar_creditos():
	var largura = get_viewport_rect().size.x
	var tween = create_tween()
	
	tween.tween_property(self, "position", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_CUBIC)
	
	tween.parallel().tween_property(cena_creditos_instancia, "position", Vector2(largura, 0), 0.5).set_trans(Tween.TRANS_CUBIC)

	tween.tween_callback(func():
		cena_creditos_instancia.queue_free()
	)
