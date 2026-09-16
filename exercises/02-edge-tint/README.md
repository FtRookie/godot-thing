# Exercise 02: Edge tint

## Goal

While the player is pressed against any edge of the window, the icon turns red. When it moves away from the edge, the
icon goes back to its normal colour (white).

## Starting point

`player/EdgeTint.cs` has been **broken on purpose**. It's meant to be the script on the player's `Sprite2D`, so it runs
*as* the sprite and checks its parent, the `Player`, for its position. There are three problems, and each one only shows
up after you fix the one before it:

1. It does not compile.
2. Once it compiles and is attached, it crashes every frame.
3. Once it stops crashing, the tint logic is wrong (in more than one way).

Before you start, make sure `player/Player.cs` compiles and exercise 01's checker still passes.

**Rules:** fix `player/EdgeTint.cs` only. Don't edit `player/Player.cs`, and only change the scene by attaching the script.

## Setup: attach the script (Godot editor)

1. Open `player/player.tscn` and select the `Sprite2D` node in the **Scene** panel.
2. Drag `player/EdgeTint.cs` from the **FileSystem** panel onto the **Script** property at the bottom of the **Inspector**.
3. Save the scene (Ctrl+S).

## You're done when

- [ ] `dotnet build` shows `0 Warning(s)` and `0 Error(s)`
- [ ] Pressing F5, the icon turns red against each of the four edges and back to normal when it leaves
- [ ] The checker prints `RESULT: PASS`
- [ ] Exercise 01's checker still prints `RESULT: PASS`

```powershell
dotnet build
& ($env:GODOT4 -replace '\.exe$', '_console.exe') --headless --script exercises/02-edge-tint/check.gd
```

Runtime errors (problem 2) appear in the terminal when you run the checker, and in the Godot editor's **Debugger**
panel under **Errors** when you press F5 there.

## Hints

Try without them first. Open one at a time.

<details>
<summary>Hint 1 — the compile error</summary>

The error says `Color` has no `Red`. Godot's C# API keeps its named colours in a separate class. Its name is very close
to `Color` — type the start of it and look at what autocomplete offers.

</details>

<details>
<summary>Hint 2 — the crash</summary>

Read the first line of the `NullReferenceException`: which line and which variable? Then find where that variable is
assigned, and ask *when* that code runs. You've seen this exact problem before in `Player.cs`.

</details>

<details>
<summary>Hint 3 — some edges never turn red</summary>

The checker tells you which edges fail. Look at what the code compares the player's position with. There's also a
variable that's calculated but never used — why would it be there?

</details>

<details>
<summary>Hint 4 — it stays red</summary>

Read the code as if you were the computer: which line sets the colour back to normal? In Roblox terms, this is changing a
part's colour on `Touched` with no `TouchEnded`.

</details>

## Stretch goals (optional)

1. Make the tint colour editable in the Inspector instead of always red. (Godot shows a colour picker for exported
   `Color` properties.)
2. The code compares positions with `==`, which is usually risky with floats. Why does it work here? Think about where
   the player's position values come from when it's against an edge.

When you think you're done — or you're stuck — ask Claude to review `player/EdgeTint.cs`.
