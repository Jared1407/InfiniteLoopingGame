extends Node

# Struct for upgrades
class Upgrade:
	# Specialized Room:
	var scene: PackedScene
	# How much the room Costs
	var cost: int
	var name: String

@export var upgrade_defs: Array[Resource]
@export var base_room: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
