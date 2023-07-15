extends Node3D

var played = false
var counter = 0

@onready var sound = $sound
@onready var player = get_node("../../Player")
@onready var raycast = player.get_node("Head/Camera3D/RayCast3D")
@onready var tableCandle = get_node("../table1/candle2")

func _physics_process(delta):
	if raycast.is_colliding():
		if raycast.get_collider().name == "candleArea" and played == false:
			await get_tree().create_timer(4).timeout
			if raycast.get_collider().name == "candleArea" and played == false:
				played = true
				self.visible = false
				tableCandle.visible = true
				sound.playing = true
				await get_tree().create_timer(4.52).timeout
				sound.playing = false

func _on_raycast_area_entered(area):
	raycast.enabled = true

func _on_raycast_area_exited(area):
	raycast.enabled = false
