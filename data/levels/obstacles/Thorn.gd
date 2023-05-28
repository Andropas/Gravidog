extends Area2D



func _on_Thorn_body_entered(body):
	if body.has_method("die"):
		body.die()
