extends CenterContainer


func _on_NewGame_pressed():
	Dialogic.set_variable("pc_name", $"%PCName".text)
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_Continue_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_RunScene_pressed():
	hide()
	var timeline_id = get_node("%ScenePicker").text
	Dialogic.set_variable("pc_name", $"%PCName".text)
	var dialog = Dialogic.start(timeline_id)
	add_child(dialog)
	yield(dialog, "timeline_end")
	show()
