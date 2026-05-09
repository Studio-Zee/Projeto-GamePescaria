extends CPUParticles2D

func _on_finished() -> void:
	queue_free() # Destrói a partícula quando a animação acabar!
