extends CanvasLayer


@onready var arc_extender = $"../ArcExtender"
@onready var beam_battery = $"../BeamBattery+"


@onready var health_bar = %HealthBar
@onready var coin_count = %CoinCount
@onready var screen_transition = $ScreenTransition
@onready var pickup_message = %PickupMessage


@onready var pickup_message = %PickupMessage
@onready var toast_timer = $ToastTimer

func _ready():
	arc_extender.upgrade_collected.connect(display_last_pickup)
	beam_battery.upgrade_collected.connect(display_last_pickup)


func update_health(new_value):
	health_bar.value = new_value

func update_coin_count():
	coin_count.text = str(Globals.currentCoinCount)
	
func display_last_pickup():

	pickup_message.visible = true
	toast_timer.start(3.5)
	pickup_message.text = str("Aquired: " + Globals.lastPickup)


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


func _on_toast_timer_timeout():
	pickup_message.visible = false
	toast_timer.stop()

