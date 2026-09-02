class_name Loot
extends Area2D

# component_type ใช้ string ธรรมดา ("wood","stone","bone","fiber")
# ต้องสะกดตรงกับ key ที่ใช้ใน player.components และ weapon_recipe.gd -> cost
# ไม่ทำ enum แยกไฟล์เพราะแค่ 4 ชนิด ไม่คุ้มที่จะเพิ่ม complexity
@export var component_type: String = "wood"
@export var amount: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if not body.has_method("add_component"):
		return

	body.add_component(component_type, amount)
	SFX.play("pickup_loot")
	pickup()

func pickup() -> void:
	queue_free()
