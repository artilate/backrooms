extends Node3D

var inside = false
@onready var image = $interactIndicator
@onready var player = get_node("../../Player")
@onready var head = player.get_node("Head")

func _on_Area_area_entered(area):
	inside = true

func _on_Area_area_exited(area):
	inside = false

func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and inside == true:
		self.visible = false
		get_tree().get_current_scene().get_node("objects/table1/statue1").visible = true
	image.global_rotation.x = head.rotation.x
	image.global_rotation.y = player.rotation.y
