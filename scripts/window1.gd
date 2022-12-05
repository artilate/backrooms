extends Sprite3D
onready var sprite = get_node("../window1")
var played = false

onready var player = get_node("../Player")
onready var raycast = player.get_node("Head/Camera/RayCast")

func _on_Area_area_entered(area):
	raycast.enable = true
	if raycast.is_colliding():
		print("OMG COLLIDING")
		if raycast.get_collider().name == "raycastWindow" and played == false:
			get_tree().change_scene("res://scenes/level1.tscn")
			if(played == false):
				played = true
				playSound()
				for x in 15:
					sprite.opacity = 0
					yield(get_tree().create_timer(0.1), "timeout")
					sprite.opacity = 1
					yield(get_tree().create_timer(0.1), "timeout")

func playSound():
	$sound.playing = true
	yield(get_tree().create_timer(3.0), "timeout")
	$sound.playing = false


func _on_Area_area_exited(area):
	raycast.enabled = false
