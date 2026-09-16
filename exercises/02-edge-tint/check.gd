extends SceneTree
# Checker for exercise 02. For each edge: starts from the centre, pushes the player into the edge, checks the icon is
# red, then moves away and checks it went back to normal. Speed is raised so the test is quick.

func _hold(action: String, seconds: float) -> void:
	Input.action_press(action)
	await create_timer(seconds).timeout
	Input.action_release(action)
	await process_frame
	await process_frame

func _init():
	var player = load(ProjectSettings.get_setting("application/run/main_scene")).instantiate()
	root.add_child(player)
	await process_frame
	var sprite: Sprite2D = player.get_node("Sprite2D")
	var script = sprite.get_script()
	if script == null or not script.resource_path.ends_with("EdgeTint.cs"):
		print("EdgeTint.cs is not attached to the Sprite2D - attach it in the Godot editor first")
		print("RESULT: FAIL")
		quit()
		return
	player.set("Speed", 5000.0)
	var size: Vector2 = player.get_viewport_rect().size
	var ok := true
	for pair in [["ui_right", "ui_left"], ["ui_down", "ui_up"], ["ui_left", "ui_right"], ["ui_up", "ui_down"]]:
		player.position = size / 2.0
		await process_frame
		await process_frame
		await _hold(pair[0], 0.6)
		var red := sprite.modulate.is_equal_approx(Color.RED)
		await _hold(pair[1], 0.05)
		var normal := sprite.modulate.is_equal_approx(Color.WHITE)
		ok = ok and red and normal
		print("%-5s edge: red while touching: %s, normal after moving away: %s" % [pair[0].trim_prefix("ui_"), "yes" if red else "NO", "yes" if normal else "NO"])
	print("RESULT: ", "PASS" if ok else "FAIL")
	quit()
