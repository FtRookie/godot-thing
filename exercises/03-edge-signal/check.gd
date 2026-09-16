extends SceneTree
# Checker for exercise 03. Runs the same edge test as exercise 02, and also checks that:
# - Player sends TouchingEdgeChanged only when touching starts or stops, not every frame
# - EdgeTint no longer works out the window edges itself
# Speed is raised so the test is quick.

var _sent := 0

func _count(_touching) -> void:
	_sent += 1

func _hold(action: String, seconds: float) -> void:
	Input.action_press(action)
	await create_timer(seconds).timeout
	Input.action_release(action)
	await process_frame
	await process_frame

func _fail(message: String) -> void:
	print(message)
	print("RESULT: FAIL")
	quit()

func _init():
	var player = load("res://player/player.tscn").instantiate()
	root.add_child(player)
	await process_frame
	var sprite: Sprite2D = player.get_node("Sprite2D")
	var script = sprite.get_script()
	if script == null or not script.resource_path.ends_with("EdgeTint.cs"):
		_fail("EdgeTint.cs is not attached to the Sprite2D")
		return
	if not player.has_signal("TouchingEdgeChanged"):
		_fail("Player has no TouchingEdgeChanged signal")
		return
	player.connect("TouchingEdgeChanged", _count)
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

	var sent_ok := _sent == 8
	print("signal sent %d times for 8 starts/stops of touching: %s" % [_sent, "yes" if sent_ok else "NO - it should only be sent when touching changes"])
	var source := FileAccess.get_file_as_string("res://player/EdgeTint.cs")
	var listens_only := not (source.contains("GetViewportRect") or source.contains("Position"))
	print("EdgeTint only reacts to the signal: %s" % ("yes" if listens_only else "NO - it still works out the window edges itself"))
	ok = ok and sent_ok and listens_only
	print("RESULT: ", "PASS" if ok else "FAIL")
	quit()
