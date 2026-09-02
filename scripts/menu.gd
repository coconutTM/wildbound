extends Node2D

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	$UI.size = get_viewport_rect().size

func _on_btn_play_pressed() -> void:
	SFX.play("ui_click")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_btn_exit_pressed() -> void:
	SFX.play("ui_click")
	get_tree().quit()


func _on_btn_credits_pressed() -> void:
	SFX.play("ui_click")
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_texture_button_pressed() -> void:
	pass # Replace with function body.

func _on_btn_sound_toggled(toggled_on: bool) -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus, toggled_on)
