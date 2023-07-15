extends CharacterBody3D

var speed = 6
var normal_speed = speed
var walk_speed = speed/2.5
const ACCEL_DEFAULT = 10
const ACCEL_AIR = 1
@onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = 0.15
var zoom_sense = mouse_sense/2.5
var normal_sense = mouse_sense
var zoom : bool
var snap
var mouse_capture : bool

var direction = Vector3()
var gravity_direction = Vector3()
var movement = Vector3()

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var light = $Head/Camera3D/Flashlight
@onready var raycast = $Head/Camera3D/RayCast3D

var maximize = false

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_capture = true
	#makes windowed maximized, mainly usefull for testing purposes
	if maximize == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion and Main.mouse_lock == false:
		if zoom == true:
			rotate_y(deg_to_rad(-event.relative.x * zoom_sense))
			head.rotate_x(deg_to_rad(-event.relative.y * zoom_sense))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		else:
			rotate_y(deg_to_rad(-event.relative.x * normal_sense))
			head.rotate_x(deg_to_rad(-event.relative.y * normal_sense))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.physics_ticks_per_second:
		camera.set_as_top_level(true)
		camera.global_transform.origin = camera.global_transform.origin.lerp(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_top_level(false)
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
		gravity_direction = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_direction += Vector3.DOWN * gravity * delta
		
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	snap = Vector3.ZERO
	#	gravity_vec = Vector3.UP * jump
	
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
	
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

	if Main.mouse_lock == false:
		var tween = get_tree().create_tween()
		if Input.is_action_just_pressed("zoom"):
			zoom = true
			tween.tween_property(camera, "fov", 20, 0.5).from(70).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			#tween.start()
		if Input.is_action_just_released("zoom"):
			zoom = false
			tween.tween_property(camera, "fov", 70, 0.5).from(20).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			#tween.start()

	#flashlight
	if Input.is_action_just_pressed("flashlight") and Main.flashlightObtained == true:
		if light.light_energy > 0:
			light.light_energy = 0
		else:
			light.light_energy = 0.75

	#make it move
	if Input.is_action_just_pressed("walk"):
		speed = walk_speed
	if Input.is_action_just_released("walk"):
		speed = normal_speed
	
	#unlock/lock mouse
	if Input.is_action_just_pressed("mouseLock"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_capture = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse_capture == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_capture = true

	velocity = velocity.lerp(direction * speed, accel * delta)
	movement = velocity + gravity_direction
	
	if Main.kbb_lock == false:
		set_velocity(movement)
		# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `snap`
		set_up_direction(Vector3.UP)
		move_and_slide()

func updateHud():
	if Main.note1 == true:
		$hud/note1.visible = true

func blackScreen(value):
	var tween = $blackTween
	var black = $blackScreen
	if value == true:
		tween.interpolate_property(black, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 3, Tween.TRANS_LINEAR)
		tween.start()
		await get_tree().create_timer(.05).timeout
		black.visible = true
	if value == false:
		tween.interpolate_property(black, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 3, Tween.TRANS_LINEAR)
		tween.start()
		await get_tree().create_timer(.05).timeout
		black.visible = true

func crosshair(value):
	var cross = $Head/Camera3D/TextureRect
	if value == true:
		cross.visible = true
	if value == false:
		cross.visible = false
