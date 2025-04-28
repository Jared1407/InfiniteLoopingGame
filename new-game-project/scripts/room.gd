extends Node2D
class_name Room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Init room type and visuals
	# Enrique !!
	pass # Replace with function body.

# The art/texture will decide h/w
func get_width() -> float:
	return get_node("RoomArt").texture.get_width()

func get_height() -> float:
	return get_node("RoomArt").texture.get_height()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
