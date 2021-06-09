extends KinematicBody2D

var tile_size = 32
var can_move = true
var facing = 'right'
var moves = {'right': Vector2(1, 0),
			 'left': Vector2(-1, 0),
			 'up': Vector2(0, -1),
			 'down': Vector2(0, 1)}
var raycasts = {'right': 'RayCastRight',
				'left': 'RayCastLeft',
				'up': 'RayCastUp',
				'down': 'RayCastDown'}

func move(dir):
	if get_node(raycasts[facing]).is_colliding():
		return
	facing = dir
	can_move = false
	$AnimationPlayer.play(facing)
	$MoveTween.interpolate_property(self, "position", position,
					  position + moves[facing] * tile_size, 0.8,
					  Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	return true

func _on_MoveTween_tween_completed(object, key):
	can_move = true
