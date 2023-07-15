extends Sprite3D
@onready var sprite = get_node("../window1")
var played = false

@onready var player = get_node("../Player")
@onready var raycast = player.get_node("Head/Camera3D/RayCast3D")

func _on_Area_area_entered(area):
	await get_tree().create_timer(3).timeout
	if raycast.is_colliding():
		if raycast.get_collider().name == "raycastWindow" and played == false:
			get_tree().change_scene_to_file("res://scenes/level1.tscn")
			if(played == false):
				played = true
				playSound()
				for x in 15:
					sprite.opacity = 0
					await get_tree().create_timer(0.1).timeout
					sprite.opacity = 1
					await get_tree().create_timer(0.1).timeout

func playSound():
	$sound.playing = true
	await get_tree().create_timer(3.0).timeout
	$sound.playing = false


func _on_Area_area_exited(area):
	pass
