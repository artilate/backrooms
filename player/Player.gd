extends KinematicBody

var speed = 6
var normal_speed = speed
var walk_speed = speed/2.5
const ACCEL_DEFAULT = 10
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = 0.15
var zoom_sense = mouse_sense/2.5
var normal_sense = mouse_sense
var zoom
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var light = $Head/Camera/Flashlight
onready var raycast = $Head/Camera/RayCast

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		if zoom == true:
			rotate_y(deg2rad(-event.relative.x * zoom_sense))
			head.rotate_x(deg2rad(-event.relative.y * zoom_sense))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		else:
			rotate_y(deg2rad(-event.relative.x * normal_sense))
			head.rotate_x(deg2rad(-event.relative.y * normal_sense))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	snap = Vector3.ZERO
	#	gravity_vec = Vector3.UP * jump
	
	#change mouse sensitivty
	if Input.is_action_just_pressed("sense_up"):
		mouse_sense = mouse_sense + 0.025
		zoom_sense = mouse_sense/2.5
		normal_sense = mouse_sense
	if Input.is_action_just_pressed("sense_down"):
		if(mouse_sense > 0.025):
			mouse_sense = mouse_sense - 0.025
			zoom_sense = mouse_sense/2.5
			normal_sense = mouse_sense
	
	#camera zoom 
	var tween = get_node("cameraZoom")
	if Input.is_action_just_pressed("zoom"):
		zoom = true
		tween.interpolate_property(camera, "fov", 70, 20, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
		tween.start()
	if Input.is_action_just_released("zoom"):
		zoom = false
		tween.interpolate_property(camera, "fov", 20, 70, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
		tween.start()

	#flashlight
	if Input.is_action_just_pressed("flashlight") and Main.flashlightObtained == true:
		if light.light_energy == 0.5:
			light.light_energy = 0
		else:
			light.light_energy = 0.5

	#make it move
	if Input.is_action_just_pressed("walk"):
		speed = walk_speed
	if Input.is_action_just_released("walk"):
		speed = normal_speed
	
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
