extends KinematicBody2D

var up = Vector2(0,-1)
export var gravity = 15 #how fast the player falls
export var max_speed = 80 #max speed the player will run
export var acceleration = 70 #how fast the player will reach their max spped
export var air_acceleration = 15 #how fast the player will reach their max spped in the air
export var jump_height = 250 # how high you can jump
export var jump_acceleration = 200 #lower numbers lets you hold down the jump button for diff heights
export var max_wall_slide_speed = 60 #max speed the player can fall while hugging wall
export var wall_slide_acceleration = 5 # how fast it takes to reach the max speed of falling while hugging wall
var jump_was_pressed = false
var can_jump = false
var motion = Vector2()
var isgravity = true
export var max_num_jumps = 0 #how many jumps the player can do in the air
var num_jumps = 1
export var coyote_timer = 0.1 #gives player a little extra time to jump after they miss a jump

onready var Spike = preload("res://Player/Projectiles/Spike.tscn")
onready var Poisen = preload("res://Player/Projectiles/Poisen.tscn")
onready var CornSeed = preload("res://Player/Projectiles/CornSeed.tscn")

signal Death

var state = 1

func _ready():
	pass

func _process(delta):
	if position.y >= 154:
		die()
	if Input.is_action_just_pressed("B"):
		warp()
	if state == 1:
		$Sprite.texture = preload("res://Player/Sprites/Cactus.png")
		if Input.is_action_just_pressed("A") and $Cooldown.is_stopped() == true:
			ShootSpike()
	elif state == 2:
		$Sprite.texture = preload("res://Player/Sprites/Shroom.png")
		if Input.is_action_just_pressed("A") and $Cooldown.is_stopped() == true:
			ShootPoisen()
	elif state == 3:
		$Sprite.texture = preload("res://Player/Sprites/Corn.png")
		if Input.is_action_just_pressed("A") and $Cooldown.is_stopped() == true:
			ShootCornSeed()

func _physics_process(delta):
	if is_on_floor():
		if Input.is_action_pressed("RIGHT"):
			motion.x = min(motion.x + acceleration, max_speed)
			$Aim.flip_h = false
			$Aim/AimNode.position.x = 9.5
		elif Input.is_action_pressed("LEFT"):
			motion.x = max(motion.x - acceleration, -max_speed)
			$Aim.flip_h = true
			$Aim/AimNode.position.x = -9.5
		else:
			motion.x = lerp(motion.x,0,.2)
	else:
		if Input.is_action_pressed("RIGHT"):
			motion.x = min(motion.x + air_acceleration, max_speed)
			$Aim.flip_h = false
			$Aim/AimNode.position.x = 9.5
		elif Input.is_action_pressed("LEFT"):
			motion.x = max(motion.x - air_acceleration, -max_speed)
			$Aim.flip_h = true
			$Aim/AimNode.position.x = -9.5
		else:
			motion.x = lerp(motion.x,0,.2)
	
	
	if Input.is_action_just_released("UP") and motion.y < -jump_acceleration:
		motion.y = -100
		
	if Input.is_action_just_pressed("UP"):
		jump_was_pressed = true
		remember_jump_time()
		if can_jump == true:
			motion.y = -jump_height
			if is_on_wall() and Input.is_action_pressed("RIGHT"):
				motion.x = -max_speed
			elif is_on_wall() and Input.is_action_pressed("LEFT"):
				motion.x = max_speed
		elif num_jumps > 0:
			motion.y = -jump_height
			num_jumps = num_jumps - 1
			
	if is_on_floor():
		can_jump = true
		num_jumps = max_num_jumps
		if jump_was_pressed == true:
			motion.y = -jump_height
			
	if is_on_wall() and (Input.is_action_pressed("RIGHT") || Input.is_action_pressed("LEFT")):
		can_jump = false
		num_jumps = max_num_jumps
		if motion.y >= 0:
			motion.y += wall_slide_acceleration
			if wall_slide_acceleration == max_wall_slide_speed:
				motion.y = max_wall_slide_speed
		else:
			motion.y += gravity
	else:
		motion.y += gravity
	
	motion = move_and_slide(motion, up)
	
	if !is_on_floor() and !is_on_wall():
		coyote_time()

func coyote_time():
	yield(get_tree().create_timer(coyote_timer), "timeout")
	can_jump = false
	pass
	
func remember_jump_time():
	yield(get_tree().create_timer(0.06), "timeout")
	jump_was_pressed = false
	pass

func warp():
	$Warp.play()
	if state == 1:
		state = 2
	elif state == 2:
		state = 3
	elif state == 3:
		state = 1

func ShootSpike():
	$Spike.play()
	$Cooldown.start()
	var SpikeIns = Spike.instance()
	get_parent().add_child(SpikeIns)
	SpikeIns.position = $Aim/AimNode.global_position
	if $Aim/AimNode.position.x == 9.5:
		SpikeIns.right = true
	else:
		SpikeIns.right = false
func ShootPoisen():
	$Poisen.play()
	$Cooldown.start()
	var PoisenIns = Poisen.instance()
	get_parent().add_child(PoisenIns)
	PoisenIns.position = $Aim/AimNode.global_position
	if $Aim/AimNode.position.x == 9.5:
		PoisenIns.right = true
	else:
		PoisenIns.right = false
func ShootCornSeed():
	$Corn.play()
	$Cooldown.start()
	var CornSeedIns = CornSeed.instance()
	get_parent().add_child(CornSeedIns)
	CornSeedIns.position = $Aim/AimNode.global_position
	if $Aim/AimNode.position.x == 9.5:
		CornSeedIns.right = true
	else:
		CornSeedIns.right = false


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	die()

func die():
	emit_signal("Death")
