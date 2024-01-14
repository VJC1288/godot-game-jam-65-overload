extends Node

enum Teams {PLAYER = 1, ENEMIES = 2}

var currentPlayer: CharacterBody2D

var currentTargetedGhost: CharacterBody2D

var paused: bool = false

var currentCoinCount = 0
