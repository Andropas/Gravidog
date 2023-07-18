extends CharacterBody2D

signal game_over
@onready var anim = $AnimationPlayer

var gravityVec = Vector2(0, 1)
var gravity = 1000/3
var max_gravity = 500/3
var vel = Vector2()
var rotating_speed = 10
@export var jumpspeed = 800/3
@export var speed = 200/3
var can_change_gravity = true
var rotate_to = 0

signal picked_item(item)

func die():
	emit_signal("game_over")

func jump():
	vel = jumpspeed * (-Vector2(gravityVec.x, gravityVec.y))

func change_gravity(vec):
	if gravityVec != vec:
		gravityVec = vec
	#	$Shape.rotation = gravityVec.angle() - PI/2
		rotate_to = gravityVec.angle() - PI/2
		can_change_gravity = false
	#	get_tree().root.get_child(0).rotation = -vec.angle() + PI/2
		get_tree().call_group("UseGravity", "change_gravity", vec)

func move(delta):
	if is_on_floor():
		can_change_gravity = true
		vel.x *= abs(gravityVec.x)
		vel.y *= abs(gravityVec.y)
	
#	vel.x *= abs(gravityVec.x)
#	vel.y *= abs(gravityVec.y)
	
	if Input.is_action_pressed("move_left"):
		if gravityVec.y:
			vel.x = -speed
			$Shape3D.scale.x = -gravityVec.y

	if Input.is_action_pressed("move_right"):
		if gravityVec.y:
			vel.x = speed * abs(gravityVec.y)
			$Shape3D.scale.x = gravityVec.y
	
	if Input.is_action_pressed("move_up"):
		if gravityVec.x:
			vel.y = -speed
			$Shape3D.scale.x = gravityVec.x
	
	if Input.is_action_pressed("move_down"):
		if gravityVec.x:
			vel.y = speed
			$Shape3D.scale.x = -gravityVec.x
	
	if can_change_gravity:
		if Input.is_action_just_pressed("ui_left"):
			change_gravity(Vector2(-1, 0))
		if Input.is_action_just_pressed("ui_right"):
			change_gravity(Vector2(1, 0))
		if Input.is_action_just_pressed("ui_up"):
			change_gravity(Vector2(0, -1))
		if Input.is_action_just_pressed("ui_down"):
			change_gravity(Vector2(0, 1))
#	if Vector2(vel.x * gravityVec.x, vel.y + gravityVec.y).length() <= max_gravity:
	vel += gravityVec * gravity * delta
	if Vector2(vel.x * gravityVec.x, vel.y + gravityVec.y).length() >= max_gravity:
		vel = vel.normalized() * max_gravity
	
	if Input.is_action_pressed("jump") and is_on_floor():
		jump()

func _process(delta):
	move(delta)
	
	# CHANGE WITH TWEENS!!!
	if abs($Shape3D.rotation - rotate_to) >= rotating_speed*delta:
		$Shape3D.rotation += rotating_speed*delta*sign(rotate_to - $Shape3D.rotation)
	else:
		$Shape3D.rotation = rotate_to
	
	# CHANGE WITH TWEENS
	
	set_velocity(vel)
	set_up_direction(-gravityVec)
	set_floor_stop_on_slope_enabled(true)
	set_max_slides(4)
	set_floor_max_angle(0.0)
	# TODOConverter40 infinite_inertia were removed in Godot 4.0 - previous value `false`
	move_and_slide()
	vel = velocity
	if is_on_floor() and (vel*gravityVec).length() == 0 and vel:
		anim.play("move")
	else:
		anim.play("idle")
