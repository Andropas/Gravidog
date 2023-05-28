extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_GameZone_body_exited(body):
	print(body.name)
	if body.has_method("die"):
		body.die()


func _on_Dog_game_over():
	get_tree().reload_current_scene()


func _on_Dog_player_reached():
	print("configurations!")
