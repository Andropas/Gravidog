extends Node2D

onready var current_level = get_node("Level")
onready var player = get_node("Level/Player")
onready var check_point = player.position
onready var check_velocity = player.vel
onready var check_gravity = player.gravityVec
onready var anim = $AnimationPlayer

func _on_door_change_level(Level, pos):
	anim.play("change_level")
	#player.disconnect("game_over", current_level, "_on_game_over")
	check_point = pos
	check_velocity = player.vel
	check_gravity = player.gravityVec
	var level = Level.instance()
	current_level.remove_child(player)
	level.add_child(player)
	player.position = pos
	current_level.queue_free()
	call_deferred("add_child", level)
	current_level = level
	


func _on_game_over():
	anim.play("change_level")
	player.position = check_point
	player.vel = check_velocity
	player.change_gravity(check_gravity) 
	player.get_node("Shape").rotation = player.rotate_to
	player.can_change_gravity = true
	
