﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Если Параметры.Свойство("МассивПокупок") Тогда        	
        Для каждого Покупка Из Параметры.МассивПокупок Цикл
            НоваяСтрока = ТаблицаТоваров.Добавить();
            ЗаполнитьЗначенияСвойств(НоваяСтрока, Покупка);
            timestamp = НоваяСтрока.boughtAt;
            НоваяСтрока.boughtAt = Дата("19700101") + ?(ТипЗнч(timestamp) = Тип("Строка"), Число(timestamp), timestamp);
        КонецЦикла;     
    КонецЕсли; 
    
КонецПроцедуры