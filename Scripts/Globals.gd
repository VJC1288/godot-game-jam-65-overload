extends Node

enum Teams {PLAYER = 1, ENEMIES = 2}

const TITLE_SCREEN:PackedScene = preload("res://Scenes/title_screen.tscn")
const MAIN:PackedScene = preload("res://Scenes/main.tscn")
const GAMEOVER:PackedScene = preload("res://Scenes/gameover.tscn")

var currentPlayer: Player

var currentTargetedGhost: Node2D = null

var paused: bool = false

var currentCoinCount = 0

var lastPickup: String = ""

var shopInventory = {
	Vector2i(2, 1):["Beam Battery", "key", "Arc Extender"],
	Vector2i(-3, 1):["Spectre Coat", "Geist Goulash", "Wraith Boots"]
}

var locksUnlocked = []

var roomsSeen = []
	
