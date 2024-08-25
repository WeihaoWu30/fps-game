extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var step_height= 1

@onready var bullet_spawn_point = $Pivot/Camera3D/BulletSpawn
@onready var bullet = preload("res://bullet.tscn")
@export var bullet_velocity = 200
@export var max_distance = 100

var bullets = 10

@onready var stairs_ray_cast = $RayCast3D


@onready var pivot := $Pivot
@onready var camera := $Pivot/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	stairs_ray_cast.target_position = Vector3(0, -step_height, 1)
	stairs_ray_cast.enabled = true

# Move Character Camera
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			pivot.rotate_y(-event.relative.x * .01)
			camera.rotate_x(-event.relative.y * .01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func spawn_bullet():
	var b = bullet.instantiate()
	add_sibling(b)
	b.transform = bullet_spawn_point.global_transform
	b.linear_velocity = bullet_spawn_point.global_transform.basis.x.normalized() * bullet_velocity

	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if stairs_ray_cast.is_colliding():
		var collision_point = stairs_ray_cast.get_collision_point()
		var current_position = global_transform.origin
		
		if collision_point.y > current_position.y and collision_point.y - current_position.y < step_height:
			velocity.y = (collision_point.y - current_position.y)/delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	

	move_and_slide()
