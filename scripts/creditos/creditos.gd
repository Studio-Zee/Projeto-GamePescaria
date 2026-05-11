extends Control

signal fechar_tela

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	emit_signal("fechar_tela")
