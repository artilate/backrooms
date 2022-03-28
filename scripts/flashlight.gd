extends MeshInstance

var inside = false

func _on_Area_area_entered(area):
	inside = true

func _on_Area_area_exited(area):
	inside = false

func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and inside == true:
		Main.flashlightObtained = true
		self.visible = false
		$label.visible = true
		yield(get_tree().create_timer(1), "timeout")
		$label.visible = false
