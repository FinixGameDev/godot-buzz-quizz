extends Control

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		$FadeIn/AnimationPlayer.play_backwards("fade_in")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://scenes/quiz_select.tscn")
