extends "res://Scripts/Enemy.gd"

var directionP = Vector2()
onready var speedwalk = stats.speed
onready var speedrun = stats.speed * 2
onready var animationPlayerP = $AnimationPlayer

func _physics_process(delta):
	Inputs(delta)
	look_at_mouse()

func Inputs(delta):
	directionP = Vector2(0,0)
	if Input.is_action_pressed("ui_left"):
		directionP.x = -1
	if Input.is_action_pressed("ui_right"):
		directionP.x = 1
	if Input.is_action_pressed("ui_up"):
		directionP.y = -1
	if Input.is_action_pressed("ui_down"):
		directionP.y = 1
	directionP = directionP.normalized()
	#Cambio de velocidades segun si anda o corre (Correr en el futuro sera velocidad voltereta o algo asi)
	if Input.is_action_pressed("ui_run"):
		speed = speedrun
	else:
		speed = speedwalk
	directionP = move_and_slide(directionP * speed)
	if Input.is_action_pressed("ShootSkill"):
		throw(get_global_mouse_position())
#El jugador siempre mira hacia el mouse, se mueva o no
func look_at_mouse():
	var mousePosition = get_global_mouse_position()
	if self.get_angle_to(mousePosition) > -0.75 and self.get_angle_to(mousePosition) < 0.75: #Derecha
		pivot.position = Vector2(15,0)
		if directionP == Vector2(0,0):
			animationPlayerP.play("idleRight")
		else:
			animationPlayerP.play("moveRight")
	elif self.get_angle_to(mousePosition) > 2.25 and self.get_angle_to(mousePosition) < 3.15 or self.get_angle_to(mousePosition) < -2.25 and self.get_angle_to(mousePosition) > -3.15: #Izquierda
		pivot.position = Vector2(-15,0)
		if directionP == Vector2(0,0):
			animationPlayerP.play("idleLeft")
		else:
			animationPlayerP.play("moveLeft")
	elif self.get_angle_to(mousePosition) > -2.25 and self.get_angle_to(mousePosition) < -0.75: #Arriba
		pivot.position = Vector2(0,-15)
		if directionP == Vector2(0,0):
			animationPlayerP.play("idleUp")
		else:
			animationPlayerP.play("moveUp")
	elif self.get_angle_to(mousePosition) > 0.75 and self.get_angle_to(mousePosition) < 2.25: #Abajo
		pivot.position = Vector2(0,15)
		if directionP == Vector2(0,0):
			animationPlayerP.play("idleDown")
		else:
			animationPlayerP.play("moveDown")
	
	#Esto hace una animacionde girar como si recargaras el arma sobre el dedo
	#get_node("Pivot/Weapon").rotation_degrees += 42

func shootYeah():
	for n in 8:
		#Instancia proyectil
		var weapon = weaponYeah.instance() #Instanciamos un nuevo arma
		owner.add_child(weapon) #La asignamos al player
		weapon.transform.origin = pivot.global_position #Indicamos posicion inicial que es la del AttackPosition
		if n == 0:
			weapon.setDirection(Vector2.RIGHT) #Derecha
		elif n == 1:
			weapon.setDirection(Vector2.LEFT) #Izquierda
		elif n == 2:
			weapon.setDirection(Vector2.UP) #Arriba
		elif n == 3:
			weapon.setDirection(Vector2.DOWN) #Abajo
		elif n == 4:
			weapon.setDirection(Vector2(1,1)) #Derecha Abajo
		elif n == 5:
			weapon.setDirection(Vector2(-1,1)) #Izquierda Abajo
		elif n == 6:
			weapon.setDirection(Vector2(-1,-1)) #Izquierda Arriba
		elif n == 7:
			weapon.setDirection(Vector2(1,-1)) #Derecha Arriba

func _on_Button_pressed():
	get_tree().change_scene("res://Levels/Menu.tscn")
