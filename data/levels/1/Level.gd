extends Node2D

@export var camera_limits: Rect2
@onready var game_zone = $GameArea


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


func _on_game_area_body_exited(body):
	if body.has_method("die"):
		body.die()
