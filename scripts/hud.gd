class_name HUD
extends CanvasLayer

## ผูกใน editor: ลาก node Player เข้ามาใส่ export นี้
@export var player: Player

@onready var health_bar: ProgressBar = $Control/HealthPanel/HealthBar
@onready var health_label: Label = $Control/HealthPanel/HealthLabel
@onready var weapon_label: Label = $Control/HealthPanel/WeaponLabel
@onready var wood_label: Label = $Control/ComponentsPanel/WoodLabel
@onready var stone_label: Label = $Control/ComponentsPanel/StoneLabel
@onready var bone_label: Label = $Control/ComponentsPanel/BoneLabel
@onready var fiber_label: Label = $Control/ComponentsPanel/FiberLabel


func _ready() -> void:
	$Control.size = $Control.get_viewport_rect().size

	player.stats.health_changed.connect(_on_health_changed)
	player.weapon_changed.connect(_on_weapon_changed)
	player.components_changed.connect(_on_components_changed)

	# เซ็ตค่าเริ่มต้นทันทีตอนเข้าเกม ไม่ต้องรอ signal แรกยิง
	# (กัน race condition ตอน stats.initialize_stats() เป็น call_deferred)
	_on_health_changed(player.stats.current_health, player.stats.max_health)
	_on_weapon_changed()
	_on_components_changed()


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
