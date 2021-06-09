extends "res://scenes/entities/item/equipable/Equipable.gd"
enum SLOT { Cabeza, Hombros, Pecho, Manos, Cintura, Piernas, Pies }
export(SLOT) var slot
enum TYPE { Tela, Cuero, Malla }
export(TYPE) var type

export (int) var armor
export (int) var cooldown
export (int) var healthPlus
export (int) var healthRegenerationPlus
export (int) var manaPlus
export (int) var manaRegenerationPlus
