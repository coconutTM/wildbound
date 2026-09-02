extends Node

# Autoload (singleton) เรียกใช้จากที่ไหนก็ได้ในเกมผ่าน SFX.play("ชื่อเสียง")
# ต้อง register ใน Project Settings > Autoload ชื่อ "SFX" ชี้มาไฟล์นี้
# (ดูขั้นตอนละเอียดในคอมเมนต์ท้ายไฟล์ project.godot)

const SFX_DIR := "res://assets/sounds/effects/"
const SFX_NAMES := [
	"attack_swing",
	"hit_impact",
	"enemy_death",
	"player_hurt",
	"player_death",
	"pickup_loot",
	"chest_open",
	"craft_success",
	"wave_start",
	"ui_click",
]

var streams: Dictionary = {}


func _ready() -> void:
	for sfx_name in SFX_NAMES:
		var stream := load(SFX_DIR + sfx_name + ".wav") as AudioStream
		if stream:
			streams[sfx_name] = stream
		else:
			push_warning("SFX โหลดไม่เจอ: %s" % sfx_name)


# เล่นเสียง one-shot ซ้อนกันได้หลายตัวพร้อมกัน (เช่น enemy โดนตีพร้อมกันหลายตัว)
# ใช้ AudioStreamPlayer แยกตัวต่อครั้ง แล้ว queue_free ทิ้งเองตอนเล่นจบ
func play(sfx_name: String, volume_db: float = 0.0) -> void:
	if not streams.has(sfx_name):
		push_warning("ไม่รู้จักชื่อ SFX: %s" % sfx_name)
		return

	var player := AudioStreamPlayer.new()
	player.stream = streams[sfx_name]
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
