extends Node

class_name Stats
#Para el futuro por si queremos que ocurra algo cuando se acabe la vida
signal health_depleted()

export var type : String
export var health : int
export var maxHealth : int setget set_maxHealth
export var damage : float
export var speed : float
export var fireRate : float
export var maxRange : float

#Siempre la vida tendra un minimo de 0
func set_maxHealth(value):
	maxHealth = max(0, value)
func set_health(value):
	maxHealth = max(0, value)

#Getters para obtener la stat. Necesarios????
#func get_type():
#	return type
#func get_health():
#	return health
#func get_maxHealth():
#	return maxHealth
#func get_damage():
#	return damage
#func get_speed():
#	return speed
#func get_fireRate():
#	return fireRate
#func get_maxRange():
#	return maxRange


#Funcion de recibir daño
func take_damage(hit):
	print_debug(str(type) + "recibe DMG: " + str(hit) + " -> HP: " + str(health))
	health -= hit
	health = max(0, health)
	if health == 0:
		emit_signal("health_depleted")
	return health
