extends CharacterBody2D

@onready var playerAnim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@export var max_jump_count = 2

var jump_count = 0

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0: 
			playerAnim.play('jump')
		elif velocity.y > 0:
			playerAnim.play('fall')
	else:
		jump_count = 0
		if velocity.x != 0:
			playerAnim.play('walk')
		elif velocity.x == 0 && Input.is_action_pressed("crouch"):
			playerAnim.play('crouch')
		else:
			playerAnim.play('idle')

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		jump_count += 1
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x > 0:
		playerAnim.flip_h = !direction
	elif velocity.x < 0:
		playerAnim.flip_h = direction

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("deathzone"):
		call_deferred("reload_scene")
	elif area.is_in_group("endzone"):
		var next_scene = area.next_level
		if next_scene:
			call_deferred("load_scene", next_scene)
		else:
			push_error("Próxima fase não definida no finish_zone!")
		
func reload_scene():
		get_tree().reload_current_scene()
		
func load_scene(scene: String):
		get_tree().change_scene_to_file("res://scenes/" + scene + ".tscn")
