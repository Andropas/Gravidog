extends Area2D

var following = null
var velocity = Vector2()
var max_speed = 60
var acceleration = 300
var deceleration = 300

func _on_body_entered(body):
	if body.name == "Player":
		following = body
		body.connect("picked_item", Callable(self, "_on_player_item_changed"))
		body.emit_signal("picked_item", self)
		


func _on_player_item_changed(item):
	if item != self:
		monitoring = true
		following.disconnect("picked_item", Callable(self, "_on_player_item_changed"))
		following = null
	else:
		set_deferred("monitoring", false)
		$GPUParticles2D.emitting = true


func _process(delta):
	if following != null:
		if (following.position - position).length() > 30:
			velocity += acceleration*delta*(following.position - position).normalized()
			velocity = clamp(velocity.length(), 0, max_speed*(following.position - position).length()/30)*velocity.normalized()
	if following == null or (following.position - position).length() <= 30:
		velocity = clamp(velocity.length()-deceleration*delta, 0, max_speed)*velocity.normalized()
	position += velocity*delta
	
	
