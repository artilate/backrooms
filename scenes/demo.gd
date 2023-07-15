extends Node3D

@onready var player = $Player
var tutPlayed = false

func _ready():
	$Roof.visible = true
	self.visible = true
	load("res://scenes/level0.tscn")
	#enabled raycast for this level, could be performance impacting
	player.raycast.enabled = true


func _on_tutArea_area_entered(area):
	if tutPlayed == false:
		tutPlayed = true
		$tutArea/tutLabel.visible = true
		await get_tree().create_timer(1).timeout
		$tutArea/tutLabel.visible = false
