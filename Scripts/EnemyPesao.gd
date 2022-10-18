extends "res://Scripts/Enemy.gd"

func _ready():
	pass

func _physics_process(delta):
	match state:
		CHASE:
			runFrom(player)
			checkDistance(175) #Solo dispara cuando esta a mas de esta distancia
		IDLE:
			idle(player)
		ATTACK:
			throw(player)
