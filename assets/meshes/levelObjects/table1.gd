extends Spatial

var inside = false
var cutscenePlayed = false

onready var rootNode = get_tree().get_current_scene()
onready var paper = $paper1
onready var cross = $statue1/cross
onready var player = rootNode.get_node("Player")

func _on_Area_area_entered(area):
	inside = true

func _on_Area_area_exited(area):
	inside = false

func _physics_process(delta):
	var rotate = get_node("crossTween")
	var pos = get_node("crossPos")
	var camera = get_node("camTween")
	if Input.is_action_just_pressed("interact") and inside == true and $statue1.visible == true and $candle2.visible == true and cutscenePlayed == false:
		cutscenePlayed = true
		paper.visible = false
		Main.note1 = true
		rootNode.get_node("Player").updateHud()
		yield(get_tree().create_timer(0.75), "timeout")
		player.blackScreen(true)
		yield(get_tree().create_timer(3), "timeout")
		#BETWEEN BLACK SCREENS
		Main.mouse_lock = true
		Main.kbb_lock = true
		player.crosshair(false)
		player.translation = Vector3(8.75, 1.5, -3.125)
		player.rotation_degrees = Vector3(0, 80, 0)
		yield(get_tree().create_timer(1), "timeout")
		player.blackScreen(false)
		yield(get_tree().create_timer(3), "timeout")
		#turns off lights
		yield(get_tree().create_timer(1.5), "timeout")
		for i in rootNode.get_node("lights/bigroomLights").get_children():
			i.get_node("OmniLight").light_energy = 0
		yield(get_tree().create_timer(3), "timeout")
		#camera.interpolate_property(player.get_node("Head/Camera"))
		#cross tween
		pos.interpolate_property(cross, "translation", Vector3(0, 5.233037, 0), Vector3(0, 8, 0), 4, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		pos.start()
		yield(get_tree().create_timer(5.5), "timeout")
		rotate.interpolate_property(cross, "rotation_degrees", Vector3(0, 0, 0), Vector3(-180, 0, 0), 0.35, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		rotate.start()
		yield(get_tree().create_timer(1), "timeout")
		pos.interpolate_property(cross, "translation", Vector3(0, 8, 0), Vector3(0, 5.233037, 0), 0.50, Tween.TRANS_QUINT, Tween.EASE_IN )
		pos.start()
		yield(get_tree().create_timer(0.5), "timeout")
		rootNode.get_node("objects/table1/candle2/OmniLight").visible = false
		rootNode.get_node("objects/table1/candle2/Particles").emitting = false
		yield(get_tree().create_timer(2),"timeout")
		player.blackScreen(true)
		yield(get_tree().create_timer(3), "timeout")
		#SOMETHING HAPPENS LIKE DOOR OPENS AND SUCH
		
		#^^^
		yield(get_tree().create_timer(1), "timeout")
		player.blackScreen(false)
		player.crosshair(true)
		Main.kbb_lock = false
		Main.mouse_lock = false
	elif Input.is_action_just_pressed("interact") and inside == true and cutscenePlayed == false:
		paper.visible = false
		Main.note1 = true
		rootNode.get_node("Player").updateHud()
		yield(get_tree().create_timer(1.5), "timeout")
		for i in rootNode.get_node("lights/bigroomLights").get_children():
			i.get_node("OmniLight").light_energy = 0
		

func openDoor():
	pass
