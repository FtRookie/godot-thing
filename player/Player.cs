using Godot;

namespace GodotThing.player;

public partial class Player : Node2D
{
	// Pixels per second. [Export] makes this editable in the Inspector.
	[Export]
	public float Speed { get; set; } = 400.0f;
	private Sprite2D _sprite = null!;

	public override void _Ready()
	{
		_sprite = GetNode<Sprite2D>("Sprite2D");
		base._Ready();
	}

	public override void _Process(double delta)
	{
		Vector2 halfSize = _sprite.Texture.GetSize() / 2;
		Vector2 windowSize = GetViewportRect().Size;
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		Vector2 step = direction * Speed * (float)delta;
		Position = (Position + step).Clamp(halfSize, windowSize - halfSize);
	}
}
