extends "res://Scripts/Enemy.gd"

func _ready():
	pass

func _physics_process(delta):
	match state:
		CHASE:
			idle(player)
			throwInsects(player)
		IDLE:
			idle(player)
