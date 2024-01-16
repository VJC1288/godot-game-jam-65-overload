extends CanvasLayer


@onready var arc_extender = $"../ArcExtender"
@onready var beam_battery = $"../BeamBattery+"


@onready var health_bar = %HealthBar
@onready var coin_count = %CoinCount
@onready var screen_transition = $ScreenTransition
@onready var pickup_message = %PickupMessage


@onready var pickup_message = %PickupMessage

func _ready():
	arc_extender.upgrade_collected.connect(display_last_pickup)
	beam_battery.upgrade_collected.connect(display_last_pickup)


func update_health(new_value):
	health_bar.value = new_value

func update_coin_count():
	coin_count.text = str(Globals.currentCoinCount)
	
func display_last_pickup():
	pickup_message.label_settings.font_color = Color(1, 1, 1, 1)
	pickup_message.label_settings.shadow_color = Color(0, 0, 0, .65)
	var pickup_tween = create_tween()
	var pickup_tween_shadow = create_tween()
	pickup_tween.tween_property(pickup_message.label_settings, "font_color", Color(1, 1, 1, 0), 1).set_ease(Tween.EASE_OUT).set_delay(3.0)
	pickup_tween_shadow.tween_property(pickup_message.label_settings, "shadow_color", Color(0, 0, 0, 0), .65).set_ease(Tween.EASE_OUT).set_delay(3.0)
	pickup_message.text = str("Aquired: " + Globals.lastPickup)


func fade_to_black():
	screen_transition.visible = true
	var tween = create_tween()
	tween.tween_property(screen_transition, "color", Color(0, 0, 0, 1), .3).set_ease(Tween.EASE_IN)
	await tween.finished
	
func unfade_from_black():
	var tween = create_tween()
	tween.tween_property(screen_transition, "color", Color(0, 0, 0, 0), .5).set_ease(Tween.EASE_OUT).set_delay(.2)
	await tween.finished
	screen_transition.visible = false
