extends HBoxContainer
signal pressed

func _on_Button_pressed():
	emit_signal("pressed", $idsave.text)
	$idsave.set("custom_colors/font_color", Color(1,1,0))
	$name.set("custom_colors/font_color", Color(1,1,0))
	$place.set("custom_colors/font_color", Color(1,1,0))
	$level.set("custom_colors/font_color", Color(1,1,0))
	$savetime.set("custom_colors/font_color", Color(1,1,0))

func _on_Button_focus_exited():
	$idsave.set("custom_colors/font_color", Color(1,1,1))
	$name.set("custom_colors/font_color", Color(1,1,1))
	$place.set("custom_colors/font_color", Color(1,1,1))
	$level.set("custom_colors/font_color", Color(1,1,1))
	$savetime.set("custom_colors/font_color", Color(1,1,1))
