class_name Game_Manager
extends Node

enum State { MENU, PLAYING, GAME_OVER, WIN }

signal game_started
signal game_over_triggered
signal game_won

@export var player: Player
@export var stage_manager: Stage_Manager

var state: State = State.MENU

func _ready() -> void:
	player.died.connect(_on_player_died)
	stage_manager.all_stages_completed.connect(_on_all_stages_completed)

func start_game() -> void:
	state = State.PLAYING
	stage_manager.start_stage()
	game_started.emit()

func _on_player_died() -> void:
	game_over()

func game_over() -> void:
	state = State.GAME_OVER
	game_over_triggered.emit()

# สำคัญ: reload_current_scene() จะรีเซ็ต node ทั้งหมดใหม่ (ตรงตาม spec
# "ตาย -> เสียของ/อาวุธทั้งหมด -> เริ่ม Run ใหม่จากศูนย์")
# แต่ reset ได้จริงเฉพาะ Resource ที่ตั้ง "Local to Scene" ไว้ใน inspector เท่านั้น
# ถ้า stats/weapon ของ player เป็น resource ไฟล์เดียวที่ share กับที่อื่น
# ค่า current_health / weapon ที่เปลี่ยนไปตอนเล่นจะ "ค้าง" ข้ามรอบ restart ได้
func restart_game() -> void:
	get_tree().reload_current_scene()

func _on_all_stages_completed() -> void:
	win_game()

func win_game() -> void:
	state = State.WIN
	game_won.emit()
