extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 7777

func become_host():
	print("Become host!")
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(del_player)

func join_as_player_2(ip_address: String, port: int, name: String):
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(ip_address, port)
	
	multiplayer.multiplayer_peer = client_peer
	
	print("join to %s:%d as '%s'" % [ip_address, port, name])

func _add_player_to_game(id: int):
	print("player %s joined the game" % id)
	
func del_player(id: int):
	print("player %s left the game" % id)
