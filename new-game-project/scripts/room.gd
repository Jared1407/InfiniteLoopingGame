extends Node2D
class_name Room
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@onready var area: Area2D = $Area2D
var enemies_inside: = []

# Clickable:
signal clicked(room_node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Init room type and visuals
	var rectangle = RectangleShape2D.new()
	rectangle.size = Vector2((get_node("RoomArt").texture.get_width()),(get_node("RoomArt").texture.get_height()))
	collision_shape_2d.shape = rectangle
	
	# Keep track of enemies in each room:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	
	area.connect("input_event", _on_input_event)
	
func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked",self)
		#print(shape_idx)
	
func _on_body_entered(body: Node) -> void:
	enemies_inside.append(body)
	
func _on_body_exited(body: Node) -> void:
	enemies_inside.erase(body)
	
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
