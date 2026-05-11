extends Control

# 1. Criamos um "Sinal" personalizado. Ele serve como um megafone.
signal fechar_tela

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	# 2. Em vez de mudar de cena e cortar seco, nós tocamos no megafone!
	# O Menu vai ouvir isso e fazer a animação de deslizar.
	emit_signal("fechar_tela")
