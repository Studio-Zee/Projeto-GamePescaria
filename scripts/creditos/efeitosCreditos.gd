extends Label


func _on_rich_text_label_meta_clicked(meta):
	OS.shell_open(str(meta))

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		OS.shell_open("https://gist.github.com/welson-rodrigues/43499b235e34f62d840185224153a626")
