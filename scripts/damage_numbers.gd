extends Node

# Autoload (singleton) ชื่อ "DamageNumbers"
# เรียกจากที่ไหนก็ได้: DamageNumbers.spawn(5, global_position, Color.RED)

const DAMAGE_NUMBER_SCENE := preload("res://scenes/damage_number.tscn")


func spawn(amount: int, world_position: Vector2, color: Color = Color.WHITE) -> void:
	var label: Label = DAMAGE_NUMBER_SCENE.instantiate()
	get_tree().current_scene.add_child(label)

	# สุ่มตำแหน่งแนวนอนเล็กน้อย กันตัวเลขทับกันเป๊ะเวลาโดนตีรัว ๆ
	label.global_position = world_position + Vector2(randf_range(-6.0, 6.0), -10.0)
	label.setup(amount, color)
	label.play()
