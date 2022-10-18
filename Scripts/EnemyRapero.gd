extends "res://Scripts/Enemy.gd"

func _ready():
	pass

func _physics_process(delta):
	match state:
		CHASE:
			runToward(player)
			if changeShoot: #Un true/false para que vaya rotando entre dos disparos. Podria variar entre mas otra variable con mas posibilidades
				throwX()
			else:
				throwT()
		IDLE:
			idle(player)

func _on_ChangeDirection_timeout():
	canChangeDirection = true
