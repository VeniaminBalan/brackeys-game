extends Node
class_name BaseGameManager

const SERVER_IP := "127.0.0.1"
const SERVER_PORT := 7777

@export var world_scenes: Array[PackedScene]  # List of levels
const PLAYER: = preload("res://scenes/player.tscn")  # The player scene
@onready var current_world: BaseWorld = null  # Active world

func start():
	load_level(0) 
	create_player(current_world.start_position)
		
func load_level(index: int):
	"""Loads a new level from `world_scenes`"""
	if index < 0 or index >= world_scenes.size():
		push_error("[BaseGameManager] Invalid level index!")
		return

	if current_world:
		current_world.queue_free()  # Remove previous world

	current_world = world_scenes[index].instantiate()
	add_child(current_world)

func create_player(position):
	var player = PLAYER.instantiate()
	add_child(player)
	player.position = position
	player.start_position = position
