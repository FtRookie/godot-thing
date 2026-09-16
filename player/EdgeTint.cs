using Godot;

namespace GodotThing.player;

// Attach to the player's Sprite2D. Tints the icon red while the player is pressed against an edge of the window.
public partial class EdgeTint : Sprite2D
{
	private Node2D _player = null!;

	public EdgeTint()
	{
		_player = GetParent<Node2D>();
	}

	public override void _Process(double delta)
	{
		Vector2 halfSize = Texture.GetSize() / 2;
		Vector2 windowSize = GetViewportRect().Size;
		bool touchingEdge = _player.Position.X == halfSize.X || _player.Position.Y == halfSize.Y;

		if (touchingEdge)
		{
			Modulate = Color.Red;
		}
	}
}
