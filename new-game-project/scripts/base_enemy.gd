extends RigidBody2D
var health: float = 100.0
var base_speed: float = 100.0
var current_slow: float = 1.0 # Default 100% speed

#TODO: Reset speed when entering a portal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var speed = base_speed * current_slow
	
	pass

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		queue_free()
		
func apply_slow(factor: float) -> void:
	current_slow = min(current_slow, factor)
	pass
	
func reset_slow() -> void:
	current_slow = 1.0
