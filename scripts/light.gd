extends MeshInstance3D

@onready var light = $OmniLight3D

func _ready():
	pass

func lightFlicker():
	while true:
		light.light_energy = 1
		await get_tree().create_timer(1).timeout
		light.light_energy = 0
		await get_tree().create_timer(0.25).timeout
		light.light_energy = 1
		await get_tree().create_timer(0.66).timeout
		light.light_energy = 0
		await get_tree().create_timer(0.5).timeout
