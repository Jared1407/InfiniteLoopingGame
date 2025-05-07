extends Node

# Struct for upgrades
class Upgrade:
	var scene: PackedScene
	var cost: int
	var name: String
	
	func _init(p_scene: PackedScene, p_cost: int, p_name: String) -> void:
		scene = p_scene
		cost = p_cost
		name = p_name

#Possible shop items:
@export var upgrade_defs = [
	Upgrade.new(
		preload("res://scenes/damage_room.tscn"),
		100,
		"Damage Room"
	),
	Upgrade.new(
		preload("res://scenes/slow_room.tscn"),
		75,
		"Slow Room"
	)
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
