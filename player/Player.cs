using Godot;

namespace GodotThing.player;

public partial class Player : Node2D
{
	// Sent when the player starts or stops touching an edge of the window.
	[Signal]
	public delegate void TouchingEdgeChangedEventHandler(bool touching);

	// Pixels per second. [Export] makes this editable in the Inspector.
	[Export]
	public float Speed { get; set; } = 400.0f;
	private Sprite2D _sprite = null!;
	private bool _touchingEdge;

	public override void _Ready()
	{
		_sprite = GetNode<Sprite2D>("Sprite2D");
	}

	public override void _Process(double delta)
	{
		Vector2 halfSize = _sprite.Texture.GetSize() / 2;
		Vector2 windowSize = GetViewportRect().Size;
		Vector2 min = halfSize;
		Vector2 max = windowSize - halfSize;
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		Vector2 step = direction * Speed * (float)delta;
		Vector2 newPosition = (Position + step).Clamp(min, max);
		Position = newPosition;

		bool touchingEdge =
			newPosition.X <= min.X ||
			newPosition.Y <= min.Y ||
			newPosition.X >= max.X ||
			newPosition.Y >= max.Y;

		if (touchingEdge != _touchingEdge)
		{
			EmitSignal(SignalName.TouchingEdgeChanged, touchingEdge);
			_touchingEdge = touchingEdge;
		}
	}
}
