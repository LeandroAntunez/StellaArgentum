extends "res://scenes/entities/item/equipable/Equipable.gd"
enum SLOT { Derecha, Izquierda, DosManos }
export(SLOT) var slot

export (int) var minDamage
export (int) var maxDamage
export (int) var cooldown
export (int) var healthPlus
export (int) var manaPlus
