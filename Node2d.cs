using Godot;

public partial class Node2d : Node2D
{
	// Pixels per second. [Export] makes this editable in the Inspector.
	[Export]
	public float Speed = 400.0f;

	private Sprite2D? _sprite;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_sprite = new Sprite2D
		{
			Texture = GD.Load<Texture2D>("res://icon.svg"),
			Position = GetViewportRect().Size / 2.0f
		};
		AddChild(_sprite);

		GD.Print("Node2d._Ready ran - press the arrow keys to move the icon.");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		_sprite.Position += direction * Speed * (float)delta;
	}
}
