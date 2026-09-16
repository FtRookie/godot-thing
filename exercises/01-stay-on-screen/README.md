# Exercise 01: Stay on screen

## Goal

Hold any arrow key as long as you like: the icon stops at the edge of the window instead of sliding off it.

## Starting point

`player/Player.cs` has been **broken on purpose**. Someone started adding the "stay on screen" code and left it
unfinished. There are two problems, and you will only see the second one after fixing the first:

1. The project does not compile.
2. Once it compiles, it still does not meet the goal.

Only edit `player/Player.cs`. Don't change the scene or `check.gd`.

## You're done when

- [ ] `dotnet build` shows `0 Warning(s)` and `0 Error(s)`
- [ ] Pressing F5 and holding each arrow key, the icon stops at all four edges
- [ ] The checker prints `RESULT: PASS`

Run the checker from the project root in a VS Code terminal (PowerShell):

```powershell
dotnet build
& ($env:GODOT4 -replace '\.exe$', '_console.exe') --headless --script exercises/01-stay-on-screen/check.gd
```

While the project doesn't compile, pressing F5 in VS Code will say the `build` task failed. That is expected — the
error is in the **Problems** panel (Ctrl+Shift+M).

## Hints

Try without them first. Open one at a time.

<details>
<summary>Hint 1 — reading the error</summary>

The Problems panel shows an error code starting with `CS`. Read the whole message slowly: it names the exact thing
you're not allowed to modify. Error codes are searchable; searching `CS1612` finds Microsoft's explanation.

</details>

<details>
<summary>Hint 2 — why it's an error (you've seen this in Roblox)</summary>

In Roblox, `part.Position.X = 5` is an error too. `Vector3` values can't be changed piece by piece; you have to build
a new one and assign the whole thing: `part.Position = Vector3.new(5, part.Position.Y, part.Position.Z)`.

C# has the same rule for a different reason. `Vector2` is a **struct**, which is copied whenever you read it. Reading
`Position` hands you a copy, so changing that copy's `X` would change nothing on the node — the compiler stops you
rather than let the change silently vanish. TypeScript has no equivalent: objects there are never copied like this.

</details>

<details>
<summary>Hint 3 — the pattern</summary>

Copy, change, assign back: put `Position` into a local variable, change the variable, then assign the whole variable
back to `Position`. `Vector2 windowSize = GetViewportRect().Size;` in the broken code is already an example of reading
a struct into a local variable.

</details>

<details>
<summary>Hint 4 — it compiles but the checker fails</summary>

Look at which directions the checker says ended `OUTSIDE the window`. What does the code do for the other axis?

</details>

## Stretch goal (optional)

The goal only keeps the icon's **centre** on screen, so half of the icon can still hang over an edge. Make the whole
icon stay visible. The icon is 128×128 pixels, and `Position` is the centre of it. The checker still passes when you do
this.

When you think you're done — or you're stuck — ask Claude to review your `player/Player.cs`.
