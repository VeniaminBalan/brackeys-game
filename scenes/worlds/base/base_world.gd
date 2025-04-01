extends Node2D
class_name BaseWorld

@export var player_scene: PackedScene  # Reference to the Player scene
@export var start_node: Node2D
@export var spawner: MultiplayerSpawner
@export var players_container: Node2D

var start_position: Vector2:
	get:
		return start_node.position


func _ready():
	_validate_exports()  # Ensure required nodes are set
		
	if multiplayer.is_server():
		_setup_multiplayer_spawner()

func _setup_multiplayer_spawner():
	print("Setting up multiplayer spawner")
	spawner.spawn_function = _spawn_player  # Assigns the player spawn function

func _spawn_player(id: int):
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)  # Assign unique ID
	players_container.add_child(player_instance)
	return player_instance

func reset_world():
	"""Reset world state (used for restarting the level)"""
	for player in players_container.get_children():
		player.queue_free()  # Remove old players
	_setup_multiplayer_spawner()  # Restart multiplayer setup

func _validate_exports():
	"""Ensures required nodes are set to prevent errors"""
	assert(player_scene, "[BaseWorld] ERROR: 'player_scene' is not assigned!")
	assert(start_node, "[BaseWorld] ERROR: 'start_node' is not assigned!")
	assert(spawner, "[BaseWorld] ERROR: 'spawner' is not assigned!")
	assert(players_container, "[BaseWorld] ERROR: 'players_container' is not assigned!")
