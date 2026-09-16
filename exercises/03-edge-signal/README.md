# Exercise 03: Edge signal

## Goal

Same behaviour as exercise 02 — the icon is red while the player touches an edge, white otherwise — but with the
responsibilities split properly:

- `Player` works out whether it's touching an edge, and **sends a signal** when that starts or stops.
- `EdgeTint` **listens** for the signal and sets the colour. It no longer does any edge maths of its own.

This removes the duplicated boundary calculation from exercise 02: if `Player` ever changes how it clamps, the tint
follows automatically.

## Signals in C#

A signal is Godot's event. Three pieces:

| Step | C# | Roblox | TypeScript |
|---|---|---|---|
| Declare | `[Signal] public delegate void TouchingEdgeChangedEventHandler(bool touching);` | `Instance.new("BindableEvent")` | `new EventEmitter()` |
| Send | `EmitSignal(SignalName.TouchingEdgeChanged, true);` | `event:Fire(true)` | `emitter.emit("touchingEdgeChanged", true)` |
| Listen | `player.TouchingEdgeChanged += OnTouchingEdgeChanged;` | `event.Event:Connect(onChanged)` | `emitter.on("touchingEdgeChanged", onChanged)` |

The delegate's name must end in `EventHandler`; the signal itself is the name without it (`TouchingEdgeChanged`). The
build fails with `GD0201` otherwise. The parameters in the delegate are what every listener receives.

## Starting point

Both `player/Player.cs` and `player/EdgeTint.cs` have been **broken on purpose**. Your working exercise 02 versions are
saved in `exercises/02-edge-tint/your-solution/` (as `.txt`, so they aren't compiled).

1. It does not compile — there are two separate mistakes, and fixing one can change the error you see for the other.
2. Once it compiles, the colours are backwards.

**Rules:** keep `Player`'s movement working, only send the signal when touching changes (not every frame), keep the edge
maths out of `EdgeTint`, and don't change the scene.

## You're done when

- [ ] `dotnet build` shows `0 Warning(s)` and `0 Error(s)`
- [ ] Pressing F5, the icon turns red against each edge and back to white when it leaves
- [ ] The checker prints `RESULT: PASS`
- [ ] Exercise 02's and 01's checkers still print `RESULT: PASS`

```powershell
dotnet build
& ($env:GODOT4 -replace '\.exe$', '_console.exe') --headless --script exercises/03-edge-signal/check.gd
```

## Watch out: never subscribe inside `_Process`

`+=` inside `_Process` adds **another** subscription every frame, exactly like calling `:Connect` inside a loop in
Roblox. Tested in Godot 4.7: after 60 `+=` of the same handler, a single `EmitSignal` ran the handler **60 times** — and
Godot printed no warning. Subscribe once, in `_Ready`.

## Hints

Try without them first. Open one at a time.

<details>
<summary>Hint 1 — "'Node2D' does not contain a definition for 'TouchingEdgeChanged'"</summary>

Which class declares the signal? Now look at the type of `_player`. A variable only exposes the members of its declared
type — the same as a TypeScript variable typed as a base interface, even when the object underneath has more.

</details>

<details>
<summary>Hint 2 — "No overload ... matches delegate" / "The name 'touching' does not exist"</summary>

A handler has to accept exactly what the signal sends. Compare `OnTouchingEdgeChanged` with the delegate declared in
`Player.cs`.

</details>

<details>
<summary>Hint 3 — the colours are backwards</summary>

When `Player` sends the signal, which value does it carry: the new state or the old one? Read the two lines inside the
`if` in order, as the computer would.

</details>

## Stretch goal (optional)

Without changing `Player.cs`, make the game also print `Ouch!` to the Output panel each time the player **starts**
touching an edge — not when it stops. This is the point of signals: new listeners don't require changing the sender.

When you think you're done — or you're stuck — ask Claude to review your changes.
