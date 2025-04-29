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
	room.position = Vector2(slot_index * room.get_width(), 0)
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
		rooms[i].position = Vector2(i * rooms[i].get_width(),0)
		
func setup_portals() -> void:
	var total_width = MAX_ROOMS * $rooms.get_child(0).get_width()
	# Since A sprite's middle is placed on zero zero, half of it is .5 * rooms.get_width,
	# total_width is 3 * get width, so we ofset by .5 * total_width/3 or total/6
	$LeftPortal.position = Vector2(0 - total_width/6 , 0)
	$RightPortal.position = Vector2(total_width - total_width/6, 0)
	
func replace_room(slot_index: int, new_scene: PackedScene) -> void:
	if slot_index < 0 or slot_index >= rooms.size():
		return
	# Delete old room:
	var old = rooms[slot_index]
	rooms.remove_at(slot_index)
	old.queue_free()
	
	#replace with new:
	var room = new_scene.instantiate() as Room
	$rooms.add_child(room)
	rooms.insert(slot_index,room)
	reposition_rooms()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
