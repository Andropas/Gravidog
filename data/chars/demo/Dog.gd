extends CharacterBody2D

signal game_over
signal player_reached

var gravityVec = Vector2(0, 1)
var gravity = 1000/3
var max_gravity = 500/3
var vel = Vector2()
var rotating_speed = 10
@export var jumpspeed = 800/3
@export var speed = 200/3
var can_change_gravity = true
var rotate_to = 0

func die():
	emit_signal("game_over")

func jump():
	velocity = jumpspeed * (-Vector2(gravityVec.x, gravityVec.y))

func change_gravity(vec):
	if gravityVec != vec:
		gravityVec = vec
	#	$Shape.rotation = gravityVec.angle() - PI/2
		rotate_to = gravityVec.angle() - PI/2
		can_change_gravity = false
	#	get_tree().root.get_child(0).rotation = -vec.angle() + PI/2

func move(delta):
	if is_on_floor():
		can_change_gravity = true
		vel.x *= abs(gravityVec.x)
		vel.y *= abs(gravityVec.y)

	velocity += gravityVec * gravity * delta
	if Vector2(velocity.x * gravityVec.x, velocity.y + gravityVec.y).length() >= max_gravity:
		velocity = velocity.normalized() * max_gravity

func _process(delta):
	move(delta)
	if abs($Shape3D.rotation - rotate_to) >= rotating_speed*delta:
		$Shape3D.rotation += rotating_speed*delta*sign(rotate_to - $Shape3D.rotation)
	else:
		$Shape3D.rotation = rotate_to

	set_up_direction(-gravityVec)
	move_and_slide()

func _on_Radar_body_entered(body):
	if body.is_in_group("Player"):
#		print("level completed")
		emit_signal("player_reached")
