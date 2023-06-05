extends Control


var day = 0

var study_score = 0
var platypus_score = 0

var informant_status = "alive"

var char_scores = {
	"Alexei": {"level": 0, "score": 0},
	"Roxxane": {"level": 0, "score": 0},
	"Sharon": {"level": 0, "score": 0},
	"Zachary": {"level": 0, "score": 0},
	"Wai-Ting": {"level": 0, "score": 0},
}

var character_topics = {
	"Alexei": {
		"0": ["Intruducción"],
		"1": ["Novatos", "Mancuerna"],
		"2": ["Estándares", "Fracaso"],
		"3": ["Fútbol", "Rosas"]
	},
	"Roxxane": {
		"0": ["Presentarse"],
		"1": ["Bajo", "Banda"],
		"2": ["Lluvia", "Megafonía"],
		"3": ["Reformas", "Conflicto"]
	},
	"Sharon": {
		"0": ["Intruducción"],
		"1": ["Obligaciones", "Tatuajes"],
		"2": ["Bromas", "Vietnam"],
		"3": ["Declaración", "Paseo"]
	},
	"Zachary": {
		"0": ["Presentarse"],
		"1": ["Atalaya", "Actor"],
		"2": ["Sensible", "Debilidad"],
		"3": ["Sumisión", "Ira"]
	},
	"Wai-Ting": {
		"0": ["Intruducción"],
		"1": ["Brazo", "Experimentos"],
		"2": ["Ineptitud social", "Ciencia"],
		"3": ["Excitación", "Inhibiciones"]
	},
}

var LEVEL_2_SCORE = 5
var LEVEL_3_SCORE = 10

func _ready():
	$Academy.hide()
	launch_dialog('N01')


func update_scores():
	char_scores["Alexei"]["score"] = Dialogic.get_variable("ap")
	char_scores["Roxxane"]["score"] = Dialogic.get_variable("rp")
	char_scores["Sharon"]["score"] = Dialogic.get_variable("sp")
	char_scores["Zachary"]["score"] = Dialogic.get_variable("zp")
	char_scores["Wai-Ting"]["score"] = Dialogic.get_variable("wp")
	for char_name in char_scores.keys():
		if day > 0:
			char_scores[char_name]["level"] = 1
		if day > 1 and char_scores[char_name]["score"] > LEVEL_2_SCORE:
			char_scores[char_name]["level"] = 2
		if day > 0 and char_scores[char_name]["score"] > LEVEL_3_SCORE:
			char_scores[char_name]["level"] = 3
		
	study_score = Dialogic.get_variable("pp")
	platypus_score = Dialogic.get_variable("cp")
	informant_status = Dialogic.get_variable("informant_status")


func launch_dialog(timeline_name):
	$Popup.hide()
	$Academy.hide()
	var dialog = Dialogic.start(timeline_name)
	dialog.connect("dialogic_signal", self, "_on_dialogic_event")
	add_child(dialog)
	yield(dialog, "timeline_end")
	$Academy.show()


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()


func _on_WaiTing_pressed():
	launch_selection_popup("Wai-Ting")


func _on_Sharon_pressed():
	launch_selection_popup("Sharon")


func _on_Zachary_pressed():
	launch_selection_popup("Zachary")
	

func _on_Alexei_pressed():
	launch_selection_popup("Alexei")


func _on_Roxxane_pressed():
	launch_selection_popup('Roxxane')

func launch_selection_popup(char_name):
	for item in $"%PopUpOptions".get_children():
		item.queue_free()
	
	var char_level = str(char_scores[char_name]["level"])
	$"%PopUpDescription".text = "¿De qué te gustaría hablar con " + char_name + "?"
	var char_topics = character_topics[char_name][char_level]
	for topic_idx in range(char_topics.size()):
		var button = Button.new()
		button.name = str(topic_idx)
		button.text = char_topics[topic_idx]
		var timeline_name = char_name[0] + char_level + str(topic_idx + 1)
		print(timeline_name)
		button.connect("pressed", self, "launch_dialog", [timeline_name])
		$"%PopUpOptions".add_child(button)
	$Popup.popup_centered()
	
