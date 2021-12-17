extends Control
#actualizar los elementos del HUD
func update_timer(new_val) -> void:
	$MarginContainer/lbltimer.text = str(new_val)

func update_score(new_val) -> void:
	$MarginContainer/lblscore.text = str(new_val)

func update_level(new_val) -> void:
	$MarginContainer/lbllevel.text = str(new_val)

