class_name Stage_Manager
extends Node

# StageManager จัดลำดับ stage เท่านั้น ไม่ spawn enemy เอง (ให้ wave_manager ทำ)
# แค่ "ยัด" ชุด wave ของ stage ปัจจุบันเข้าไปใน wave_manager แล้วสั่งเริ่ม

signal stage_started(stage_number: int)
signal stage_completed(stage_number: int)
signal all_stages_completed

@export var wave_manager: Wave_Manager
@export var stages: Array[Stage_Data] = []

var current_stage_index: int = -1

func _ready() -> void:
	wave_manager.all_waves_completed.connect(_on_all_waves_completed)

func start_stage() -> void:
	current_stage_index += 1

	if current_stage_index >= stages.size():
		all_stages_completed.emit()
		return

	wave_manager.waves = stages[current_stage_index].waves
	wave_manager.current_wave_index = -1

	stage_started.emit(current_stage_index + 1)
	start_next_wave()

func start_next_wave() -> void:
	wave_manager.start_next_wave()

func _on_all_waves_completed() -> void:
	complete_stage()

func complete_stage() -> void:
	stage_completed.emit(current_stage_index + 1)
	load_next_stage()

func load_next_stage() -> void:
	start_stage()
