class_name Crafting_Manager
extends Node

@export var player: Player
@export var recipes: Array[Weapon_Recipe] = []

func can_craft(recipe: Weapon_Recipe) -> bool:
	for component_type in recipe.cost:
		var needed: int = recipe.cost[component_type]
		if not player.has_enough_components(component_type, needed):
			return false
	return true

func craft(recipe: Weapon_Recipe) -> bool:
	if not can_craft(recipe):
		return false

	for component_type in recipe.cost:
		player.remove_component(component_type, recipe.cost[component_type])

	player.equip_weapon(recipe.weapon_stats)
	return true
