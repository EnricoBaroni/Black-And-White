extends Node2D

onready var buttonQ = $InterfazPlayer/ButtonQ
onready var buttonE = $InterfazPlayer/ButtonE
onready var buttonF = $InterfazPlayer/ButtonF
onready var timerQ = $InterfazPlayer/ButtonQ/TimerQ
onready var timerE = $InterfazPlayer/ButtonE/TimerE
onready var timerF = $InterfazPlayer/ButtonF/TimerF
onready var lifeBar = $InterfazPlayer/LifeBar


func _physics_process(delta):
	setButtonTimers()
	checkButtons()

#Funcion para obtener en todo momento el nodo del jugador
func getPlayer():
	return $Player

#Acciones para Q/E/F
func QActions():
	timerQ.start()
	get_node("Player").shootYeah()
	lifeBar.value -= 1
func EActions():
	timerE.start()
	lifeBar.value -= 3
func FActions():
	timerF.start()
	lifeBar.value -= 5



#Pone el tiempo que queda en los botones en tiempo real
func setButtonTimers():
	if timerQ.time_left > 0:
		buttonQ.text = str(round(timerQ.time_left))
		buttonQ.disabled = true
	if timerE.time_left > 0:
		buttonE.text = str(round(timerE.time_left))
		buttonE.disabled = true
	if timerF.time_left > 0:
		buttonF.text = str(round(timerF.time_left))
		buttonF.disabled = true

#Boton para volver al menu
func _on_Menu_pressed():
	get_tree().change_scene("res://Levels/Menu.tscn")

#Si pulsan los botones en pantalla
func _on_ButtonQ_pressed():
	QActions()
func _on_ButtonE_pressed():
	EActions()
func _on_ButtonF_pressed():
	FActions()
#Comprueba si se ha pulsado algun boton de skill
func checkButtons():
	if Input.is_action_pressed("QSkill") and buttonQ.disabled == false:
		QActions()
	if Input.is_action_pressed("ESkill") and buttonE.disabled == false:
		EActions()
	if Input.is_action_pressed("FSkill") and buttonF.disabled == false:
		FActions()

#Si se acaban los timers de cooldown se vuelve a poner la letra, meter aqui animaciones futuras indicar fin cooldown
func _on_TimerQ_timeout():
	buttonQ.text = "Q"
	buttonQ.disabled = false
func _on_TimerE_timeout():
	buttonE.text = "E"
	buttonE.disabled = false
func _on_TimerF_timeout():
	buttonF.text = "F"
	buttonF.disabled = false
