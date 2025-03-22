extends Camera2D

var player: Node2D;

func _physics_process(delta: float) -> void:
	
	var players = get_tree().get_nodes_in_group("Players")
	
	player = players[0]
	
	self.position = player.position
