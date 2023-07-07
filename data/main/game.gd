extends Node2D

onready var current_level = get_node("Level")
onready var player = get_node("Level/Player")
onready var check_point = player.position
onready var check_velocity = player.vel
onready var check_gravity = player.gravityVec

func _on_door_change_level(Level, pos):
	#player.disconnect("game_over", current_level, "_on_game_over")
	check_point = pos
	check_velocity = player.vel
	check_gravity = player.gravityVec
	var prev_level = get_child(0)
	var level = Level.instance()
	prev_level.remove_child(player)
	level.add_child(player)
	player.position = pos
	player.owner = level
	#prev_level.get_tree().change_scene_to(level)
	prev_level.queue_free()
	call_deferred("add_child", level)


func _on_game_over():
	player.position = check_point
	player.vel = check_velocity
	player.change_gravity(check_gravity) 
	player.get_node("Shape").rotation = player.rotate_to
	player.can_change_gravity = true
