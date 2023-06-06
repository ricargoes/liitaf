extends Node

var current_track = "Base"

func transition_to(new_track):
	get_node(current_track).volume_db = -80
	get_node(new_track).volume_db = -20
	current_track = new_track
	
func distorsion_level(new_level):
	var fl = -80
	if new_level > 0:
		fl = -20 + (-40/new_level)
	$Distorsion.volume_db = fl
