class_name Hitbox extends Area2D

# แก้: เดิมใช้ _init(attacker_stats, hitbox_lifetime, shape) แบบบังคับ argument
# ซึ่งใช้ได้แค่ตอนสร้างด้วย Hitbox.new(...) ในโค้ดเท่านั้น
# แต่ spec ของกลุ่มระบุให้ AttackHitbox เป็น child node ที่วางไว้ล่วงหน้าใน
# scene ของ Player/Enemy (ไม่ได้ spawn ใหม่ทุกครั้งที่โจมตี)
# ถ้าวางเป็น node ในซีนจริง Godot จะเรียก _init() แบบไม่มี argument ตอนโหลดซีน
# แล้ว error ทันที จึงเปลี่ยนมาใช้ setup() ที่เรียกจาก Player/Enemy หลัง _ready() แทน

var attacker_stats: Character_Stats

func _ready() -> void:
	monitoring = false
	monitorable = false
	area_entered.connect(_on_area_entered)

	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

# เรียกครั้งเดียวตอน Player/Enemy _ready() เพื่อผูก stats และตั้ง collision mask
# ให้ตรงกับฝั่งตรงข้าม (ดูคำอธิบาย layer/mask ด้านล่าง)
func setup(stats: Character_Stats) -> void:
	attacker_stats = stats

	# แก้: เดิม mask ของแต่ละฝั่งชี้ไป layer ของ hurtbox ฝั่งเดียวกับตัวเอง
	# (PLAYER hitbox mask=6 ชนกับ PLAYER hurtbox layer=6) ทำให้ตีแล้วไม่โดนศัตรู
	# ตอนนี้สลับให้ hitbox ของฝั่งหนึ่งชี้ไป hurtbox layer ของอีกฝั่งแทน
	# ผัง layer: 1=Player body, 2=Enemy body, 3=Player Hitbox, 4=Enemy Hitbox,
	# 5=Player Hurtbox, 6=Enemy Hurtbox — hitbox ฝั่งไหน mask ต้องชี้ไป
	# hurtbox ของอีกฝั่งเสมอ ไม่ใช่ฝั่งตัวเอง
	match attacker_stats.faction:  # ระวัง: ต้องเป็น faction (f เล็ก) ไม่ใช่ Faction (F ใหญ่)
		Character_Stats.Faction.PLAYER:
			set_collision_layer_value(3, true)
			set_collision_mask_value(6, true)  # ตรวจจับ Enemy Hurtbox
		Character_Stats.Faction.ENEMY:
			set_collision_layer_value(4, true)
			set_collision_mask_value(5, true)  # ตรวจจับ Player Hurtbox

# เปิด/ปิด hitbox ช่วงที่กำลังโจมตี เรียกจาก attack() ใน player.gd / enemy.gd
func activate() -> void:
	monitoring = true

func deactivate() -> void:
	monitoring = false



func _on_area_entered(area: Area2D) -> void:
	if not area.has_method("receive_hit"):
		return

	var knockback_force := Vector2.ZERO
	if attacker_stats.weapon and owner and area.owner:
		var direction :Vector2 = (area.owner.global_position - owner.global_position).normalized()
		knockback_force = direction * attacker_stats.weapon.knockback

	print("knockback_force: ", knockback_force)  # debug ชั่วคราว ลบทิ้งทีหลัง
	area.receive_hit(attacker_stats.damage, knockback_force)
