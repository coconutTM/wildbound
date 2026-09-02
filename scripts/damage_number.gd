extends Label


func setup(amount: int, color: Color = Color.WHITE) -> void:
	text = str(amount)
	modulate = color


# เรียกแยกจาก _ready() ตั้งใจ กัน race condition เรื่องตำแหน่ง
# (ต้องตั้ง global_position ให้เสร็จก่อน ค่อยเริ่มเล่น animation)
func play() -> void:
	var start_y := position.y
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", start_y - 30.0, 0.7)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.3)
	await get_tree().create_timer(0.85).timeout
	queue_free()
