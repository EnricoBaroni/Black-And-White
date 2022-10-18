extends Node2D

func _physics_process(delta):
	if Input.is_action_pressed("CloseGame"):
		get_tree().quit()

func _on_Area2D_body_entered(body):
	#get_tree().change_scene("res://Scenes/Menu.tscn")
	get_node("YSort/Player").position = Vector2(1698,630)
