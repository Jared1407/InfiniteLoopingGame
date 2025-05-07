extends Node

# Struct for upgrades
class Upgrade:
	# Specialized Room:
	var scene: PackedScene
	# How much the room Costs
	var cost: int
	var name: String

#Possible shop items:
@export var upgrade_defs = [
	preload("res://scenes/damage_room.tscn"),
	preload("res://scenes/slow_room.tscn")
	]
	
@export var base_room: PackedScene

# Player stats
var player_health: int = 10
var game_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damage_player(amount: int) -> void:
	player_health -= amount
	if player_health <= 0:
		game_over = true
		# TODO: Implement game over screen
