extends Spatial

var inside = false
var played = false
onready var colaSound = $AudioStreamPlayer

func _on_Area_area_entered(area):
	inside = true

func _on_Area_area_exited(area):
	inside = false

func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and inside == true and played == false:
		played = true
		$colaBloxy/StaticBody/CollisionShape.disabled = true
		$colaBloxy.visible = false
		colaSound.playing = true
		yield(get_tree().create_timer(1.75), "timeout")
		get_tree().change_scene("res://scenes/level0.tscn")
		colaSound.playing = false
