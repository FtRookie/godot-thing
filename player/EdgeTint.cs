using Godot;

namespace GodotThing.player;

// Attach to the player's Sprite2D. Tints the icon red while the player is touching an edge of the window.
public partial class EdgeTint : Sprite2D
{
	private Player _player = null!;

	public override void _Ready()
	{
		_player = GetParent<Player>();
		_player.TouchingEdgeChanged += OnTouchingEdgeChanged;
	}

	private void OnTouchingEdgeChanged(bool touching)
	{
		Modulate = touching ? Colors.Red : Colors.White;
	}
}
