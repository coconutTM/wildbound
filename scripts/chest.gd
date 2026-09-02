class_name Chest
extends Area2D

@export var loot_scene: PackedScene
@export var min_drops: int = 2
@export var max_drops: int = 3
@export var possible_components: Array[String] = ["wood", "stone", "bone", "fiber"]

var opened: bool = false
var player_in_range: Node2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body

func _on_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null

# ต้องเพิ่ม action "interact" ใน Project > Project Settings > Input Map ก่อน (เช่น bind คีย์ E)
func _unhandled_input(event: InputEvent) -> void:
	if opened or not player_in_range:
		return
	if event.is_action_pressed("interact"):
		open()

func open() -> void:
	if opened:
		return
	opened = true
	SFX.play("chest_open")
	drop_loot()
	queue_free()  # ถ้าอยากให้กล่องค้างอยู่ในฉากแบบ "เปิดแล้ว" ให้เปลี่ยนเป็นสลับ sprite แทน queue_free()

func drop_loot() -> void:
	var drop_count := randi_range(min_drops, max_drops)

	for i in drop_count:
		var loot: Loot = loot_scene.instantiate()
		loot.component_type = possible_components[randi() % possible_components.size()]
		loot.amount = 1
		loot.global_position = global_position + Vector2(randi_range(-16, 16), randi_range(-16, 16))
		get_tree().current_scene.add_child(loot)
