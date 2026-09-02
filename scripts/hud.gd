class_name HUD
extends CanvasLayer

## ผูกใน editor: ลาก node Player/Stage_Manager/Wave_Manager เข้ามาใส่ export พวกนี้
@export var player: Player
@export var stage_manager: Stage_Manager
@export var wave_manager: Wave_Manager

@onready var health_bar: ProgressBar = $Control/HealthPanel/HealthBar
@onready var health_label: Label = $Control/HealthPanel/HealthLabel
@onready var weapon_label: Label = $Control/HealthPanel/WeaponLabel
@onready var wood_label: Label = $Control/ComponentsPanel/WoodLabel
@onready var stone_label: Label = $Control/ComponentsPanel/StoneLabel
@onready var bone_label: Label = $Control/ComponentsPanel/BoneLabel
@onready var fiber_label: Label = $Control/ComponentsPanel/FiberLabel
@onready var stage_wave_label: Label = $Control/StageWaveLabel


func _ready() -> void:
	$Control.size = $Control.get_viewport_rect().size

	player.stats.health_changed.connect(_on_health_changed)
	player.weapon_changed.connect(_on_weapon_changed)
	player.components_changed.connect(_on_components_changed)
	stage_manager.stage_started.connect(_on_stage_or_wave_changed)
	wave_manager.wave_started.connect(_on_stage_or_wave_changed)

	# เซ็ตค่าเริ่มต้นทันทีตอนเข้าเกม ไม่ต้องรอ signal แรกยิง
	# (กัน race condition ตอน stats.initialize_stats() เป็น call_deferred)
	_on_health_changed(player.stats.current_health, player.stats.max_health)
	_on_weapon_changed()
	_on_components_changed()
	_on_stage_or_wave_changed()


func _on_health_changed(current_health: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = "%d / %d" % [current_health, max_health]


func _on_weapon_changed() -> void:
	weapon_label.text = "Weapon: %s" % player.stats.weapon.weapon_name if player.stats.weapon else "Weapon: -"


func _on_components_changed() -> void:
	wood_label.text = "Wood: %d" % player.components.get("wood", 0)
	stone_label.text = "Stone: %d" % player.components.get("stone", 0)
	bone_label.text = "Bone: %d" % player.components.get("bone", 0)
	fiber_label.text = "Fiber: %d" % player.components.get("fiber", 0)


# ใช้ handler เดียวรับได้ทั้ง stage_started(int) และ wave_started(int)
# (ใส่ default value ให้ arg เผื่อเรียกเองตอน _ready() แบบไม่มี arg ด้วย)
func _on_stage_or_wave_changed(_unused: int = 0) -> void:
	var stage_num := stage_manager.current_stage_index + 1
	var stage_total := stage_manager.stages.size()
	var wave_num := wave_manager.current_wave_index + 1
	var wave_total := wave_manager.waves.size()
	stage_wave_label.text = "Stage %d/%d   Wave %d/%d" % [stage_num, stage_total, wave_num, wave_total]
