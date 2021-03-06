﻿
&НаКлиенте
Процедура Активировать(Отказ)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("vid", Элементы.ПоставщикКод.ТекстРедактирования);
	СтруктураПараметров.Вставить("bid", Элементы.ФилиалКод.ТекстРедактирования);
	СтруктураПараметров.Вставить("login", Объект.Логин);
	СтруктураПараметров.Вставить("password", Объект.Пароль);
	СтруктураПараметров.Вставить("parameters", Объект.ДопПараметрыАвторизации);
	
	Код = QWEP_Клиент.ПолучитьКодАктивированногоАккаунта(СтруктураПараметров);
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Объект.Код = Код;
	Объект.Включен = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЭтоНовый Тогда
		Активировать(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикФилиалПриИзменении(Элемент)
	
	Объект.Наименование = Строка(Объект.Поставщик) + Строка(Объект.Филиал);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоНовый = НЕ ЗначениеЗаполнено(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКорзину(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("accountId", Объект.Код);
	ОбъектКорзина = QWEP_Клиент.ПолучитьКорзинуАккаунта(СтруктураПараметров);
	
	ОбновитьДанныеКорзины(ОбъектКорзина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеКорзины(ОбъектКорзина)

	Объект.Корзина.Очистить();
	Элементы.ТекущаяКорзина.СписокВыбора.Очистить();
	Корзины = QWEP_Клиент.ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОбъектКорзина, "entity.baskets");
	Если Корзины = Неопределено Тогда
	    Возврат;
	КонецЕсли;
	ВсегоКорзин = Корзины.Количество();
	ПНКорзины = 0;
	Для каждого Корзина Из Корзины Цикл
		ПНКорзины = ПНКорзины + 1;
		Элементы.ТекущаяКорзина.СписокВыбора.Добавить(Корзина.basketId, "Корзина " + ПНКорзины + " из " + ВсегоКорзин);
		ТекущаяКорзина = Корзина.basketId;
		Для каждого СтрокаКорзины Из Корзина.basketItems Цикл
			НоваяСтрока = Объект.Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКорзины);
			НоваяСтрока.basketId = Корзина.basketId;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры


&НаКлиенте
Процедура ОчиститьКорзину(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("accountId", Объект.Код);
	СтруктураПараметров.Вставить("basketId", ТекущаяКорзина);
	ОбъектКорзина = QWEP_Клиент.ОчиститьКорзинуАккаунта(СтруктураПараметров);
	
	ОбновитьДанныеКорзины(ОбъектКорзина);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтрокуКорзины(Команда)
	
	ТекСтрока = Элементы.Корзина.ТекущиеДанные;
	Если Элементы.Корзина.ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("accountId", Объект.Код);
	СтруктураПараметров.Вставить("basketId", ТекущаяКорзина);
	СтруктураПараметров.Вставить("basketItemId", ТекСтрока.basketItemId);
	ОбъектКорзина = QWEP_Клиент.УдалитьСтрокуКорзиныАккаунта(СтруктураПараметров);
	
	ОбновитьДанныеКорзины(ОбъектКорзина);
	
КонецПроцедуры


&НаКлиенте
Процедура КорзинаquantityПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Корзина.ТекущиеДанные;
	Если Элементы.Корзина.ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("accountId", Объект.Код);
	СтруктураПараметров.Вставить("basketId", ТекущаяКорзина);
	СтруктураПараметров.Вставить("basketItemId", ТекСтрока.basketItemId);
	СтруктураПараметров.Вставить("quantity", ТекСтрока.quantity);
	ОбъектКорзина = QWEP_Клиент.ИзменитьКоличествоПоСтрокеКорзины(СтруктураПараметров);
	
	ОбновитьДанныеКорзины(ОбъектКорзина);
	
КонецПроцедуры

