extends CanvasLayer


onready var choice = $Change_Seasons # подключаем кнопку
onready var themes = $"../Environment/Grass/Seasons".get_children() # массив тем травы
onready var previous = themes[0] # сохраняем "предыдущее" время года для смены
onready var heart = $"../Environment/Seed/Seed/Rooms_Manager/Rooms/Heart_Room"

func _ready():
	choice.connect("item_selected", self, "on_item_selected") # подключаем сигнал при смене выбора
	add_items() # активируем метод добавления элементов
	
	
func add_items():
	choice.add_item("Весна") # добавляем элементы собственно
	choice.add_item("Лето")
	choice.add_item("Осень")
	choice.add_item("Зима")

func on_item_selected(id): # 
	themes[id].show() # показываем выбранное время года
	previous.hide() # прячем прошлое 
	
	previous = themes[id] # обновляем предыдущее время года
	
	
func new_worker():
	if heart.is_born == true:
		heart.add_worker()

