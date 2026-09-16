extends SceneTree
# Checker for exercise 01. Holds each arrow direction long enough to cross the whole window, then reports
# whether Player stayed inside it. Speed is raised so the test is quick; your Speed value is not changed.
# Headless runs use a different window size than a real window - that is expected.

func _init():
	var player = load("res://player/player.tscn").instantiate()
	root.add_child(player)
	await process_frame
	player.set("Speed", 5000.0)
	var size: Vector2 = player.get_viewport_rect().size
	var start: Vector2 = player.position
	var ok := true
	for action in ["ui_right", "ui_down", "ui_left", "ui_up"]:
		Input.action_press(action)
		await create_timer(0.6).timeout
		Input.action_release(action)
		await process_frame
		var p: Vector2 = player.position
		var inside := p.x >= 0.0 and p.y >= 0.0 and p.x <= size.x and p.y <= size.y
		ok = ok and inside
		print("held ", action.trim_prefix("ui_"), ": ended at ", p, " -> ", "inside" if inside else "OUTSIDE the window")
	# Staying inside is only meaningful if the icon moves at all.
	if player.position == start:
		ok = false
		print("the icon never moved - is _Process still being called?")
	print("RESULT: ", "PASS" if ok else "FAIL")
	quit()
