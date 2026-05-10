extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _on_continuar_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_sair_pressed() -> void:
	get_tree().quit()
	visible = false

func _on_botao_pausar_pressed() -> void:
	visible = true
	get_tree().paused = true 
