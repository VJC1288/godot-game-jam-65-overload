extends Node

enum Teams {PLAYER = 1, ENEMIES = 2}

var currentPlayer: Player

var currentTargetedGhost: Node2D = null

var paused: bool = false

var currentCoinCount = 0

var lastPickup: String = ""

var shopInventory = {
	Vector2i(2, 1):["beam_battery", "key", "arc_extender"]
}
