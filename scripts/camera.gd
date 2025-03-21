extends Camera2D

var player: Node2D

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("players")
	
	if players.size() > 0:
		player = players[0]
	else:
		push_error("player not found")

func _physics_process(delta: float) -> void:
	self.position = player.position
