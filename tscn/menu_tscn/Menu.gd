extends Control


func _ready() -> void:
	OS.center_window()


func _on_btnstart_pressed() -> void:
	get_tree().change_scene("res://tscn/main_tscn/main.tscn")
