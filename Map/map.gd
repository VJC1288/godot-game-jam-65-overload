extends CanvasLayer

@onready var map = $"."
@onready var level_manager: LevelManager = $"../LevelManager"
@onready var game_map = %GameMap

var map_open: bool = false

var exits: Array

var currentTile = null

var mapTileDictionary = {
	["N","S","E","W"]: Vector2i(0,0),
	["N","X","X","X"]: Vector2i(1,0),
	["N","X","X","W"]: Vector2i(2,0),
	["N","X","E","X"]: Vector2i(3,0),
	["N","S","X","X"]: Vector2i(0,1),
	["N","S","X","W"]: Vector2i(1,1), 
	["N","X","E","W"]: Vector2i(2,1),
	["N","S","E","X"]: Vector2i(3,1),
	["X","X","X","W"]: Vector2i(0,2),
	["X","S","X","W"]: Vector2i(1,2),
	["X","S","E","W"]: Vector2i(2,2),
	["X","S","X","X"]: Vector2i(3,2),
	["X","S","E","X"]: Vector2i(0,3),
	["X","X","E","X"]: Vector2i(1,3),
	["X","X","E","W"]: Vector2i(3,3)
}


func _process(_delta):

	if Input.is_action_just_pressed("openmap"):
		if map_open:
			get_tree().paused = false
			close_map()
		else:
			open_map()
			get_tree().paused = true
	
func open_map():
	map.visible = true
	map_open = true
	
func close_map():
	map.visible = false
	map_open = false

func _on_level_manager_level_changed(coords):
	check_doors()
	currentTile = coords
	
	game_map.set_cell(1, coords, 1, mapTileDictionary[exits])
		
func check_doors():
	exits = []
	var hasSouthExit: bool = level_manager.current_level.southExit
	var hasNorthExit: bool = level_manager.current_level.northExit
	var hasEastExit: bool = level_manager.current_level.eastExit
	var hasWestExit: bool = level_manager.current_level.westExit
	
	if hasNorthExit:
		exits.append("N")
	else: 
		exits.append("X")
	if hasSouthExit:
		exits.append("S")
	else: 
		exits.append("X")
	if hasEastExit:
		exits.append("E")
	else: 
		exits.append("X")
	if hasWestExit:
		exits.append("W")
	else: 
		exits.append("X")
		
func currentTileIndicator():
	pass