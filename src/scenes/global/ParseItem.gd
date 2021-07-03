extends Node
# ParseItem lo que hace es tomar un String, el cual
# corresponde a una subclase de Item (por ejemplo, Weapon),
# y retorna esa subclase.

func string_to_class(item: String):
	match item:
		"Weapon":
			return WeaponDrop.new()
		"Torso":
			return TorsoDrop.new()
		"Legs":
			return LegsDrop.new()
