extends Node
class_name MultiplayerManager


const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 7777

@export var player_scene : PackedScene
const multiplayer_player_scene = preload("res://scenes/multiplayer_player.tscn")

@onready var level: Node = $Level
@onready var level_spawner: MultiplayerSpawner = $LevelSpawner
@onready var players: Node = $Players
@onready var players_spawner: MultiplayerSpawner = $PlayersSpawner

var host_mode_enabled := false

func become_host(world_scene: PackedScene):
	print("Become host!")
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = server_peer
	host_mode_enabled = true
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(del_player)
	start_game(world_scene)
	_add_player_to_game(1)
	set_player_name(str(1), "Host")
	

func join_as_player_2(ip_address: String, port: int, player_name: String):
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(ip_address, port)
	
	multiplayer.multiplayer_peer = client_peer
	
	multiplayer.connected_to_server.connect(func():
		print("Connected to server!")
		rpc("set_player_name", str(multiplayer.get_unique_id()), player_name)
	)
	
	print("join to %s:%d as '%s'" % [ip_address, port, player_name])

func _add_player_to_game(id: int):
	# called only by the server
	if not multiplayer.is_server():
		return
		
	var player_to_add = multiplayer_player_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	player_to_add.player_name = str(id)
	player_to_add.multiplayer_manager = self
	
	if players.has_node(str(id)):
		print("Player already exists! Not spawning again.")
		return

	players.add_child(player_to_add, true)
	return player_to_add
	
	
func del_player(id: int):
	print("player %s left the game" % id)
	if not players.has_node(str(id)):
		return
	players.get_node(str(id)).queue_free()
	
	
func start_game(world_scene: PackedScene):
	if multiplayer.is_server():
		change_level.call_deferred(world_scene)

func change_level(scene: PackedScene):
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())

@rpc("any_peer")
func set_player_name(id: String, player_name: String):
	var player = players.get_node(id)
	if player is MultiplayerPlayer:
		player as MultiplayerPlayer
		player.player_name = player_name
	
	
