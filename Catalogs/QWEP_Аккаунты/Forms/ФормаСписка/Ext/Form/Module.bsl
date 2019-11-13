﻿
&НаКлиенте
Процедура ПолучитьАккаунты(Команда)
	
	QWEP_Сервер.ОчиститьСправочник("QWEP_Аккаунты");
	QWEP_Клиент.ПолучитьАккаунты();
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьАккаунт(Команда)
    ОткрытьФорму("Справочник.QWEP_Аккаунты.Форма.ФормаДобавленияАккаунта",, ЭтаФорма,,,, Новый ОписаниеОповещения("ДобавитьАккаунтЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьАккаунтЗавершение(Результат, ДополнительныеПараметры) Экспорт    
    Если НЕ Результат = неопределено И Результат.Свойство("Активирован") Тогда
        Элементы.Список.Обновить();    	    
    КонецЕсли;               
КонецПроцедуры

&НаКлиенте
Процедура УдалитьАккаунт(Команда)
	
	КодУдаляемогоАккаунта = Элементы.Список.ТекущиеДанные.Код;
	Если КодУдаляемогоАккаунта = "" Тогда
		Возврат;
	КонецЕсли;
	
	мАккаунтовДляУдаления = Новый Массив();
	мАккаунтовДляУдаления.Добавить(КодУдаляемогоАккаунта);
	
	мУдаленных = QWEP_Клиент.УдалитьАккаунтыНаAPI(мАккаунтовДляУдаления);
	
	Если мУдаленных.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Строка Из мУдаленных Цикл
        Сообщить("Аккаунт успешно удален. Код: " + Строка);
	КонецЦикла;
    
    Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключить(Команда)
	
	КодОбновляемогоАккаунта = Элементы.Список.ТекущиеДанные.Код;
	Включить = НЕ Элементы.Список.ТекущиеДанные.Включен;
	мДляИзменения = Новый Массив;	
	мДляИзменения.Добавить(КодОбновляемогоАккаунта);
	
    QWEP_Клиент.ОбновитьАккаунтыНаAPI(мДляИзменения, Включить);
    
    Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПокупок(Команда)
    
    МассивПокупок = QWEP_Клиент.ПолучитьСписокПокупок();
	
	//Ошибка
	Если МассивПокупок = Неопределено Тогда        	
        Возврат;
	КонецЕсли;
	
    Если ТипЗнч(МассивПокупок) = Тип("Массив") Тогда
        ОткрытьФорму("ОбщаяФорма.QWEPИсторияПокупок", Новый Структура("МассивПокупок", МассивПокупок), ЭтаФорма);       
    КонецЕсли; 
    
КонецПроцедуры



