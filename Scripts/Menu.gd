extends Node2D

func getPlayer():
	return $Player

func _on_World_pressed():
	get_tree().change_scene("res://Levels/World.tscn")

func _on_Level2_pressed():
	get_tree().change_scene("res://Levels/Level2.tscn")

func _on_Button_pressed():
	get_tree().quit()

func _physics_process(delta):
	if Input.is_action_pressed("CloseGame"):
		get_tree().quit()
