extends Node

var current_track = "Base"

func transition_to(new_track):
	get_node(current_track).volume_db = -80
	get_node(new_track).volume_db = 0
	current_track = new_track
	
func distorsion_level(new_level):
	$Distorsion.volume_db = -30 + new_level*4
