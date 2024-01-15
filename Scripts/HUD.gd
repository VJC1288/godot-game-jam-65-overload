extends CanvasLayer


@onready var health_bar = %HealthBar
@onready var coin_count = %CoinCount
@onready var screen_transition = $ScreenTransition


func update_health(new_value):
	health_bar.value = new_value

func update_coin_count():
	coin_count.text = str(Globals.currentCoinCount)

func fade_to_black():
	screen_transition.visible = true
	var tween = create_tween()
	tween.tween_property(screen_transition, "color", Color(0, 0, 0, 1), .3).set_ease(Tween.EASE_IN)
	tween.play()
	await tween.finished
	
	
func unfade_from_black():
	var tween = create_tween()
	tween.tween_property(screen_transition, "color", Color(0, 0, 0, 0), .5).set_ease(Tween.EASE_OUT).set_delay(.2)
	tween.play()
	await tween.finished
	screen_transition.visible = false


	
