class_name Character_Stats extends Resource

signal health_changed(current_health: int, max_health: int)
signal health_depleted

enum Faction {
	PLAYER,
	ENEMY,
}

@export var max_health: int = 10
@export var speed: float = 200
@export var faction: Faction = Faction.PLAYER
@export var damage: int = 1

@export var weapon: Weapon_Stats

var current_health: int = 0 : set = _on_health_set

func _init() -> void:
	initialize_stats.call_deferred()

func take_damage(amount: int) -> void:
	current_health -= amount
	print(current_health)

func initialize_stats() -> void:
	if not weapon:
		weapon = Weapon_Stats.new()
	current_health = max_health
	damage = weapon.damage

func heal_full() -> void:
	current_health = max_health

func _on_health_set(new_value: int) -> void:
	current_health = new_value
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		health_depleted.emit()
