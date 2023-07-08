extends Node2D

export (Rect2) var camera_limits
onready var game_zone = $GameZone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_GameZone_body_exited(body):
	if body.has_method("die"):
		body.die()


func _on_game_over():
	get_tree().reload_current_scene()


func _on_Dog_player_reached():
	print("configurations!")


func _on_child_entered_tree(node):
	if node.name == "Player":
		var camera = node.get_node("Camera2D")
		camera.limit_left = camera_limits.position.x
		camera.limit_top = camera_limits.position.y
		camera.limit_right = camera_limits.end.x
		camera.limit_bottom = camera_limits.end.y
		print("I'm here " + self.name)
