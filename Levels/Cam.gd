extends Camera2D

func _process(delta):
	position.x = get_parent().get_node("Character").position.x


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
