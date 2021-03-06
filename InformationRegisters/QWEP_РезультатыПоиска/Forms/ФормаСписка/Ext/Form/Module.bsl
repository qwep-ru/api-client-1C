﻿&НаКлиенте
Процедура Поиск(Команда)
	
	Если СтрДлина(РеквизитАртикулПоиска) < 4 Тогда
		Сообщить("Укажите артикул, не менее 4 символов");
		Возврат;
    КонецЕсли;
    КоличествоПредложений = 0;
    КоличествоУточнений = 0;
    ВсегоПредложений = 0;
    ВсегоУточнений = 0;
    ОчиститьСообщения();
    
	ВыполнитьПоискНаКлиенте();
    
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоискНаКлиенте()        
    
    ПараметрыЗапроса = Новый Структура;
    ПараметрыЗапроса.Вставить("article", 			РеквизитАртикулПоиска);
    ПараметрыЗапроса.Вставить("brand", 				РеквизитБрендПоиска);
    ПараметрыЗапроса.Вставить("timeout", 			РеквизитТаймаут * 1000);
    ПараметрыЗапроса.Вставить("excludePromo", 		РеквизитИсключитьПромо);
    ПараметрыЗапроса.Вставить("flatView", 			РеквизитПлоскийВид);
    ПараметрыЗапроса.Вставить("type", 				?(РеквизитАсинхронныйЗапрос, 1, 0));
    ПараметрыЗапроса.Вставить("openAllClarifications", 	РеквизитРаскрыватьВсеУточнения);
    ИдентификаторПоиска = "";
	
    ТокенДоступа = QWEP_Сервер.ПолучитьТокенДоступа();
    Если ПустаяСтрока(ТокенДоступа) Тогда        	
        СтруктураПараметров = Новый Структура;
        ОповещениеПослеВвода = Новый ОписаниеОповещения("ПослеВводаКодаАвторизации", ЭтаФорма, СтруктураПараметров);
        ПоказатьВводСтроки(ОповещениеПослеВвода, , "Введите код авторизации для получения Токена", 36, Ложь);
    КонецЕсли;
	
	ТокенДоступа = QWEP_Сервер.ПолучитьТокенДоступа();
    Если ПустаяСтрока(ТокенДоступа) Тогда        	
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(РеквизитБрендПоиска) Тогда
        МассивКороткихАртикулов = QWEP_Клиент.ВыполнитьЗапросНаСерверПередПоиском(ПараметрыЗапроса, ТокенДоступа);
        Если ТипЗнч(МассивКороткихАртикулов) = Тип("Массив") И МассивКороткихАртикулов.Количество() > 0 Тогда
			ПараметрыФормы = Новый Структура("МассивКороткихАртикулов", МассивКороткихАртикулов);
			ОО = Новый ОписаниеОповещения("ПоискПослеВыбораКороткогоАртикула", ЭтотОбъект, Новый Структура("ПараметрыЗапроса", ПараметрыЗапроса));
			ОткрытьФорму("РегистрСведений.QWEP_РезультатыПоиска.Форма.ВыборВариантаКороткогоАртикула", ПараметрыФормы, ЭтаФорма,,,, ОО);
            Возврат;
        КонецЕсли;        
    КонецЕсли;
	
	QWEP_Клиент.ВыполнитьПоиск(ПараметрыЗапроса, ИдентификаторПоиска, ВсегоУточнений, ВсегоПредложений);

    ПоискЗавершен = Ложь;
    ПополнитьРезультаты();
    Элементы.Список.Обновить();        

КонецПроцедуры

&НаКлиенте
Процедура ПоискПослеВыбораКороткогоАртикула(Результат, ДополнительныеПараметры) Экспорт
    
    ИдентификаторПоиска = "";
    ПараметрыЗапроса = ДополнительныеПараметры.ПараметрыЗапроса;     
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("ИдентификаторКороткогоАртикула") И Результат.Свойство("Бренд") Тогда
		
		Если ПараметрыЗапроса.Свойство("brand") Тогда        	
            ПараметрыЗапроса.brand = Результат.Бренд;
        Иначе
            ПараметрыЗапроса.Вставить("brand", Результат.Бренд);            
        КонецЕсли;
		
		Если ПараметрыЗапроса.Свойство("shortArticle") Тогда        	
            ПараметрыЗапроса.shortArticle = Результат.ИдентификаторКороткогоАртикула;
        Иначе
            ПараметрыЗапроса.Вставить("shortArticle", Результат.ИдентификаторКороткогоАртикула);            
		КонецЕсли;
		
	КонецЕсли;
	
	QWEP_Клиент.ВыполнитьПоиск(ПараметрыЗапроса, ИдентификаторПоиска, ВсегоУточнений, ВсегоПредложений);
	
    ПоискЗавершен = Ложь;
    ПополнитьРезультаты();
    Элементы.Список.Обновить();
    
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаКодаАвторизации(КодАвторизации, ДополнительныеПараметры) Экспорт
    
    ОчиститьСообщения();
    ТокенУспешноПолучен = Ложь;
    QWEP_Клиент.ПолучитьAccessToken(КодАвторизации, ТокенУспешноПолучен);
    
    Если ТокенУспешноПолучен Тогда        
        ВыполнитьПоискНаКлиенте();            
    КонецЕсли;

КонецПроцедуры  

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РеквизитПлоскийВид = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьРезультаты(Команда)
	
	ПополнитьРезультаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПополнитьРезультаты()
        
    Если НЕ РеквизитАсинхронныйЗапрос ИЛИ ПустаяСтрока(ИдентификаторПоиска) Тогда
        Сообщить("Поиск завершен! Всего отражено предложений: " + ВсегоПредложений + "; уточнений: " + ВсегоУточнений);
        Возврат;	
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("searchId", 			ИдентификаторПоиска);
	ПараметрыЗапроса.Вставить("flatView", 			РеквизитПлоскийВид);
	
	КоличествоУточнений = 0;
    КоличествоПредложений = 0;
	
	QWEP_Клиент.ПолучитьГотовуюПорциюРезультатов(ПараметрыЗапроса, ИдентификаторПоиска, Ложь, ПоискЗавершен, КоличествоПредложений, КоличествоУточнений);
    ВсегоУточнений = ВсегоУточнений + КоличествоУточнений;
    ВсегоПредложений = ВсегоПредложений + КоличествоПредложений;
	
	Элементы.Список.Обновить();    
	
	Если НЕ ПустаяСтрока(ИдентификаторПоиска) Тогда
		ПодключитьОбработчикОжидания("ПополнитьРезультаты", 3, Истина);	
    КонецЕсли;     
	
	Если ПоискЗавершен Тогда        	
		Сообщить("Поиск завершен! Всего отражено предложений: " + ВсегоПредложений + "; уточнений: " + ВсегоУточнений);
    ИначеЕсли КоличествоПредложений > 0 ИЛИ КоличествоУточнений > 0 Тогда
		Сообщить("Добавлено предложений: " + КоличествоПредложений + "; уточнений: " + КоличествоУточнений);
    КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
	
	Если НЕ Поле.Имя = "Действие" Тогда
		Возврат;	
	КонецЕсли;
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	
	Если ТекущаяСтрока.ЭтоУточнение Тогда
		РаскрытьУточнение(ТекущаяСтрока);
    ИначеЕсли НЕ ПустаяСтрока(ТекущаяСтрока.ИдентификаторСтроки) И ТекущаяСтрока.Действие = "Купить" Тогда
        ДобавитьВКорзину(Неопределено);
    КонецЕсли;
	
	Элементы.Список.Обновить();
    
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьУточнение(ТекущаяСтрока)
    
    ОчиститьСообщения();
    ПараметрыЗапроса = Новый Структура;
    ПараметрыЗапроса.Вставить("flatView", 			РеквизитПлоскийВид);
    ПараметрыЗапроса.Вставить("clarificationId", 	ТекущаяСтрока.ИдентификаторУточнения);
    ПараметрыЗапроса.Вставить("type", 				0); //Раскрываем уточнения синхронно
    
    QWEP_Клиент.РаскрытьУточнение(ПараметрыЗапроса);
    QWEP_Сервер.УдалитьСтрокуРСРезультатыПоиска(ТекущаяСтрока.ИдентификаторСтроки);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВКорзину(Команда)
    
    Количество = 1;    
    ПоказатьВводЧисла(Новый ОписаниеОповещения("ДобавитьВКорзинуПослеВвода", ЭтотОбъект, ), Количество, "Введите необходимое количество"); 
    
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВКорзинуПослеВвода(Число, ДополнительныеПараметры) Экспорт
    
    Если НЕ Число = Неопределено И Число > 0 Тогда
		ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
        Если ТекущаяСтрока = Неопределено Тогда                	
            Возврат;
        КонецЕсли;          
        
        ПараметрыЗапроса = Новый Структура;
        ПараметрыЗапроса.Вставить("itemId", 			ТекущаяСтрока.ИдентификаторСтроки);
        ПараметрыЗапроса.Вставить("quantity", 	        Число);
        ПараметрыЗапроса.Вставить("comment", 	        ""); 
        ПараметрыЗапроса.Вставить("type", 				0); //Раскрываем уточнения синхронно
		
		УспешноДобавлен = QWEP_Клиент.ДобавитьВКорзину(ПараметрыЗапроса);
        Если УспешноДобавлен Тогда                	
            Сообщить("Товар успешно добавлен в корзину");
        Иначе
            Сообщить("Во время добавления товара в корзину возникли ошибки");
		КонецЕсли; 
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФорматОбменаДанными = Константы.QWEP_ФорматОбменаДанными.Получить();
	Если НЕ ЗначениеЗаполнено(ФорматОбменаДанными) Тогда
		Константы.QWEP_ФорматОбменаДанными.Установить("json");
	КонецЕсли;

КонецПроцедуры
