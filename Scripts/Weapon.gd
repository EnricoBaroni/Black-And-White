extends Area2D

var type
var health
var maxHealth
var damage
var speed
var fireRate
var maxRange

onready var direction = Vector2.ZERO #En principio no tiene direccion hasta que se asigne
onready var stats = $Stats #Obtenemos las stats del arma
onready var distance = stats.maxRange #Stat para medir la distancia
onready var player = get_tree().root.get_child(0).getPlayer() #Obtenemos el GamePlayer para que siempre tengamos su node
func _ready():
	initializeStats()
	$AnimationPlayer.play("Play")

func _physics_process(delta):
	global_position += direction * delta
	distance -= 1
	if distance == 0:
		queue_free()
#Inicializamos nuestras stats
func initializeStats():
	type = stats.type
	maxHealth = stats.maxHealth
	damage = stats.damage
	speed = stats.speed
	fireRate = stats.fireRate
	maxRange = stats.maxRange
#Ajustamos la direccion a la que le añadimos velocidad de proyectil
func setDirection(directionVectorSet):
	direction = directionVectorSet * speed

#Se elimina si sale muy lejos de la pantalla
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#Para obtener el daño que hace el arma
func getDamage():
	return stats.damage
