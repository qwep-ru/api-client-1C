﻿&НаКлиенте
Процедура Активировать(Отказ)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("vid", Элементы.ПоставщикКод.ТекстРедактирования);
	СтруктураПараметров.Вставить("bid", Элементы.ФилиалКод.ТекстРедактирования);
	СтруктураПараметров.Вставить("login", Объект.Логин);
	СтруктураПараметров.Вставить("password", Объект.Пароль);
	СтруктураПараметров.Вставить("parameters", Объект.ДопПараметрыАвторизации);
	СтруктураПараметров.Вставить("check", ПроверитьАвторизациюПередДобавлением);
	
	Код = QWEP_Клиент.ПолучитьКодАктивированногоАккаунта(СтруктураПараметров);
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Сообщить("Аккаунт не прошел аутентификацию. Проверьте правильность ввода логина и пароля.");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Объект.Код = Код;
	Объект.Включен = Истина;
	
	QWEP_Клиент.ПолучитьАккаунты();
	
	Закрыть(Новый Структура("Активирован", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикФилиалПриИзменении(Элемент)
	
	Объект.Наименование = Строка(Объект.Поставщик) + " " + Строка(Объект.Филиал);
	
КонецПроцедуры

&НаКлиенте

Процедура ПриОткрытии(Отказ)
	
	ПроверитьАвторизациюПередДобавлением = Истина;
	
КонецПроцедуры
