extends "res://scenes/entities/item/Item.gd"
enum DROPOFF { Pobre, Comun, Raro, Unico, Epico, Legendario }
export(DROPOFF) var rarity
export (int) var minDamage
export (int) var maxDamage
export (int) var cooldown
export (int) var healthPlus
export (int) var manaPlus
