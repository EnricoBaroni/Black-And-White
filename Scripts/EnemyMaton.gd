extends "res://Scripts/Enemy.gd"

func _ready():
	pass

func _physics_process(delta):
	match state:
		CHASE:
			chase(player)
		IDLE:
			idle(player)
