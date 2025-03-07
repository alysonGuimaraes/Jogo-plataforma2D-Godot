extends CharacterBody2D

@onready var playerAnim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0: 
			playerAnim.play('jump')
		elif velocity.y > 0:
			playerAnim.play('fall')
	else: 
		if velocity.x != 0:
			playerAnim.play('walk')
		elif velocity.x == 0 && Input.is_action_pressed("crouch"):
			playerAnim.play('crouch')
		else:
			playerAnim.play('idle')

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
