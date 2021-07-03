extends AnimatedSprite

var isLevelUp

func _ready():
	isLevelUp = false
	visible = false

func _on_Player_player_level_up():
	visible = true
	isLevelUp = true
	stop()
	play("LvlUP")
	
func _on_PlayerEffects_animation_finished():
	if self.animation == "LvlUP":
		visible = false
		isLevelUp = false
