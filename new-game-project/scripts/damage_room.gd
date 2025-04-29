extends "res://scripts/room.gd"

@export var dps: float = 10.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for e in enemies_inside:
		# Damage each enemy each frame
		e.take_damage(dps)
	
