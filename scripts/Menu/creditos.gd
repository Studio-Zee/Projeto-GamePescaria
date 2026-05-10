extends TextureButton

func _ready():
	var pos_y_original = position.y
	var tween = create_tween().set_loops()
	
	# Faz a garrafa subir e descer 3 pixels bem devagar
	tween.tween_property(self, "position:y", pos_y_original - 3, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", pos_y_original + 3, 1.5).set_trans(Tween.TRANS_SINE)
