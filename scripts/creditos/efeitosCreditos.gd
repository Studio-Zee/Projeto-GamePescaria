extends Label


func _on_rich_text_label_meta_clicked(meta):
	# Isso abre o navegador do celular no link clicado
	OS.shell_open(str(meta))

func _on_gui_input(event: InputEvent) -> void:
	# Verifica se foi um clique do mouse ou um toque na tela
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		
		# Pega o link do seu Gist e manda o celular abrir o navegador
		OS.shell_open("https://gist.github.com/welson-rodrigues/43499b235e34f62d840185224153a626")
