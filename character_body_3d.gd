extends CharacterBody3D

@export var speed: float = 6.0
@export var mouse_sensitivity: float = 0.0025

@onready var cam: Camera3D = $Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var pitch: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		pitch = clamp(pitch - event.relative.y * mouse_sensitivity, -1.4, 1.4)
		cam.rotation.x = pitch

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	var input_vec := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("back") - Input.get_action_strength("forward")
	)

	var dir := (transform.basis * Vector3(input_vec.x, 0.0, input_vec.y)).normalized()

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	move_and_slide()
