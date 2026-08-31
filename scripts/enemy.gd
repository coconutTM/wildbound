class_name Enemy
extends CharacterBody2D

signal died

@export var stats: Character_Stats

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var attack_hitbox: Hitbox = $AttackHitbox
@onready var attack_cooldown: Timer = $AttackCooldown

var player: CharacterBody2D = null
var can_attack: bool = true

func _ready() -> void:
	attack_hitbox.setup(stats)
	attack_hitbox.deactivate()

	attack_cooldown.one_shot = true
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)

	stats.health_depleted.connect(die)

func _physics_process(delta: float) -> void:
	find_player()
	handle_movement()
	handle_attack()
	update_animation()

# หา player ครั้งเดียวแล้วเก็บ reference ไว้ เกมนี้มี player คนเดียว
# เลยไม่ต้อง query ใหม่ทุกเฟรม (ถ้ายังไม่เจอ เช่น enemy _ready() ก่อน
# player เข้า group ทัน จะลองหาใหม่เรื่อยๆ จนกว่าจะเจอ)
func find_player() -> void:
	if player:
		return
	player = get_tree().get_first_node_in_group("player")

func handle_movement() -> void:
	if not player:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var distance := global_position.distance_to(player.global_position)

	# อยู่นอกระยะโจมตี -> เดินเข้าหา / อยู่ในระยะแล้ว -> หยุดเดินแล้วโจมตีแทน
	if distance > stats.weapon.attack_range:
		var direction := (player.global_position - global_position).normalized()
		velocity = direction * stats.speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func handle_attack() -> void:
	if not player or not can_attack:
		return

	var distance := global_position.distance_to(player.global_position)
	if distance <= stats.weapon.attack_range:
		attack()

func attack() -> void:
	can_attack = false
	attack_hitbox.activate()

	await get_tree().create_timer(0.15).timeout  # ระยะเวลาที่ hitbox เปิดอยู่ ปรับได้ตามฟีล

	attack_hitbox.deactivate()

	attack_cooldown.wait_time = stats.weapon.attack_cooldown
	attack_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func take_damage(amount: int) -> void:
	stats.take_damage(amount)

# Milestone 1 แค่ต้องการให้ enemy หายไปเมื่อ HP หมด ("Enemy ตายได้")
# ระบบ drop loot จะเพิ่มใน Milestone 3 (loot.gd) ไม่ต้องทำตอนนี้
func die() -> void:
	died.emit()
	queue_free()

func update_animation() -> void:
	if not player:
		sprite.play("default")
		return

	# หันตามตำแหน่ง player แทนทิศทางเดิน (สอดคล้องกับพฤติกรรม chase)
	sprite.flip_h = player.global_position.x < global_position.x

	# ตอนนี้มี animation แค่ "default" ตัวเดียว เลยเล่นเหมือนกันทั้ง idle/walk
	# ถ้ามี animation แยก idle/walk แล้ว ค่อยกลับมาเช็ค is_moving แล้วสลับชื่อ animation ตรงนี้
	sprite.play("default")
