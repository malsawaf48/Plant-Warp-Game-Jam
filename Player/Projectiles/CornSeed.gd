extends Area2D

var right = true
var popcorn = preload("res://Player/Projectiles/Popcorn.tscn")
func _process(_delta):
	if right == true:
		position.x += 0.9
	else:
		position.x -= 0.9
		$Sprite.flip_h = true

func _on_Spike_body_entered(body):
	var popins = popcorn.instance()
	get_parent().add_child(popins)
	popins.position = self.global_position
	queue_free()


func _on_Timer_timeout():
	queue_free()
