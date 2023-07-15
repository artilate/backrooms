extends Node3D

func _ready():
	$Roof.visible = true
	$lightFolder/Light1.lightFlicker()
	showFlashlight()

func showFlashlight():
	if Main.flashlightObtained == true:
		await get_tree().create_timer(1).timeout
		$tutFlash.visible = true
		await get_tree().create_timer(1).timeout
		$tutFlash.visible = false
