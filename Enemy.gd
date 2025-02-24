extends CharacterBody2D

const SPEED = 6000.0
@onready var nav_agent = $NavigationAgent2D
@export var target: Node2D

func _ready():
	nav_agent.debug_enabled = true
	nav_agent.target_desired_distance = 100 # stops on target; settting to 100 stops well short
	nav_agent.path_desired_distance = 1

	_update_target_distance.call_deferred()
	
func _update_target_distance()  -> void:
	nav_agent.target_position = target.global_position
	nav_agent.target_desired_distance = 100

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var next = nav_agent.get_next_path_position()
		velocity = global_position.direction_to(next) * SPEED * delta
		move_and_slide()
