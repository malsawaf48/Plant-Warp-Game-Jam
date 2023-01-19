extends Control

var Selected = 1

func _process(_delta):
	if Input.is_action_just_pressed("DOWN"):
		Selected += 1
		$Select.play()
	elif Input.is_action_just_pressed("UP"):
		Selected -= 1
		$Select.play()
	
	if Selected == 1:
		$VBoxContainer/Play.text = "~PLAY"
		if Input.is_action_just_pressed("A") or Input.is_action_just_pressed("START"):
			get_tree().change_scene("res://Levels/Levels/Level1.tscn")
	else:
		Selected = 1
