extends Area2D

onready var game = get_tree().root.get_node("Main/Game")
export (String) var Level
export (Vector2) var door_position

signal change_level(level, pos)

func _ready():
	connect("change_level", game, "_on_door_change_level")

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("change_level", load(Level), door_position)
