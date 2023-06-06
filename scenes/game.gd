extends Control


var day = DayOf.Introductions
var day_stage = -1

var study_score = 0
var platypus_score = 0

var informant_status = "alive"

enum Period { Break1, Break2, Break3, Break4, Evening, Night}
enum DayOf { Introductions, Trivia, Feelings, Love }
enum WeAre { Strangers, Acquaintances, Friends, Lovers }

const hate_relationship_id = "hate"
const love_relationship_id = "love"
const unclear_relationship_id = ""

const FRIENDSHIP_THRESHOLD = 4
const LOVE_THRESHOLD = 9
const PLATYPUS_AWARENESS_THRESHOLD = 6
const GREATNESS_BY_STUDY_THRESHOLD = 14

const character_topics = {
	"Alexei": {
		"0": ["Presentarse"],
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
		"0": ["Presentarse"],
		"1": ["Obligaciones", "Tatuajes"],
		"2": ["Bromas", "Vietnam"],
		"3": ["Café", "Paseo"]
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

var char_scores = {
	"Alexei": {"level": 0, "score": 0},
	"Roxxane": {"level": 0, "score": 0},
	"Sharon": {"level": 0, "score": 0},
	"Zachary": {"level": 0, "score": 0},
	"Wai-Ting": {"level": 0, "score": 0},
}

var topics_done = {
	"Alexei": [],
	"Roxxane": [],
	"Sharon": [],
	"Zachary": [],
	"Wai-Ting": [],
}

func _ready():
	randomize()
	hide()
	launch_dialog('N01')


func update_scores():
	time_passes()
	char_scores["Alexei"]["score"] = int(Dialogic.get_variable("ap"))
	char_scores["Roxxane"]["score"] = int(Dialogic.get_variable("rp"))
	char_scores["Sharon"]["score"] = int(Dialogic.get_variable("sp"))
	char_scores["Zachary"]["score"] = int(Dialogic.get_variable("zp"))
	char_scores["Wai-Ting"]["score"] = int(Dialogic.get_variable("wp"))
	for char_name in char_scores.keys():
		if day > DayOf.Introductions:
			char_scores[char_name]["level"] = WeAre.Acquaintances
		if day > DayOf.Trivia and char_scores[char_name]["score"] > FRIENDSHIP_THRESHOLD:
			char_scores[char_name]["level"] = WeAre.Friends
		if day > DayOf.Feelings and char_scores[char_name]["score"] > LOVE_THRESHOLD:
			char_scores[char_name]["level"] = WeAre.Lovers
		
	study_score = int(Dialogic.get_variable("pp"))
	platypus_score = int(Dialogic.get_variable("cp"))
	Music.distorsion_level(platypus_score)
	informant_status = Dialogic.get_variable("informant_status")


func time_passes():
	day_stage += 1
	if day_stage > Period.Night:
		day += 1
		day_stage = Period.Break1
		for char_name in char_scores.keys():
			topics_done[char_name] = []
			Dialogic.set_variable(char_name + "_extracurricular", "")
	print("Scene end. New period -> Day: " + str(day) + ", Period: " + str(day_stage))


func prepare_academy():
	$Popup.hide()
	$"%Characters".hide()
	$"%Study".hide()
	$"%Party".hide()
	$"%GroupRZ".hide()
	$"%GroupASW".hide()
	$"%Extracurricular".hide()
	if day_stage < Period.Evening:
		if day == DayOf.Trivia and day_stage == Period.Break3:
			print("Meetings in groups")
			$"%GroupRZ".show()
			$"%GroupASW".show()
			$"%Study".show()
		elif day > DayOf.Love:
			print("Return to main menu")
			get_tree().change_scene("res://scenes/MainMenu.tscn")
		else:
			print("Standard meetings during breaks")
			$"%Characters".show()
			$"%Study".show()
	elif day_stage == Period.Evening:
		print("Extracurriculars")
		$"%Extracurricular".show()
		if day == DayOf.Introductions:
			print("  - First day party")
			$"%Party".show()
			$"%Study".show()
		elif day == DayOf.Trivia or day == DayOf.Feelings:
			print("  - Evening plans")
			launch_extracurricular_selector()
		elif day == DayOf.Love:
			print("  - Ending")
			launch_ending_selector()
	elif day_stage == Period.Night:
		if day < DayOf.Love:
			print("Informat mail")
			var timeline_name = ""
			if informant_status == "alive":
				timeline_name = "I1" + str(day + 1)
			else:
				timeline_name = "I01"
			launch_dialog(timeline_name)
		elif day == DayOf.Love:
			print("Goodbye dialog")
			launch_dialog("N02")


func fill_debug_panel():
	$"%LEPP".text = Dialogic.get_variable("pp")
	$"%LECP".text = Dialogic.get_variable("cp")
	$"%LEAP".text = Dialogic.get_variable("ap")
	$"%LERP".text = Dialogic.get_variable("rp")
	$"%LESP".text = Dialogic.get_variable("sp")
	$"%LEZP".text = Dialogic.get_variable("zp")
	$"%LEWP".text = Dialogic.get_variable("wp")
	$"%LEIN".text = Dialogic.get_variable("informant_status")


func launch_dialog(timeline_name):
	$Popup.hide()
	$"%Extracurricular".hide()
	hide()
	print("Launching timeline: " + timeline_name)
	var dialog = Dialogic.start(timeline_name)
	dialog.connect("timeline_end", self, "_on_timeline_end")
	add_child(dialog)


func launch_topic(char_name, char_level, topic_idx):
	var timeline_name = char_name[0] + char_level + str(topic_idx + 1)
	topics_done[char_name].append(topic_idx)
	Music.transition_to(char_name)
	launch_dialog(timeline_name)


func _on_timeline_end(_timeline_name):
	update_scores()
	show()
	prepare_academy()
	fill_debug_panel()


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

	if event.is_action_pressed("debug"):
		if $"%DebugPanel".visible:
			$"%DebugPanel".hide()
		else:
			$"%DebugPanel".show()


func _on_WaiTing_pressed():
	launch_topic_selection_popup("Wai-Ting")


func _on_Sharon_pressed():
	launch_topic_selection_popup("Sharon")


func _on_Zachary_pressed():
	launch_topic_selection_popup("Zachary")
	

func _on_Alexei_pressed():
	launch_topic_selection_popup("Alexei")


func _on_Roxxane_pressed():
	launch_topic_selection_popup('Roxxane')


func _on_Study_pressed():
	launch_topic_selection_popup("Study")


func study():
	var rand_n = randi() % 3
	var study_timeline_name = ""
	if day_stage < 4:
		study_timeline_name = "T0" + str(rand_n + 1)
	else:
		study_timeline_name = "T1" + str(rand_n + 1)
	
	launch_dialog(study_timeline_name)


func launch_topic_selection_popup(char_name):
	for item in $"%PopUpOptions".get_children():
		item.queue_free()
	
	if char_name == 'Study':
		$"%PopUpDescription".text = "¿Quieres ir a la biblioteca a estudiar?"
		var button = Button.new()
		button.text = "¡A estudiar!"
		button.connect("pressed", self, "study")
		$"%PopUpOptions".add_child(button)
	else:
		if Dialogic.get_variable(char_name + "_relationship") == hate_relationship_id:
			$"%PopUpDescription".text = char_name + " no quiere volver a hablar contigo nunca."
		else:
			var char_level = str(char_scores[char_name]["level"])
			$"%PopUpDescription".text = "¿De qué te gustaría hablar con " + char_name + "?"
			var char_topics = character_topics[char_name][char_level]
			for topic_idx in range(char_topics.size()):
				if topics_done[char_name].has(topic_idx):
					continue
				var button = Button.new()
				button.text = char_topics[topic_idx]
				button.connect("pressed", self, "launch_topic", [char_name, char_level, topic_idx])
				$"%PopUpOptions".add_child(button)
	$Popup.popup_centered()


func launch_extracurricular_selector():
	for item in $"%ExtracurricularOptions".get_children():
		item.queue_free()
	
	var study_button = Button.new()
	study_button.text = "¡A estudiar!"
	study_button.connect("pressed", self, "study")
	$"%ExtracurricularOptions".add_child(study_button)
	
	for char_name in char_scores.keys():
		if Dialogic.get_variable(char_name + "_extracurricular") != "":
			var button = Button.new()
			button.text = "Pasa tiempo con " + char_name
			var extracurricular_topic_bit = ""
			if day == DayOf.Trivia:
				extracurricular_topic_bit = "1"
			elif day == DayOf.Feelings:
				extracurricular_topic_bit = "2"
			var timeline_name = char_name[0] + "8" + extracurricular_topic_bit
			button.connect("pressed", self, "launch_dialog", [timeline_name])
			$"%ExtracurricularOptions".add_child(button)
	
	$"%Extracurricular".show()


func launch_ending_selector():
	for item in $"%ExtracurricularOptions".get_children():
		item.queue_free()
	
	var timeline_conspiracy_bit = ""
	
	var lovers = []
	for char_name in char_scores.keys():
		if Dialogic.get_variable(char_name + "_relationship") == love_relationship_id:
			timeline_conspiracy_bit = char_name[0] + "9"
			lovers.append(char_name)
	
	if platypus_score >= PLATYPUS_AWARENESS_THRESHOLD:
		timeline_conspiracy_bit = "1"
	else:
		timeline_conspiracy_bit = "2"
	
	if not lovers.empty():
		for char_name in lovers.keys:
			if Dialogic.get_variable(char_name + "") != "":
				var button = Button.new()
				button.text = "Declararte a " + char_name
				var timeline_name = char_name[0] + "9" + timeline_conspiracy_bit
				button.connect("pressed", self, "launch_dialog", [timeline_name])
				$"%ExtracurricularOptions".add_child(button)
	elif study_score >= GREATNESS_BY_STUDY_THRESHOLD:
		var button = Button.new()
		button.text = "Ascender a grandeza"
		var timeline_name = "E2" + timeline_conspiracy_bit
		button.connect("pressed", self, "launch_dialog", [timeline_name])
		$"%ExtracurricularOptions".add_child(button)
	else:
		var button = Button.new()
		button.text = "Vivir una vida tranquila."
		var timeline_name = "E1" + timeline_conspiracy_bit
		button.connect("pressed", self, "launch_dialog", [timeline_name])
		$"%ExtracurricularOptions".add_child(button)
	
	$"%Extracurricular".show()

func _on_Party_pressed():
	launch_dialog("P01")


func _on_GroupRZ_pressed():
	launch_dialog("X01")


func _on_GroupASW_pressed():
	launch_dialog("X02")


func _on_Debug_text_changed(new_text, line_edit_name):
	if line_edit_name == "LEPP": Dialogic.set_variable("pp", new_text)
	if line_edit_name == "LECP": Dialogic.set_variable("cp", new_text)
	if line_edit_name == "LEAP": Dialogic.set_variable("ap", new_text)
	if line_edit_name == "LERP": Dialogic.set_variable("rp", new_text)
	if line_edit_name == "LESP": Dialogic.set_variable("sp", new_text)
	if line_edit_name == "LEZP": Dialogic.set_variable("zp", new_text)
	if line_edit_name == "LEWP": Dialogic.set_variable("wp", new_text)
	if line_edit_name == "LEIN": Dialogic.set_variable("informant_status", new_text)

	#prepare_academy() ?
