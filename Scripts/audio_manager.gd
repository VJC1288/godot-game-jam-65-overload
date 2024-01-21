extends Node2D

@onready var main_music = $MainMusic
@onready var shop_music = $ShopMusic
@onready var boss_music = $BossMusic



var currentMusic: AudioStreamPlayer2D
var gameEnd

func _ready():
	currentMusic = main_music


func room_change(_room_coords, hasShopkeeper, hasBoss):
	
	if hasShopkeeper:
		switch_music(shop_music)
	elif hasBoss:
		switch_music(boss_music)
	else:
		switch_music(main_music)

func _process(_delta):
	if !gameEnd:
		if currentMusic.playing:
			pass
		else:
			currentMusic.play()

func switch_music(music):
	if currentMusic != music:
		currentMusic.stop()
		currentMusic = music
		currentMusic.play()
