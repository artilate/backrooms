extends Node3D

func _ready():
	$Roof.visible = true
	$lights/light.lightFlicker()
	$WorldEnvironment.environment.ambient_light_color = Color("#2c2c2c")
	#$WorldEnvironment.environment.ambient_light_energy = 0.05
	$WorldEnvironment.environment.ambient_light_energy = 0
	showFlashlight()


func showFlashlight():
	if Main.flashlightObtained == true:
		await get_tree().create_timer(1).timeout
		$tutFlash.visible = true
		await get_tree().create_timer(1).timeout
		$tutFlash.visible = false
