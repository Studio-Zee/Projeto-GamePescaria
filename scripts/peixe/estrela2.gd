extends Sprite2D

func _ready():
	# Guarda a rotação original caso você tenha deixado ela tortinha no editor de propósito
	var rotacao_original = rotation_degrees
	
	var tween_estrela = create_tween().set_loops()
	
	# Vai 5 graus para um lado bem devagar (2 segundos)
	tween_estrela.tween_property(self, "rotation_degrees", rotacao_original - 7.0, 3.0).set_trans(Tween.TRANS_SINE)
	
	# Volta 5 graus para o outro lado bem devagar (2 segundos)
	tween_estrela.tween_property(self, "rotation_degrees", rotacao_original + 6.0, 4.0).set_trans(Tween.TRANS_SINE)
