extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var mouse_sensitivity: float = 0.005

@onready var camera_3d = $Camera3D

var vertical_rotation = 0.0
var max_vertical_angle = 89.0  # Limit the vertical rotation to avoid flipping

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	# Mouse look functionality
	elif event is InputEventMouseMotion:
		# Horizontal rotation (y-axis, for player body)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Vertical rotation (x-axis, for camera)
		vertical_rotation = clamp(vertical_rotation - event.relative.y * mouse_sensitivity, -max_vertical_angle, max_vertical_angle)
		camera_3d.rotation_degrees.x = vertical_rotation
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
