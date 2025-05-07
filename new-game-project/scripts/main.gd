extends Node

const BaseEnemy = preload("res://scripts/base_enemy.gd")
const GameManager = preload("res://scripts/game_manager.gd")

#Temp Testing Buttons:
@onready var add_room: Button      = $Menus/Buttons/AddRoom
@onready var remove_room: Button   = $Menus/Buttons/RemoveRoom
@onready var add_floor: Button     = $Menus/Buttons/AddFloor
@onready var remove_floor: Button  = $Menus/Buttons/RemoveFloor

# Tower
@onready var tower: Tower          = $TowerBase/tower

# Menu/Shop
@onready var menu: Control = $Menus/Shop
@onready var menu_checkout: Button = $Menus/Shop/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Checkout
@onready var menu_cancel: Button = $Menus/Shop/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Cancel
@onready var shop_button: Button = $Menus/Buttons/ShopButton
@onready var tooltip_label: RichTextLabel = $Menus/Shop/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VBoxContainer/RichTextLabel

# Enemy spawning
@export var enemy_scene: PackedScene = preload("res://scenes/base_enemy.tscn")
var spawn_timer: Timer
var wave_timer: Timer
var current_wave: int = 0
var enemies_per_wave: int = 5
var spawn_interval: float = 2.0

# Game state
var game_started: bool = false
var current_round: int = 0

# Shop state
var chosen_room: PackedScene = null
var chosen_slot: int = -1

func _ready() -> void:
	#Testing Buttons:
	add_room.pressed.connect(_on_add_room_pressed)
	remove_room.pressed.connect(_on_remove_room_pressed)
	add_floor.pressed.connect(_on_add_floor_pressed)
	remove_floor.pressed.connect(_on_remove_floor_pressed)
	
	# Connect menu/shop buttons
	menu_checkout.pressed.connect(_on_menu_checkout_pressed)
	menu_cancel.pressed.connect(_on_menu_cancel_pressed)
	shop_button.pressed.connect(_on_shop_button_pressed)
	
	# Show menu at start
	menu.visible = true
	
func start_game() -> void:
	game_started = true
	menu.visible = false
	
	#When the game starts we start with 1 floor populated with the base rooms:
	tower.add_floor()
	
	# Setup enemy spawning
	_setup_enemy_spawning()
	
func _setup_enemy_spawning() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_spawn_enemy)
	add_child(spawn_timer)
	
	wave_timer = Timer.new()
	wave_timer.wait_time = enemies_per_wave * spawn_interval + 5.0  # Extra time between waves
	wave_timer.one_shot = true
	wave_timer.timeout.connect(_start_next_wave)
	add_child(wave_timer)
	
	_start_next_wave()

func _start_next_wave() -> void:
	current_wave += 1
	enemies_per_wave = 5 + current_wave  # Increase enemies per wave
	spawn_timer.start()
	wave_timer.start()

func _spawn_enemy() -> void:
	if tower.floors.is_empty():
		return
		
	var enemy = enemy_scene.instantiate() as BaseEnemy
	var bottom_floor = tower.floors[0]
	enemy.set_floor(bottom_floor)
	add_child(enemy)
	
	# Stop spawning if we've reached the wave limit
	if get_tree().get_nodes_in_group("enemies").size() >= enemies_per_wave:
		spawn_timer.stop()

func _on_menu_checkout_pressed() -> void:
	if not game_started:
		start_game()
	else:
		# Handle shop purchase
		if chosen_room and chosen_slot >= 0:
			var current_floor = tower.floors.back()
			current_floor.replace_room(chosen_slot, chosen_room)
			menu.visible = false
			chosen_room = null
			chosen_slot = -1
	
func _on_menu_cancel_pressed() -> void:
	menu.visible = false
	chosen_room = null
	chosen_slot = -1

func _on_shop_button_pressed() -> void:
	menu.visible = !menu.visible
	if menu.visible:
		_populate_shop_options()

func _populate_shop_options() -> void:
	# Clear existing options
	var day_list = menu.get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/DayList")
	var night_list = menu.get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/NightList")
	
	for child in day_list.get_children():
		child.queue_free()
	for child in night_list.get_children():
		child.queue_free()
	
	# Add available room options
	var game_manager = get_node_or_null("GameManager")
	if not game_manager:
		push_error("GameManager node not found!")
		return
		
	for upgrade in game_manager.upgrade_defs:
		var button = TextureButton.new()
		button.texture_normal = load("res://assets/kenney_ui-pack/PNG/Blue/Default/button_rectangle_border.png")
		button.pressed.connect(_on_room_option_selected.bind(upgrade.scene))
		button.mouse_entered.connect(_on_room_option_hover.bind(upgrade))
		button.mouse_exited.connect(_on_room_option_exit)
		day_list.add_child(button)

func _on_room_option_selected(room_scene: PackedScene) -> void:
	chosen_room = room_scene
	# TODO: Show room preview or highlight selected option

func _on_room_option_hover(upgrade: GameManager.Upgrade) -> void:
	var description = upgrade.name + "\nCost: " + str(upgrade.cost) + "\n"
	if upgrade.scene.resource_path.contains("damage"):
		description += "Deals damage to enemies that pass through"
	elif upgrade.scene.resource_path.contains("slow"):
		description += "Slows enemies that pass through"
	tooltip_label.text = description

func _on_room_option_exit() -> void:
	tooltip_label.text = "TIPS ABOUT TOOL\nthis is where you learn about the rooms and what they do."

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
