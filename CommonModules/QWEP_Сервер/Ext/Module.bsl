﻿// Создает новю запись в РС QWEP_AccessToken
Процедура СоздатьНовуюЗаписьAccessToken(authorizationCode, ОтветСтруктура) Экспорт
	
	НоваяЗаписьРС = РегистрыСведений.QWEP_AccessToken.СоздатьМенеджерЗаписи();
	НоваяЗаписьРС.Период = ТекущаяДата();
	НоваяЗаписьРС.applicationNum = 1;
	НоваяЗаписьРС.authorizationCode = authorizationCode;
	НоваяЗаписьРС.token = ОтветСтруктура.token;
	НоваяЗаписьРС.type  = ОтветСтруктура.type;
	НоваяЗаписьРС.Записать();
	
КонецПроцедуры

// Возвращает ТокенДоступа для возможности отпаравки запросов на сервер 
Функция ПолучитьТокенДоступа() Экспорт
	
	ТокенДоступа = "";
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	QWEP_AccessTokenСрезПоследних.token КАК token,
	|	QWEP_AccessTokenСрезПоследних.type КАК type
	|ИЗ
	|	РегистрСведений.QWEP_AccessToken.СрезПоследних КАК QWEP_AccessTokenСрезПоследних";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТокенДоступа = Выборка.type + " " + Выборка.token;
	КонецЕсли;
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Сообщить("Для выполнения запросов к QWEP API получите токен доступа", СтатусСообщения.Важное);
	КонецЕсли;
	Возврат ТокенДоступа;
	
КонецФункции

// Создает новые или обновляет по ID элементы справочника Регионы
Процедура СоздатьОбновитьРегионы(МассивРегионов) Экспорт
	
	//Можно оптимизировать через запрос, в который на вход подать весь массив, но смысла большого нет, так как записей мало
	Для каждого Строка Из МассивРегионов Цикл
		Регион = Справочники.QWEP_Регионы.НайтиПоКоду(Строка.id);
		Если НЕ ЗначениеЗаполнено(Регион) Тогда
			Регион = Справочники.QWEP_Регионы.СоздатьЭлемент();
			Регион.Код = Строка.id;
			Регион.Наименование = Строка.title;
			Регион.Записать();
		ИначеЕсли НЕ Регион.Наименование = Строка.title Тогда
			Регион = Регион.ПолучитьОбъект();
			Регион.Наименование = Строка.title;
			Регион.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // СоздатьОбновитьРегионы()

// Создает новые или обновляет по ID элементы справочника Города
Процедура СоздатьОбновитьГорода(МассивГородов) Экспорт
	
	//Можно оптимизировать через запрос, в который на вход подать весь массив, но смысла большого нет, так как записей мало
	Для каждого Строка Из МассивГородов Цикл
		Город = Справочники.QWEP_Города.НайтиПоКоду(Строка.id);
		Если НЕ ЗначениеЗаполнено(Город) Тогда
			Город = Справочники.QWEP_Города.СоздатьЭлемент();
			Город.Код = Строка.id;
			Город.Наименование = Строка.title;
			Город.Регион = Справочники.QWEP_Регионы.НайтиПоКоду(Строка.rid);
			Город.Записать();
		ИначеЕсли НЕ Город.Наименование = Строка.title Тогда
			Город = Город.ПолучитьОбъект();
			Город.Наименование = Строка.title;
			Город.Регион = Справочники.QWEP_Регионы.НайтиПоКоду(Строка.rid);
			Город.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // СоздатьОбновитьРегионы()

// Создает новые или обновляет по ID элементы справочника Поставщики
Процедура СоздатьОбновитьПоставщиков(МассивЭлементов) Экспорт
	
	Для каждого Строка Из МассивЭлементов Цикл
		Поставщик = Справочники.QWEP_Поставщики.НайтиПоКоду(Строка.id);
		Если НЕ ЗначениеЗаполнено(Поставщик) Тогда
			Поставщик = Справочники.QWEP_Поставщики.СоздатьЭлемент();
		Иначе
			Поставщик = Поставщик.ПолучитьОбъект();
		КонецЕсли;
		Поставщик.Код = Строка.id;
		Поставщик.Наименование = Строка.title;
		Поставщик.Сайт = Строка.site;
		Поставщик.ДопПараметрыАвторизации = Строка.parameters;
		Поставщик.singleSession = Строка.singleSession;
		Поставщик.Города.Очистить();
		Если НЕ Строка.cities = Неопределено Тогда
			Для каждого СтрокаГород Из Строка.cities Цикл
				НоваяСтрока = Поставщик.Города.Добавить();
				НоваяСтрока.Город = Справочники.QWEP_Города.НайтиПоКоду(СтрокаГород.id);
			КонецЦикла;
		КонецЕсли;
		Поставщик.Записать();
		Если НЕ Строка.branches = Неопределено Тогда
			Для каждого СтрокаФилиал Из Строка.branches Цикл
				Филиал = Справочники.QWEP_ФилиалыПоставщиков.НайтиПоКоду(СтрокаФилиал.id);
				Если НЕ ЗначениеЗаполнено(Филиал) Тогда
					Филиал = Справочники.QWEP_ФилиалыПоставщиков.СоздатьЭлемент();
				Иначе
					Филиал = Филиал.ПолучитьОбъект();
				КонецЕсли;
				Филиал.Код = СтрокаФилиал.id;
				Филиал.Наименование = СтрокаФилиал.title;
				Филиал.Сайт = СтрокаФилиал.site;
				Филиал.Поставщик = Поставщик.Ссылка;
				Филиал.Записать();
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // СоздатьОбновитьРегионы()

// Создает новые или обновляет по ID элементы справочника Аккаунты
Процедура СоздатьОбновитьАккаунты(МассивЭлементов, ОбновлениеАккаунта=Ложь) Экспорт
	
	Для каждого Строка Из МассивЭлементов Цикл
		Аккаунт = Справочники.QWEP_Аккаунты.НайтиПоКоду(Строка.id);
		Если НЕ ЗначениеЗаполнено(Аккаунт) И НЕ ОбновлениеАккаунта Тогда
			Аккаунт = Справочники.QWEP_Аккаунты.СоздатьЭлемент();
		Иначе
			Аккаунт = Аккаунт.ПолучитьОбъект();
		КонецЕсли;
		Если ОбновлениеАккаунта Тогда            
			Аккаунт.Включен = Строка.enabled;
			Аккаунт.Записать();	            
		Иначе 
			Аккаунт.Код = Строка.id;
			Аккаунт.Поставщик = Справочники.QWEP_Поставщики.НайтиПоКоду(Строка.vid);
			Аккаунт.Филиал = Справочники.QWEP_ФилиалыПоставщиков.НайтиПоКоду(Строка.bid);
			Аккаунт.Наименование = СокрЛП(Строка(Аккаунт.Поставщик) + " " + Строка(Аккаунт.Филиал)) + " " + Строка.login;
			Аккаунт.Логин = Строка.login;
			Аккаунт.ДопПараметрыАвторизации = Строка.parameters;
			Аккаунт.Промо = Строка.promo;
			Аккаунт.Включен = Строка.enabled;
			Аккаунт.Записать();
		КонецЕсли;
	КонецЦикла;        
	
КонецПроцедуры

// Добавляет новые записи в рс РезультатыПоиска
Процедура СоздатьЗаписиРСРезультатыПоиска(ОтветОбъект, ИдентификаторПоиска, ПараметрыЗапроса, ОчищатьРезультаты=Истина, НетПредложений=Ложь) Экспорт

	Если ОчищатьРезультаты Тогда
		НаборЗаписей = РегистрыСведений.QWEP_РезультатыПоиска.СоздатьНаборЗаписей();
		НаборЗаписей.Записать();
	КонецЕсли;
	
	МассивРезультатов = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.flatResults.items");    
    Если МассивРезультатов <> Неопределено И МассивРезультатов.Количество() = 0 Тогда
        НетПредложений = Истина;            
	КонецЕсли;
	
	МассивУточнений   = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.flatResults.clarifications");
	Если МассивРезультатов = Неопределено И МассивУточнений = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗапроса.Свойство("article") Тогда
		АртикулПоиска = ПараметрыЗапроса.article;
	КонецЕсли;
	Если ПараметрыЗапроса.Свойство("brand") Тогда
		БрендПоиска = ПараметрыЗапроса.brand;	
	КонецЕсли;
	
	ДатаПоиска = ТекущаяДата();
	Если НЕ МассивРезультатов = Неопределено Тогда
		Для каждого Строка Из МассивРезультатов Цикл
			НоваяЗапись = РегистрыСведений.QWEP_РезультатыПоиска.СоздатьМенеджерЗаписи();
			НоваяЗапись.ИдентификаторПоиска = ИдентификаторПоиска;
			НоваяЗапись.АртикулПоиска 	= АртикулПоиска; 
			НоваяЗапись.БрендПоиска 	= БрендПоиска;
			НоваяЗапись.ДатаПоиска 		= ДатаПоиска;
			НоваяЗапись.ИдентификаторСтроки = Строка.itemId;
			
			НоваяЗапись.Артикул = Строка.article;
			НоваяЗапись.Филиал = Строка.branchTitle;
			НоваяЗапись.Бренд = Строка.brand;
			НоваяЗапись.Срок = Строка.delivery;
			НоваяЗапись.ДопИнфо = Строка.notes;
			НоваяЗапись.АртикулПоставщика = Строка.originalArticle;
			НоваяЗапись.Фото = Строка.photo;
			НоваяЗапись.ЦенаЗначение = Строка.price.value;
			НоваяЗапись.НаличиеФормат = Строка.quantity.formatted;
			НоваяЗапись.Состояние = Строка.status;
			НоваяЗапись.Метро = Строка.subway;
			НоваяЗапись.Наименование = Строка.title;
			НоваяЗапись.Поставщик = Строка.vendorTitle;
			НоваяЗапись.Склад = Строка.warehouse;
            НоваяЗапись.Действие = ?(НЕ ПустаяСтрока(Строка.itemId), "Купить", "");
			
			НоваяЗапись.Записать();
		КонецЦикла;
	КонецЕсли;
	                       
	Если НЕ МассивУточнений = Неопределено Тогда
		Для каждого Строка Из МассивУточнений Цикл
			НоваяЗапись = РегистрыСведений.QWEP_РезультатыПоиска.СоздатьМенеджерЗаписи();
			НоваяЗапись.ИдентификаторПоиска = ИдентификаторПоиска;
			НоваяЗапись.АртикулПоиска 	= АртикулПоиска; 
			НоваяЗапись.БрендПоиска 	= БрендПоиска;
			НоваяЗапись.ДатаПоиска 		= ДатаПоиска;
            НоваяЗапись.ИдентификаторСтроки = Строка.clarificationId;
			
			НоваяЗапись.Артикул = Строка.article;
			НоваяЗапись.ИдентификаторУточнения = Строка.clarificationId;
			НоваяЗапись.Бренд = Строка.brand;
			НоваяЗапись.ДопИнфо = Строка.notes;
			НоваяЗапись.Фото = Строка.photo;
			НоваяЗапись.Наименование = Строка.title;
			НоваяЗапись.Поставщик = Строка.vendorTitle;
			НоваяЗапись.ЭтоУточнение = Истина;
			НоваяЗапись.Действие = "Раскрыть уточнение";
			
			НоваяЗапись.Записать();
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

// Непосредственная отправка синхронного запроса POST и получение ответа от API QWEP
Функция ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа=Неопределено) Экспорт

	СтуктураЗапроса = Новый Структура;
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("RequestData", ПараметрыЗапроса);
	СтуктураЗапроса.Вставить("Request", СтруктураДанные);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();	
	ЗаписатьJSON(ЗаписьJSON, СтуктураЗапроса);
	
	ТелоЗапроса = ЗаписьJSON.Закрыть();
	
	Соединение = Новый HTTPСоединение("userapi.qwep.ru",,,,,,Новый ЗащищенноеСоединениеOpenSSL());
	Запрос = Новый HTTPЗапрос;
	Запрос.АдресРесурса = АдресРесурса;
	
	Если НЕ ПустаяСтрока(ТокенДоступа) Тогда
		Запрос.Заголовки.Вставить("Authorization", ТокенДоступа);
	КонецЕсли;
	Запрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Ответ = Соединение.ОтправитьДляОбработки(Запрос,,ИспользованиеByteOrderMark.НеИспользовать);
	ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТелоОтвета);
	ОтветОбъект = ПрочитатьJSON(ЧтениеJSON);
	
	Возврат ОтветОбъект;

КонецФункции

// Рекурсивная функция для безопасного получения свойства структуры
Функция ПолучитьЗначениеСвойстваОбъектаСтруктуры(Структура, ПолноеИмяСвойства) Экспорт

	Если НЕ ТипЗнч(Структура) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПозицияПервойТочки = Найти(ПолноеИмяСвойства, ".");
	Если ПозицияПервойТочки > 0 Тогда
		ИмяСвойства = Лев(ПолноеИмяСвойства, ПозицияПервойТочки - 1);
		ИмяСвойстваХвост = Сред(ПолноеИмяСвойства, ПозицияПервойТочки + 1);
	Иначе
		ИмяСвойства = ПолноеИмяСвойства;
		ИмяСвойстваХвост = "";
	КонецЕсли;
	СвойствоСтруктуры = Структура.Свойство(ИмяСвойства);
	Если СвойствоСтруктуры = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	НовыйСтруктура = Структура[ИмяСвойства];
	Если ПустаяСтрока(ИмяСвойстваХвост) Тогда
		Если ТипЗнч(НовыйСтруктура) = Тип("Строка") Тогда
			Если НовыйСтруктура = "true" Тогда
				НовыйСтруктура = Истина;
			ИначеЕсли НовыйСтруктура = "false" Тогда
				НовыйСтруктура = Ложь;
			КонецЕсли;
		КонецЕсли;
		Возврат НовыйСтруктура;
	Иначе
		Возврат ПолучитьЗначениеСвойстваОбъектаСтруктуры(НовыйСтруктура, ИмяСвойстваХвост);
	КонецЕсли;
	
КонецФункции

// Получения константы по имени
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт

	Если ПустаяСтрока(ИмяКонстанты) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Константы[ИмяКонстанты].Получить();

КонецФункции

// Выбор аккаунтов из спр. QWEP_Аккаунты с флагом Включен
Функция ПолучитьМассивАккаунтовДляПоиска() Экспорт
    
    мАккаунтов = Новый Массив;
    Запрос = Новый Запрос;
    Запрос.Текст = "ВЫБРАТЬ
    |	QWEP_Аккаунты.Код КАК Код
    |ИЗ
    |	Справочник.QWEP_Аккаунты КАК QWEP_Аккаунты
    |ГДЕ
    |	QWEP_Аккаунты.Включен";
    мКодовАккаунтов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Код");
    Для каждого КодАккаунта Из мКодовАккаунтов Цикл
        мАккаунтов.Добавить(Новый Структура("id", КодАккаунта));
    КонецЦикла;
	
	Возврат мАккаунтов;
    
КонецФункции

// Удаление строки рс QWEP_РезультатыПоиска по идентификатору строки
Процедура УдалитьСтрокуРСРезультатыПоиска(ИдентификаторСтроки) Экспорт
    
	Если НЕ ЗначениеЗаполнено(ИдентификаторСтроки) Тогда
		Возврат;
	КонецЕсли;
	НаборЗаписейДляУдаления = РегистрыСведений.QWEP_РезультатыПоиска.СоздатьНаборЗаписей();
	НаборЗаписейДляУдаления.Отбор.ИдентификаторСтроки.Установить(ИдентификаторСтроки);
	НаборЗаписейДляУдаления.Прочитать();
	НаборЗаписейДляУдаления.Удалить(0);
	НаборЗаписейДляУдаления.Записать();
        
КонецПроцедуры

// Удаление записей спр QWEP_Аккаунты по массиву кодов
Процедура УдалитьАккаунтыИзСправочника(мУдаляемыхКодов) Экспорт

    Если мУдаляемыхКодов.Количество() = 0 Тогда        	
        Возврат;
    КонецЕсли;
    
    Запрос = Новый Запрос;
    Запрос.Текст = 
    "ВЫБРАТЬ
    |   QWEP_Аккаунты.Ссылка КАК Ссылка
    |ИЗ
    |   Справочник.QWEP_Аккаунты КАК QWEP_Аккаунты
    |ГДЕ
    |   QWEP_Аккаунты.Код В (&мУдаляемыхКодов)";
    
    Запрос.УстановитьПараметр("мУдаляемыхКодов", мУдаляемыхКодов);
    
    РезультатЗапроса = Запрос.Выполнить();
    
    ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
    
    Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
        СправочникОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
        СправочникОбъект.Удалить();
    КонецЦикла;        

КонецПроцедуры
 
// Добавляет новые записи в рс ИсторияЗаказов
Процедура СоздатьЗаписиРСИсторияЗаказов(ОтветОбъект) Экспорт
	
	НаборЗаписей = РегистрыСведений.QWEP_ИсторияЗаказов.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
	МассивЗаказов = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.orders");
	
	Если НЕ МассивЗаказов = Неопределено Тогда
		Для каждого Строка Из МассивЗаказов Цикл
			
			МассивТоваровЗаказа = Строка.content;
			СтрокаДата = СтрЗаменить(СтрЗаменить(СтрЗаменить(Строка.datetime, " ", ""), "-", ""), ":", "");
			СтрокаДата = Формат(Дата(СтрокаДата), "ДФ=""дд ММММ гггг""");
			ДатаНомерЗаказа = "Заказ №" + Строка.number + " от " + СтрокаДата + " на сумму " + Строка.total + " руб. Статус: " + Строка.status;
			
			Если МассивТоваровЗаказа = Неопределено ИЛИ МассивТоваровЗаказа.Количество() = 0 Тогда
				НоваяЗапись = РегистрыСведений.QWEP_ИсторияЗаказов.СоздатьМенеджерЗаписи();
				
				НоваяЗапись.УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
				НоваяЗапись.НомерДатаЗаказа = ДатаНомерЗаказа;
				НоваяЗапись.КомментарийЗаказа = Строка.comment;
				
				НоваяЗапись.Записать();
			Иначе
				Для каждого Товар Из МассивТоваровЗаказа Цикл
					НоваяЗапись = РегистрыСведений.QWEP_ИсторияЗаказов.СоздатьМенеджерЗаписи();
					
					НоваяЗапись.УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
					НоваяЗапись.НомерДатаЗаказа = ДатаНомерЗаказа;
					НоваяЗапись.Артикул = Товар.article;
					НоваяЗапись.Бренд = Товар.brand;
					НоваяЗапись.Наименование = Товар.partname;
					НоваяЗапись.Цена = Товар.price;
					НоваяЗапись.Количество = Товар.quantity;
					НоваяЗапись.Склад = Товар.warehouse;
					НоваяЗапись.Статус = Товар.status;
					НоваяЗапись.Комментарий = Товар.comment;
					НоваяЗапись.КомментарийЗаказа = Строка.comment;
					
					НоваяЗапись.Записать();
				КонецЦикла; 
			КонецЕсли; 
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Удаляет все элементы справочника
Процедура ОчиститьСправочник(ИмяСправочника) Экспорт
	
	Выборка = Справочники[ИмяСправочника].Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.ПолучитьОбъект();
		Объект.Удалить();
	КонецЦикла;
	
КонецПроцедуры
