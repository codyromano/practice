extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var horiz_direction = Input.get_axis("ui_left", "ui_right")
	var vert_direction = Input.get_axis("ui_up", "ui_down")
	
	if horiz_direction:
		velocity.x = horiz_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if vert_direction:
		velocity.y = vert_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
