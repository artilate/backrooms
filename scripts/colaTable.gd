extends Node3D

var inside = false
var played = false
@onready var colaSound = $AudioStreamPlayer

func _on_Area_area_entered(area):
	inside = true

func _on_Area_area_exited(area):
	inside = false

func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and inside == true and played == false:
		played = true
		$colaBloxy/StaticBody3D/CollisionShape3D.disabled = true
		$colaBloxy.visible = false
		colaSound.playing = true
		await get_tree().create_timer(1.75).timeout
		get_tree().change_scene_to_file("res://scenes/level0.tscn")
		colaSound.playing = false
