extends Area2D

var right = true

func _process(delta):
	if right == true:
		position.x += 0.6
	else:
		position.x -= 0.6
		$Sprite.flip_h = true

func _on_Spike_body_entered(body):
	queue_free()


func _on_Timer_timeout():
	queue_free()
