extends Node2D
class_name Floor

# Exports
@export var room_scene: PackedScene = preload("res://scenes/room.tscn")

# Constants
const MAX_ROOMS := 3

# Vars
var rooms: Array[Room] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_rooms()
	setup_portals()


func populate_rooms():
	for i in range(MAX_ROOMS):
		add_room(i)

func add_room(slot_index: int) -> void:
	# If at max capacity do nothing: NEED: add error message to user
	if rooms.size() >= MAX_ROOMS:
		return
		
	# Create a variable that represents a new room scene
	var room = room_scene.instantiate() as Room
	room.position = Vector2(slot_index * 200, 0)
	# Put the rooms under the 'rooms' node
	$rooms.add_child(room)
	# Add these rooms to the array created earlier
	rooms.append(room)
	
	
func remove_room(slot_index: int) -> void:
	if slot_index < 0 or slot_index >= rooms.size():
		return
	
	var room = rooms[slot_index]
	rooms.remove_at(slot_index)
	room.queue_free()
	# Need to fill the space, probably need a dummy room to go in the space
	reposition_rooms()

func reposition_rooms() -> void:
	for i in range(rooms.size()):
		rooms[i].position = Vector2(i * 50,0)
		
func setup_portals() -> void:
	var total_width = MAX_ROOMS * $rooms.get_child(0).get_width()
	$LeftPortal.position = Vector2(0, 0)
	$RightPortal.position = Vector2(total_width, 0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
