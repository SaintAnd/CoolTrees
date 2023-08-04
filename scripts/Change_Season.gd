extends CanvasLayer


onready var choice = $Stuka # подключаем кнопку
onready var themes = get_node("../Seasons").get_children() # массив тем травы
onready var previous = themes[0] # сохраняем "предыдущее" время года для смены
onready var d_or_n = get_node("../../../While_Day_hight_not_ready")

func _ready():
	choice.connect("item_selected", self, "on_item_selected") # подключаем сигнал при смене выбора
	add_items() # активируем метод добавления элементов
	
	
func add_items():
	choice.add_item("Spring") # добавляем элементы собственно
	choice.add_item("Summer")
	choice.add_item("Autumn")
	choice.add_item("Winter")

func on_item_selected(id): # 
	themes[id].show() # показываем выбранное время года
	previous.hide() # прячем прошлое 
	
	previous = themes[id] # обновляем предыдущее время года

