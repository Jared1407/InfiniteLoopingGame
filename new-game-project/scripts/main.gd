extends Node

@onready var add_room: Button      = $Menus/Buttons/AddRoom
@onready var remove_room: Button   = $Menus/Buttons/RemoveRoom
@onready var add_floor: Button     = $Menus/Buttons/AddFloor
@onready var remove_floor: Button  = $Menus/Buttons/RemoveFloor
@onready var tower: Tower          = $TowerBase/tower

func _ready() -> void:
	add_room.pressed.connect(_on_add_room_pressed)
	remove_room.pressed.connect(_on_remove_room_pressed)
	add_floor.pressed.connect(_on_add_floor_pressed)
	remove_floor.pressed.connect(_on_remove_floor_pressed)

func _on_add_room_pressed() -> void:
	if tower.floors.is_empty():
		tower.add_floor()
	var last_floor = tower.floors.back()
	last_floor.add_room(last_floor.rooms.size())

func _on_remove_room_pressed() -> void:
	if tower.floors.is_empty():
		return
	var last_floor = tower.floors.back()
	last_floor.remove_room(last_floor.rooms.size() - 1)

func _on_add_floor_pressed() -> void:
	tower.add_floor()

func _on_remove_floor_pressed() -> void:
	tower.remove_floor(tower.floors.size() - 1)
