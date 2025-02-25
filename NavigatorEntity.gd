extends CharacterBody2D

@export var movement_speed: float = 8000.0
@export var movement_target: Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var recalc_timer : Timer = $RecalcTimer

func _ready():
	recalc_timer.timeout.connect(_on_recalc_timer_timeout)
	navigation_agent.velocity_computed.connect(_on_velocity_computed)

	navigation_agent.path_desired_distance = 150.0
	navigation_agent.target_desired_distance = 150.0

	# On the first frame the NavigationServer map has not-
	# yet been synchronized; region data and any path query will return empty.
	# Wait for the NavigationServer synchronization by awaiting one frame in the script.
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func _physics_process(delta):
	# Returns if we've reached the end of the path.
	if navigation_agent.is_navigation_finished():
		return

	# Get the next path point from the navigation agent.
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	# Calculate the velocity to move towards the next path point.
	var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed * delta
	_on_velocity_computed(new_velocity)

## Setup the navigation agent.
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_target_position(movement_target.position)

## Set the target position of the navigation agent.
func set_target_position(target_position : Vector2 = Vector2.ZERO) -> void:
	navigation_agent.target_position = target_position

## Called when the recalculation timer times out.
func _on_recalc_timer_timeout() -> void:
	set_target_position(movement_target.position)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
