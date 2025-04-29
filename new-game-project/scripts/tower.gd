extends Node2D
class_name Tower

@export var floor_scene: PackedScene = preload("res://scenes/floor.tscn")
var floors: Array[Floor] = []

func _ready() -> void:
	_reposition_floors()

func add_floor() -> void:
	var f = floor_scene.instantiate() as Floor
	add_child(f)
	floors.append(f)
	_reposition_floors()

func remove_floor(index: int) -> void:
	if index < 0 or index >= floors.size():
		return
	floors[index].queue_free()
	floors.remove_at(index)
	_reposition_floors()

func _reposition_floors() -> void:
	for i in range(floors.size()):
		var h = floors[i].get_node("rooms").get_child(0).get_height()
		floors[i].position = Vector2(0, -i * h)
