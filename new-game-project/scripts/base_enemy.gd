extends RigidBody2D
class_name BaseEnemy

var health: float = 100.0
var base_speed: float = 100.0
var current_slow: float = 1.0 # Default 100% speed
var current_floor: Floor = null

#TODO: Reset speed when entering a portal
#Note: probs should be reset when exiting a slow type room tho yeah?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start at the right side of the screen
	position = Vector2(1000, 0)  # Adjust this value based on your screen size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var speed = base_speed * current_slow
	
	# Move left
	position.x -= speed * delta
	
	# Check if we've reached the left portal
	if current_floor and position.x <= current_floor.get_node("LeftPortal").position.x:
		_handle_portal_transition()

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		queue_free()
		
func apply_slow(factor: float) -> void:
	current_slow = min(current_slow, factor)
	pass
	
func reset_slow() -> void:
	current_slow = 1.0

func set_floor(floor_node: Floor) -> void:
	current_floor = floor_node

func _handle_portal_transition() -> void:
	if not current_floor:
		return
		
	# Get the tower node
	var tower = current_floor.get_parent()
	if not tower:
		return
		
	# Find the current floor's index
	var current_index = tower.floors.find(current_floor)
	if current_index == -1:
		return
		
	# If there's a floor above, teleport to it
	if current_index < tower.floors.size() - 1:
		var next_floor = tower.floors[current_index + 1]
		position = Vector2(next_floor.get_node("RightPortal").position.x, next_floor.position.y)
		set_floor(next_floor)
		reset_slow()  # Reset slow effect when changing floors
	else:
		# No more floors, damage player and die
		var game_manager = get_node("/root/GameManager")
		if game_manager:
			game_manager.damage_player(1)
		queue_free()
