extends CenterContainer


func _on_NewGame_pressed():
	Dialogic.reset_saves()
	Dialogic.set_variable("pc_name", $"%PCName".text)
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_Continue_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()
