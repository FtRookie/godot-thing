using Godot;

namespace GodotThing.player;

// Attach to the player's Sprite2D. Tints the icon red while the player is pressed against an edge of the window.
public partial class EdgeTint : Sprite2D
{
	private Node2D _player = null!;

	public override void _Ready()
	{
		_player = GetParent<Node2D>();
	}

	public override void _Process(double delta)
	{
		Vector2 min = Texture.GetSize() / 2;
		Vector2 windowSize = GetViewportRect().Size;
		Vector2 max = windowSize - min;
		Vector2 playerPosition = _player.Position;
		bool touchingEdge =
			playerPosition.X <= min.X ||
			playerPosition.Y <= min.Y ||
			playerPosition.X >= max.X ||
			playerPosition.Y >= max.Y;

		Modulate = touchingEdge ? Colors.Red : Colors.White;
	}
}
