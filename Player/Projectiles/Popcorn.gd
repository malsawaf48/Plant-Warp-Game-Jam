extends Sprite




func _on_AudioStreamPlayer_finished():
	queue_free()
