extends CanvasLayer

@onready var hud = $"."
@onready var health_bar = %HealthBar
@onready var coin_count = %CoinCount
@onready var screen_transition = $ScreenTransition
@onready var pickup_message = %PickupMessage
@onready var jane_shadow = %JaneShadow
@onready var screen_transition_2 = $ScreenTransition2
@onready var jane_ = %"Jane?"
@onready var jane__ = %"JANE!?"
@onready var jane_container = %JaneContainer
@onready var swing_timer_label = %SwingTimerLabel
@onready var buster_sword_panel = %BusterSwordPanel

var health_color: Color = Color(0.38, 0.031, 0)

func _ready():
	Globals.hud = hud

func _process(_delta):
	if Globals.currentPlayer != null:
		swing_timer_label.text = str(snapped(Globals.currentPlayer.swing_timer.time_left, 0.1))

func update_health(new_value):
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(health_bar, "value", new_value, 1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(health_bar, "theme_override_styles/fill:bg_color", Color.INDIAN_RED, 0.3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(health_bar, "theme_override_styles/fill:bg_color", health_color, 0.3).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)
	
func update_max_health(new_value):
	health_bar.max_value = new_value

func update_coin_count():
	coin_count.text = str(Globals.currentCoinCount)
	
func display_last_pickup():
	pickup_message.label_settings.font_color = Color(1, 1, 1, 1)
	pickup_message.label_settings.shadow_color = Color(0, 0, 0, .65)
	var pickup_tween = create_tween()
	var pickup_tween_shadow = create_tween()
	pickup_tween.tween_property(pickup_message.label_settings, "font_color", Color(1, 1, 1, 0), 1).set_ease(Tween.EASE_OUT).set_delay(3.0)
	pickup_tween_shadow.tween_property(pickup_message.label_settings, "shadow_color", Color(0, 0, 0, 0), .65).set_ease(Tween.EASE_OUT).set_delay(3.0)
	if Globals.lastPickup == "Geist Goulash":
		pickup_message.text = str("Ate: " + Globals.lastPickup)
	else:
		pickup_message.text = str("Acquired: " + Globals.lastPickup)


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

func fade_to_white():
	screen_transition.visible = true
	screen_transition_2.visible = true
	jane_shadow.visible = true
	jane_.visible = true
	jane__.visible = true
	jane_container.visible = true
	
	var tween = create_tween()
	tween.tween_property(screen_transition, "color", Color(1, 1, 1, 1), 5)
	tween.tween_property(jane_shadow, "modulate", Color(1,1,1,1), 5)
	tween.tween_property(jane_, "modulate", Color(0,0,0,1), 3)
	tween.tween_property(jane__, "modulate", Color(0,0,0,1), 3)
	tween.tween_property(screen_transition_2, "color", Color(1, 1, 1, 1), 5)
	tween.tween_property(screen_transition_2, "color", Color(0, 0, 0, 1), 5)
	
	await tween.finished
