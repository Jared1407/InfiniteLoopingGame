extends Node2D
class_name Room
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Init room type and visuals
	# Enrique !!
	var rectangle = RectangleShape2D.new()
	rectangle.size = Vector2((get_node("RoomArt").texture.get_width()),(get_node("RoomArt").texture.get_height()))
	collision_shape_2d.shape = rectangle
	
	
	pass # Replace with function body.

# The art/texture will decide h/w
func get_width() -> float:
	return get_node("RoomArt").texture.get_width()

func get_height() -> float:
	return get_node("RoomArt").texture.get_height()

func _gui_input(event) -> void:
	# Handle click event:
	print(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
