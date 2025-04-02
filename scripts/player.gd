extends CharacterBody2D

@onready var playerAnim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var player_inside: bool = false

enum {
	GROUND,
	AIR,
	DAMAGE,
	CROUCH,
	ATTACK,
	LEVEL
}

var state: int = GROUND

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("left", "right")
	
	match state:
		GROUND: input_in_ground(direction)
		CROUCH: input_in_crouch()
		AIR: input_in_air(direction, delta)
		ATTACK: input_attack(direction)
		
	if velocity.x > 0:
		playerAnim.flip_h = !direction
	elif velocity.x < 0:
		playerAnim.flip_h = direction
		
	move_and_slide()
	

func input_in_ground(direction):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x != 0:
		playerAnim.play('walk')
	elif velocity.x == 0 && Input.is_action_pressed("crouch"):
		state = CROUCH
	else:
		playerAnim.play('idle')
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if not is_on_floor():
		state = AIR		
		
	if Input.is_action_just_pressed("jump") :
		velocity.y = JUMP_VELOCITY
		state = AIR
		
	if player_inside and Input.is_action_just_pressed("forward"):
		print("Dentro da caverna!")
	
func input_in_crouch():
	if Input.is_action_pressed("crouch"):
		playerAnim.play('crouch')
	else:
		state = GROUND
	
func input_in_air(direction, delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0: 
			playerAnim.play('jump')
		elif velocity.y > 0:
			playerAnim.play('fall')
	else:
		state = GROUND
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func input_attack(direction):
	if Input.is_action_pressed("attack"):
		playerAnim.play("multi_casting")
	else:
		state = GROUND
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("DeathZones"):
		get_tree().reload_current_scene()
	elif area.is_in_group("EndZones"):
		get_tree().change_scene_to_file("res://scenes/forest.tscn")
	elif area.is_in_group("change_level_zone"):
		player_inside = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("change_level_zone"):
		player_inside = false
