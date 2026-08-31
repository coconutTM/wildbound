extends Node
class_name Wave_Manager

# WaveManager รู้แค่เรื่องภายใน "wave ปัจจุบัน": spawn enemy ตัวไหน, เหลือกี่ตัว, จบหรือยัง
# ไม่รู้จัก stage อื่น ไม่รู้จัก game state - เรื่องนั้นเป็นหน้าที่ stage_manager / game_manager
# waves ถูกกำหนดจากภายนอก (stage_manager จะ set ค่านี้ก่อนเรียก start_next_wave)

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal all_waves_completed

@export var waves: Array[Wave_Data] = []
@export var spawn_points: Array[Marker2D] = []

var current_wave_index: int = -1
var enemies_alive: int = 0

func start_next_wave() -> void:
	current_wave_index += 1

	if current_wave_index >= waves.size():
		all_waves_completed.emit()
		return

	_spawn_wave(waves[current_wave_index])
	wave_started.emit(current_wave_index + 1)

func _spawn_wave(wave_data: Wave_Data) -> void:
	enemies_alive = wave_data.enemies.size()

	if enemies_alive == 0:
		# wave ว่าง (เผื่อทดสอบ) ถือว่าจบทันที กัน enemies_alive ค้างที่ 0 ไม่ trigger check
		check_wave_complete()
		return

	for i in wave_data.enemies.size():
		_spawn_enemy(wave_data.enemies[i], spawn_points[i % spawn_points.size()])
		await get_tree().create_timer(wave_data.spawn_delay).timeout

func _spawn_enemy(enemy_scene: PackedScene, spawn_point: Marker2D) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position
	enemy.died.connect(_on_enemy_died)
	get_tree().current_scene.add_child(enemy)

func _on_enemy_died() -> void:
	enemies_alive -= 1
	check_wave_complete()

func check_wave_complete() -> void:
	if enemies_alive <= 0:
		end_wave()

func end_wave() -> void:
	wave_completed.emit(current_wave_index + 1)
