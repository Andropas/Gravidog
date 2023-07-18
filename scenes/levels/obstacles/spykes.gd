extends TileMap

@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var cells = get_used_cells(0)
	for c in cells:
		var data = get_cell_tile_data(0, c)
		var points = data.get_collision_polygon_points(0, 0)
		
		var collision_shape = CollisionPolygon2D.new()
		collision_shape.polygon = points
		collision_shape.position = c*cell_quadrant_size + Vector2i(cell_quadrant_size, cell_quadrant_size)/2
		area.add_child(collision_shape)

func _on_body_entered(body):
	if body.has_method("die"):
		body.die()
