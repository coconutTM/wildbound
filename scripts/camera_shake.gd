extends Node

# Autoload (singleton) ชื่อ "CameraShake"
# เรียกจากที่ไหนก็ได้: CameraShake.add_trauma(0.3)
# ตัว camera เองต้อง register ตัวเองก่อนถึงจะสั่นได้ (ดู player.gd _ready())

const TRAUMA_DECAY := 2.5  # ยิ่งมาก ยิ่งหายเร็ว (หน่วยต่อวินาที)
const MAX_OFFSET := 8.0    # pixel offset สูงสุดตอนสั่นแรงสุด

var camera: Camera2D = null
var trauma: float = 0.0

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func register_camera(cam: Camera2D) -> void:
	camera = cam


func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)


func _process(delta: float) -> void:
	if not camera:
		return

	if trauma <= 0.0:
		camera.offset = Vector2.ZERO
		return

	trauma = max(trauma - TRAUMA_DECAY * delta, 0.0)
	# ยกกำลังสอง กันสั่นแรงเท่าเดิมตลอด ให้มันเบาลงเร็วช่วงท้าย ดูเป็นธรรมชาติกว่า
	var power := trauma * trauma
	camera.offset = Vector2(
		rng.randf_range(-1.0, 1.0),
		rng.randf_range(-1.0, 1.0)
	) * MAX_OFFSET * power
