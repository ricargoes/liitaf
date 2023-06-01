extends Control


var study_score = 0

func _ready():
	$Academy.hide()
	launch_dialog('lore_start')

func update_studies_score() -> void:
	get_node("%Score").text = str(study_score)

func _on_dialogic_event(event):
	match event:
		"studies":
			study_score += 1
			Dialogic.set_variable('Studies', study_score)
			update_studies_score()

func _on_Alexei_pressed():
	$Academy.hide()
	launch_dialog('alexei_talking_choice')

func launch_dialog(timeline_name):
	var dialog = Dialogic.start(timeline_name)
	dialog.connect("dialogic_signal", self, "_on_dialogic_event")
	dialog.connect("timeline_end", self, "_on_timeline_end")
	add_child(dialog)

func _on_timeline_end(_timeline_name):
	$Academy.show()
	
func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
