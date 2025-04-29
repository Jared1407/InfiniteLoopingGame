extends Node

#Temp Testing Buttons:
@onready var add_room: Button      = $Menus/Buttons/AddRoom
@onready var remove_room: Button   = $Menus/Buttons/RemoveRoom
@onready var add_floor: Button     = $Menus/Buttons/AddFloor
@onready var remove_floor: Button  = $Menus/Buttons/RemoveFloor

# Tower
@onready var tower: Tower          = $TowerBase/tower

# Shop Menu
@onready var panel: Panel = $Menus/Panel
@onready var upgrade_title: Label = $Menus/Panel/UpgradeTitle
@onready var cost: Label = $Menus/Panel/Cost
@onready var buy: Button = $Menus/Panel/Buy
@onready var cancel: Button = $Menus/Panel/Cancel
@onready var room_options: HBoxContainer = $Menus/Panel/RoomOptions

#Init Vars for shop:
var chosen_scene : PackedScene
var chosen_slot : int = -1

func _ready() -> void:
	#Testing Buttons:
	add_room.pressed.connect(_on_add_room_pressed)
	remove_room.pressed.connect(_on_remove_room_pressed)
	add_floor.pressed.connect(_on_add_floor_pressed)
	remove_floor.pressed.connect(_on_remove_floor_pressed)
	
	#When the game starts we start with 1 floor populated with the base rooms:
	tower.add_floor()
	
	# Connect shop menu items
	buy.pressed.connect(_on_buy_pressed)
	cancel.pressed.connect(_on_cancel_pressed)
	
	# Hide Buttons until the shop "opens"
	panel.visible = false
	#show_round_shop()
	
#Function for end of round:
func show_round_shop() -> void:
	var children = room_options.get_children()
	for i in children:
		room_options.remove_child(i)
		
	
	panel.visible = true
	chosen_scene = null
	chosen_slot = -1
	buy.disabled = true
	
	# For now pick 1 random room scene
	var pool = get_node("GameManager").upgrade_defs.duplicate()
	print(pool)
	
	
func _on_cancel_pressed() -> void:
	pass
	
func _on_buy_pressed() -> void:
	pass

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
