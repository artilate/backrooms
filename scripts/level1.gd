extends Spatial

func _ready():
	$Roof.visible = true
	$lightFolder/Light1.lightFlicker()
	showFlashlight()

func showFlashlight():
	if Main.flashlightObtained == true:
		yield(get_tree().create_timer(1), "timeout")
		$tutFlash.visible = true
		yield(get_tree().create_timer(1), "timeout")
		$tutFlash.visible = false
