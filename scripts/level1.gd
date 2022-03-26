extends Spatial

func _ready():
	$Roof.visible = true
	$lightFolder/Light1.lightFlicker()
