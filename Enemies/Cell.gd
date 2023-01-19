extends KinematicBody2D

var motion = Vector2()
var up = Vector2(0,-1)
var acceleration = 7
var max_speed = 17
var dir = 2
var health = 2
onready var balloon = preload("res://Enemies/Balloon.tscn")
var pop = preload("res://Audio/Pop.tscn")

func _ready():
	$AnimationPlayer.play("float")

func _physics_process(delta):
	if dir == 2:
		motion.x = min(motion.x + acceleration, max_speed)
	elif dir == 1:
		motion.x = max(motion.x - acceleration, -max_speed)
	motion.y += 0.4
	motion = move_and_slide(motion, up)


func _on_left_body_exited(body):
	dir = 2


func _on_right_body_exited(body):
	dir = 1


func _on_hitbox_area_entered(area):
	if health != 1:
		health -= 1
		$AudioStreamPlayer.play()
		$AnimationPlayer2.play("Flash")
	else:
		var popins = pop.instance()
		get_parent().add_child(popins)
		queue_free()
