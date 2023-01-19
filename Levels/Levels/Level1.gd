extends Node2D



func _on_Finish_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	get_tree().change_scene("res://Levels/Levels/Level2.tscn")


func _on_Character_Death():
	get_tree().reload_current_scene()
