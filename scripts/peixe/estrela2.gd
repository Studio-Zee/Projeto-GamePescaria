extends Sprite2D

func _ready():
	var rotacao_original = rotation_degrees
	
	var tween_estrela = create_tween().set_loops()
	

	tween_estrela.tween_property(self, "rotation_degrees", rotacao_original - 7.0, 3.0).set_trans(Tween.TRANS_SINE)
	
	tween_estrela.tween_property(self, "rotation_degrees", rotacao_original + 6.0, 4.0).set_trans(Tween.TRANS_SINE)
