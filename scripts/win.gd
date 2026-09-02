extends Node2D


func _ready() -> void:
	$UI.size = get_viewport_rect().size


func _on_btn_back_to_menu_pressed() -> void:
	SFX.play("ui_click")
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
