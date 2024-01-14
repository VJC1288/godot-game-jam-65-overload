extends CanvasLayer


@onready var health_bar = %HealthBar
@onready var coin_count = %CoinCount


func update_health(new_value):
	health_bar.value = new_value

func update_coin_count():
	coin_count.text = "$" + str(Globals.currentCoinCount)
