extends CharacterBody3D


var SPEED := 5.0
const JUMP_VELOCITY := 4.5
var mouse_sensitivity := 0.05
var twist_input := 0.0
var pitch_input := 0.0
var bullet_scene = load("res://bullet.tscn")
#@onready var gun = $player/
var instance


@onready var gun_barrel = $camera_mount/gun/RayCast3D
@onready var bullet = $camera_mount/gun/bullet
@onready var gun_anim = $camera_mount/gun/AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$camera_mount/tpcam.make_current()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sensitivity))
		$camera_mount.rotate_x(deg_to_rad(-event.relative.y*mouse_sensitivity))
		#$gun.rotate_x(deg_to_rad(-event.relative.y*mouse_sensitivity))
		$camera_mount.rotation.x = clamp($camera_mount.rotation.x, -0.5, 0.5)
		#$gun.rotation.x = clamp($gun.rotation.x, -0.5, 0.5)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("switch_cam"):
		if $camera_mount/tpcam.is_current():
			$camera_mount/fpcam.make_current()
		else:
			$camera_mount/tpcam.make_current()
	if Input.is_action_just_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			instance = bullet_scene.instantiate()
			instance.visible = true
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
	if Input.is_action_just_pressed("focus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_pressed("sprint"):
		SPEED = 8.0
	else:
		SPEED = 5.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED , delta * 2)
		velocity.z = lerp(velocity.z, direction.z * SPEED , delta * 2)

	twist_input = 0.0
	pitch_input = 0.0

	move_and_slide()
