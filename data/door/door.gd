extends Area2D

@onready var game = get_tree().root.get_node("Main/Game")
@export var Level: String
@export var door_position: Vector2

signal change_level(level, pos)

func _ready():
	connect("change_level", Callable(game, "_on_door_change_level"))

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("change_level", load(Level), door_position)
