extends KinematicBody2D

signal game_over
signal player_reached

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

func move(delta):
	if is_on_floor():
		can_change_gravity = true
		vel.x *= abs(gravityVec.x)
		vel.y *= abs(gravityVec.y)

	vel += gravityVec * gravity * delta
	if Vector2(vel.x * gravityVec.x, vel.y + gravityVec.y).length() >= max_gravity:
		vel = vel.normalized() * max_gravity

func _process(delta):
	move(delta)
	if abs($Shape.rotation - rotate_to) >= rotating_speed*delta:
		$Shape.rotation += rotating_speed*delta*sign(rotate_to - $Shape.rotation)
	else:
		$Shape.rotation = rotate_to

	vel = move_and_slide(vel, -gravityVec)

func _on_Radar_body_entered(body):
	if body.is_in_group("Player"):
#		print("level completed")
		emit_signal("player_reached")
