extends KinematicBody2D

signal game_over

var gravityVec = Vector2(0, 1)
var gravity = 1000
var max_gravity = 500
var vel = Vector2()
var rotating_speed = 10
export var jumpspeed = 800
export var speed = 200
var can_change_gravity = true
var rotate_to = 0

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
#		if is_on_floor():
#			vel = speed * (-Vector2(gravityVec.y, -gravityVec.x))
		if gravityVec.y:
			vel.x = -speed
			$Shape.scale.x = -gravityVec.y

	if Input.is_action_pressed("move_right"):
#		if is_on_floor():
#			vel = speed * (Vector2(gravityVec.y, -gravityVec.x))
		if gravityVec.y:
			vel.x = speed * abs(gravityVec.y)
			$Shape.scale.x = gravityVec.y
	
	if Input.is_action_pressed("move_up"):
		if gravityVec.x:
			vel.y = -speed
			$Shape.scale.x = gravityVec.x
	
	if Input.is_action_pressed("move_down"):
		if gravityVec.x:
			vel.y = speed
			$Shape.scale.x = -gravityVec.x
	
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
	if abs($Shape.rotation - rotate_to) >= rotating_speed*delta:
		$Shape.rotation += rotating_speed*delta*sign(rotate_to - $Shape.rotation)
	else:
		$Shape.rotation = rotate_to
#	$Camera2D.rotation = $Shape.rotation
	vel = move_and_slide(vel, -gravityVec)
