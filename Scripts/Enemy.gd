extends KinematicBody2D

#INICIALIZACIONES Y VARIABLES
#Stats
var type
var health
var maxHealth
var damage
var speed
var fireRate
var maxRange
#Inicializamos para que no sea nunca null
var state = CHASE #Estado con distintas acciones, por defecto que empiecen persiguiendo
var canChangeDirection = true #Para ver si ha pasado el tiempo para cambiar direccion random
var canShoot = true #Si puede volver a disparar
var changeShoot = true #Para ir rotando entre dos disparos del enemigo
var velocity = Vector2.ZERO #Vector dirección + velocidad
var direction = Vector2.ZERO #La direccion del enemigo
var rightDistance = false
#Posibles acciones
enum {
	IDLE,
	CHASE,
	ATTACK
}
#Señales
signal distanciaAlcanzada
#Onreadys Basicos
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree #Animaciones segun direccion
onready var animationState = animationTree.get("parameters/playback") #Asignacion de las animaciones
onready var timerFireRate = $AttackRate
onready var stats = $Stats
onready var pivot = $AttackPosition
#Onready Player para tenerlo todo el rato en la mira
onready var player = get_tree().root.get_child(0).getPlayer()
#Onreadys Ataques
onready var weaponYeah = preload("res://Scenes/WeaponYeah.tscn")
onready var weaponRap = preload("res://Scenes/WeaponRap.tscn")
onready var weaponFuck = preload("res://Scenes/WeaponFuck.tscn")
onready var weaponBicho = preload("res://Scenes/WeaponBicho.tscn")
func _ready():
	initializeStats()
	print_debug(str(type) + "-> Health: " + str(maxHealth) + " / Damage: "  + str(damage) + " / Speed: " + str(speed) + " / FireRate: " + str(fireRate) + " / Range: " + str(maxRange))
	animationTree.active = true #Activamos el movimiento por direccion
#Inicializamos nuestras stats
func initializeStats():
	type = stats.type
	maxHealth = stats.maxHealth
	damage = stats.damage
	speed = stats.speed
	fireRate = stats.fireRate
	maxRange = stats.maxRange

#FUNCIONES DE MOVIMIENTO
#Nos quedamos quietos
func idle(point):
	velocity = Vector2.ZERO
	direction = global_position.direction_to(point.global_position)
	animationTree.set("parameters/Idle/blend_position", direction) #Asignamos la animacion de Quieto
	animationState.travel("Idle") #Usamos la animacion Quieto
#Se persigue al jugador
func chase(point): #Enviamos el punto en el que esta el jugador y delta
	direction = global_position.direction_to(point.global_position) #Nuestra direccion es hacia el jugador	
	velocity = move_and_slide(direction * speed) #Asignamos velocidad y direccion y nos movemos
	movementAnimation(direction)
#Funcion para moverse hacia el jugador (No directo, tiene 180º de libertad, o los que queramos, ahora mismo 45º hacia cada lado)
func runToward(point):
	if canChangeDirection:
		direction = global_position.direction_to(point.global_position) #Nuestra direccion es hacia el jugador
		direction = direction.rotated(rand_range(-PI/2, PI/2)) #Grados de libertad para la direccion. PI/2 = 90, asi que segun ampliemos ira mas o menos directo
		canChangeDirection = false
		$ChangeDirection.start(2)
	velocity = move_and_slide(direction * speed) #Asignamos velocidad y direccion y nos movemos
	movementAnimation(direction)
#Se huye del jugador
func runFrom(point): #Enviamos el punto en el que esta el jugador y delta
	direction = global_position.direction_to(point.global_position) #Nuestra direccion es hacia el jugador
	velocity = move_and_slide(-direction * speed) #Asignamos velocidad y direccion (con - porque va a ser en direccion contraria) y nos movemos
	movementAnimation(direction)
#Funcion comprobar distancia con jugador
func checkDistance(distance):
	print(self.position.distance_to(player.position))
	if self.position.distance_to(player.position) >= distance:
		rightDistance = true
		emit_signal("distanciaAlcanzada")
#ANIMACIONES MOVIMIENTO
func movementAnimation(directionMove):
	animationTree.set("parameters/Idle/blend_position", directionMove) #Asignamos la animacion de Quieto
	animationTree.set("parameters/Move/blend_position", directionMove) #Asignamos la animacion de Moverse
	animationState.travel("Move") #Usamos la animacion Moverse
func attackAnimation(directionMove):
	animationTree.set("parameters/Idle/blend_position", directionMove) #Asignamos la animacion de Quieto
	animationTree.set("parameters/Attack/blend_position", directionMove) #Asignamos la animacion de Moverse
	animationTree.set("parameters/Move/blend_position", directionMove) #Asignamos la animacion de Moverse
	animationState.travel("Attack") #Usamos la animacion Moverse
#FUNCIONES ATAQUE
#Lanzar proyectil
func throw(point):
	if self.name == "Player":
		direction = global_position.direction_to(point)
	else:
		direction = global_position.direction_to(point.global_position) #Nuestra direccion es hacia el jugador
	#direction = Vector2(point.position.x - global_position.x, point.position.y - global_position.y).normalized()
	if canShoot:
		#Instancia proyectil
		var weapon = weaponYeah.instance() #Instanciamos un nuevo arma
		owner.add_child(weapon) #La asignamos al player
		weapon.transform.origin = pivot.global_position #Indicamos posicion inicial que es la del AttackPosition
		weapon.set_collision_mask_bit(3, true) #Busca solo al jugador
		weapon.setDirection(direction) #Indicamos en que direccion debe ir
		#Iniciamos timer firerate para que no pueda volver a disparar hasta que acabe
		timerFireRate.start(fireRate)
		canShoot = false
		#Animacion Ataque que habra que crear y asignar en el animationtree
		attackAnimation(direction)
		state = CHASE
#Invocar bichos
func throwInsects(point):
	direction = global_position.direction_to(point.global_position) #Nuestra direccion es hacia el jugador
	#direction = Vector2(point.position.x - global_position.x, point.position.y - global_position.y).normalized()
	if canShoot:
		#Instancia proyectil
		var weapon = weaponBicho.instance() #Instanciamos un nuevo arma
		get_parent().add_child(weapon) #La asignamos al player
		weapon.transform.origin = pivot.global_position #Indicamos posicion inicial que es la del AttackPosition
		weapon.set_collision_mask_bit(3, true) #Busca solo al jugador
		weapon.setDirection(direction) #Indicamos en que direccion debe ir
		#Iniciamos timer firerate para que no pueda volver a disparar hasta que acabe
		timerFireRate.start(fireRate)
		canShoot = false
		#Animacion Ataque que habra que crear y asignar en el animationtree
	#animationTree.set("parameters/Attack/blend_position", direction) #Asignamos la animacion de Ataque
	#animationState.travel("Attack") #Usamos la animacion Ataque
#Lanzar proyectiles en + (Pongo t porque es lo que mas se asemeja y no da errores)
func throwT():
	if canShoot:
		for n in 4:
			#Instancia proyectil
			var weapon = weaponFuck.instance() #Instanciamos un nuevo arma
			get_parent().add_child(weapon) #La asignamos al player
			weapon.transform.origin = $AttackPosition.global_position #Indicamos posicion inicial que es la del AttackPosition
			weapon.set_collision_mask_bit(3, true) #Busca solo al jugador
			if n == 0:
				weapon.setDirection(Vector2.RIGHT) #Derecha
			elif n == 1:
				weapon.setDirection(Vector2.LEFT) #Izquierda
			elif n == 2:
				weapon.setDirection(Vector2.UP) #Arriba
			elif n == 3:
				weapon.setDirection(Vector2.DOWN) #Abajo
		#Iniciamos timer firerate
		timerFireRate.start(fireRate)
		canShoot = false
		changeShoot = true
#Lanzar proyectiles en X
func throwX():
	if canShoot:
		for n in 4:
			#Instancia proyectil
			var weapon = weaponRap.instance() #Instanciamos un nuevo arma
			get_parent().add_child(weapon) #La asignamos al player
			weapon.transform.origin = $AttackPosition.global_position #Indicamos posicion inicial que es la del AttackPosition
			weapon.set_collision_mask_bit(3, true) #Busca solo al jugador
			if n == 0:
				weapon.setDirection(Vector2(1,1)) #Derecha Abajo
			elif n == 1:
				weapon.setDirection(Vector2(-1,1)) #Izquierda Abajo
			elif n == 2:
				weapon.setDirection(Vector2(-1,-1)) #Izquierda Arriba
			elif n == 3:
				weapon.setDirection(Vector2(1,-1)) #Derecha Arriba
		#Iniciamos timer firerate
		timerFireRate.start(fireRate)
		canShoot = false
		changeShoot = false
#Lanzar proyectiles en todas direcciones
func throwAll():
	if canShoot:
		for n in 8:
			#Instancia proyectil
			var weapon = weaponYeah.instance() #Instanciamos un nuevo arma
			get_parent().add_child(weapon) #La asignamos al player
			weapon.transform.origin = $AttackPosition.global_position #Indicamos posicion inicial que es la del AttackPosition
			weapon.set_collision_mask_bit(3, true) #Busca solo al jugador
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
		#Iniciamos timer firerate
		timerFireRate.start(fireRate)
		canShoot = false
		changeShoot = true
#FUNCIONES PARA LAS SEÑALES DE TIMERS, AREAS...
#Funcion para el firerate
func _on_AttackRate_timeout():
	canShoot = true #Permitimos que vuelva a disparar cuando acaba el tiempo asignado

func _on_Enemy_distanciaAlcanzada():
	state = ATTACK
