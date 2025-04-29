extends "res://scripts/room.gd"

@export var slow_factor: float = 0.5 # Lets start with 50%


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for e in enemies_inside:
		e.apply_slow(slow_factor)
	pass
