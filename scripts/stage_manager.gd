
class_name Stage_Manager
extends Node

signal stage_started(stage_number: int)
signal stage_completed(stage_number: int)
signal all_stages_completed

@export var wave_manager: Wave_Manager
@export var stages: Array[Stage_Data] = []
@export var map_container: Node2D
@export var player: Player

var current_stage_index: int = -1
var current_map: Node = null

func _ready() -> void:
	wave_manager.all_waves_completed.connect(_on_all_waves_completed)
	wave_manager.wave_completed.connect(_on_wave_completed)

func start_stage() -> void:
	current_stage_index += 1

	if current_stage_index >= stages.size():
		all_stages_completed.emit()
		return

	_load_map(stages[current_stage_index])

	wave_manager.waves = stages[current_stage_index].waves
	wave_manager.current_wave_index = -1

	print("Stage %d started" % (current_stage_index + 1))
	stage_started.emit(current_stage_index + 1)
	start_next_wave()

func _load_map(stage_data: Stage_Data) -> void:
	if current_map:
		current_map.queue_free()

	current_map = stage_data.map_scene.instantiate()
	map_container.add_child(current_map)

	var spawn_points_node := current_map.get_node("SpawnPoints")
	var points: Array[Marker2D] = []
	for child in spawn_points_node.get_children():
		if child is Marker2D:
			points.append(child)
	wave_manager.spawn_points = points

	var player_start := current_map.get_node("PlayerStart") as Marker2D
	if player_start and player:
		player.global_position = player_start.global_position

func start_next_wave() -> void:
	wave_manager.start_next_wave()

func _on_all_waves_completed() -> void:
	complete_stage()

func _on_wave_completed(_wave_number: int) -> void:
	start_next_wave()

func complete_stage() -> void:
	print("Stage %d complete" % (current_stage_index + 1))
	stage_completed.emit(current_stage_index + 1)
	load_next_stage()

func load_next_stage() -> void:
	start_stage()
