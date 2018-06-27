﻿// Получает или обновляет элементы справочника Регионы из QWEP API
Процедура ПолучитьРегионы() Экспорт
	
	ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат;
	КонецЕсли;
	ПараметрыЗапроса = Новый Структура;
	АдресРесурса = "/geo/regions";
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "RegionsResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
    Если ОтветОбъект = Неопределено Тогда
		Возврат;	
    КонецЕсли;
	
	МассивЭлементов = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.regions");
	Если НЕ ТипЗнч(МассивЭлементов) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	Если МассивЭлементов.Количество() > 0 Тогда
		QWEP_Сервер.СоздатьОбновитьРегионы(МассивЭлементов);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает ТокенДоступа для возможности отпаравки запросов на сервер 
Функция ПолучитьТокенДоступа() Экспорт
	
	Возврат QWEP_Сервер.ПолучитьТокенДоступа();			
	
КонецФункции

// Получает новый Access Token по указанному authorizationCode и добавляет запись в рс
Процедура ПолучитьAccessToken(authorizationCode, ТокенУспешноПолучен=Ложь) Экспорт
	
	Если ПустаяСтрока(authorizationCode) Тогда
		Возврат;
	КонецЕсли;
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("authorizationCode", authorizationCode);
	ПараметрыЗапроса.Вставить("applicationNum", 1);
	
	АдресРесурса = "/authorization";
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса,, "AuthorizationResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат;	
    КонецЕсли;
	
    ОтветСтруктура = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity"); 
	Если ОтветСтруктура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
    QWEP_Сервер.СоздатьНовуюЗаписьAccessToken(authorizationCode, ОтветСтруктура);     
    
	ТокенУспешноПолучен = Истина;    
    
КонецПроцедуры

// Получает информацию о приложении
Функция ПолучитьИнформациюОПриложении() Экспорт

    ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат Неопределено;
    КонецЕсли;
    
    СвойстваПриложения = Новый Соответствие;
    СвойстваПриложения.Вставить("clientNameclient", "Информация о клиенте");
    СвойстваПриложения.Вставить("descriptionpackage", "Описание пакета");
    СвойстваПриложения.Вставить("packageNamepackage", "Название пакета");
    СвойстваПриложения.Вставить("pricepackage", "Цена пакета");
    СвойстваПриложения.Вставить("requestLimitpackageStatus", "Оставшийся лимит поисков");
    СвойстваПриложения.Вставить("requestLimitpackage", "Месячный лимит поисков");
    СвойстваПриложения.Вставить("reserveLimitpackage", "Резервный лимит поисков (активируется, когда основной лимит исчерпан)");
    СвойстваПриложения.Вставить("paidTillpackageStatus", "Окончание действия оплаченного периода");
    СвойстваПриложения.Вставить("periodEndpackageStatus", "Окончание действия текущего периода");    
    СвойстваПриложения.Вставить("applicationName", "Наименование приложения");
    СвойстваПриложения.Вставить("applicationNum", "ID приложения");
    СвойстваПриложения.Вставить("package", "Пакет");
    СвойстваПриложения.Вставить("packageStatus", "Статус пакета");
    СвойстваПриложения.Вставить("client", "Клиент");
    
    АдресРесурса = "/applicationInfo";                          
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, Новый Структура, ТокенДоступа, "ApplicationInfoResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат Неопределено;	
    КонецЕсли;

	ИнформацияОПриложении = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity");
	
	ИнформацияОПриложенииТекст = "";
    Для каждого Элемент Из ИнформацияОПриложении Цикл        	
        Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда                	
            ИнформацияОПриложенииТекст = ИнформацияОПриложенииТекст + Символы.ПС + СвойстваПриложения.Получить(Элемент.Ключ) + Символы.ПС;
            Для каждого ЭлементСтруктуры Из Элемент.Значение Цикл
                Если СвойстваПриложения.Получить(ЭлементСтруктуры.Ключ + Элемент.Ключ) = Неопределено Тогда                                	
                    Продолжить;
                Иначе                 
                    ИнформацияОПриложенииТекст = ИнформацияОПриложенииТекст + СвойстваПриложения.Получить(ЭлементСтруктуры.Ключ + Элемент.Ключ) + ": " + ЭлементСтруктуры.Значение + Символы.ПС;    
                КонецЕсли;                 
            КонецЦикла;    
        Иначе
            Если СвойстваПриложения.Получить(Элемент.Ключ) = Неопределено Тогда
                Продолжить;
            Иначе
                ИнформацияОПриложенииТекст = ИнформацияОПриложенииТекст + СвойстваПриложения.Получить(Элемент.Ключ) + ": " + Элемент.Значение + Символы.ПС;
            КонецЕсли;             
        КонецЕсли; 
    КонецЦикла;
    Возврат ИнформацияОПриложенииТекст;

КонецФункции
 
// Проверяет ответ на наличие ошибок и выводит их 
Процедура ПроверитьВывестиОшибки(ОтветОбъект)
    
	Если ТипЗнч(ОтветОбъект) <> Тип("Структура") Тогда
		Сообщить("Ошибка: Ответ от API не получен");
		Возврат;
	КонецЕсли;
	МассивОшибок = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "errors");
    Если ТипЗнч(МассивОшибок) = Тип("Массив") Тогда
        Для каждого Элемент Из МассивОшибок Цикл
            ДеталиОшибки = "";
            Если Элемент.Свойство("details") И НЕ ПустаяСтрока(Элемент.details) Тогда
                ДеталиОшибки = ". Подробности: " + Элемент.details;                	            
            КонецЕсли; 
            Сообщить("Ошибка: " +  Элемент.code + " " + Элемент.message + ДеталиОшибки);
        КонецЦикла; 
    КонецЕсли;	

КонецПроцедуры
 
// Возвращает объект(структуру) ответа от сервера API на запрос
Функция ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа="", ИмяОбъектаОтвета)
	
	Формат = QWEP_Сервер.ПолучитьЗначениеКонстанты("QWEP_ФорматОбменаДанными");
	Если ПустаяСтрока(Формат) Тогда
		Сообщить("Заполните константу 'Формат обмена данными' (Раздел Сервис)");
		Возврат Неопределено;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		
		Возврат QWEP_Сервер.ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, Формат);
		
	#Иначе	
		
		Соединение = Новый HTTPСоединение("userapi.qwep.ru",,,,,,Новый ЗащищенноеСоединениеOpenSSL());
		Запрос = Новый HTTPЗапрос;
		Запрос.АдресРесурса = АдресРесурса + "?" + Формат;
		Если НЕ ПустаяСтрока(ТокенДоступа) Тогда
			Запрос.Заголовки.Вставить("Authorization", ТокенДоступа);
		КонецЕсли;
		ТелоЗапроса = ПолучитьТелоЗапросаUSERAPI(ПараметрыЗапроса, Формат);
		Запрос.УстановитьТелоИзСтроки(ТелоЗапроса);
		Ответ = Соединение.ОтправитьДляОбработки(Запрос,,ИспользованиеByteOrderMark.НеИспользовать);
		ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
		
		ОтветОбъект = ПолучитьОбъектОтвет(ТелоОтвета, ИмяОбъектаОтвета, Формат);
		
		Возврат ОтветОбъект;
		
	#КонецЕсли
	
КонецФункции

//Возвращет Заполненное тело запроса для отправки на USERAPI
Функция ПолучитьТелоЗапросаUSERAPI(ПараметрыЗапроса, Формат)
	
	Если ПараметрыЗапроса.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Если Формат = "xml" Тогда
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку();
		ЗаписьXML.ЗаписатьОбъявлениеXML();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("Request");
		ЗаписьXML.ЗаписатьНачалоЭлемента("RequestData");
		
		ДобавитьСтруктуруАргументовВXML(ЗаписьXML, ПараметрыЗапроса);
		
		ЗаписьXML.ЗаписатьКонецЭлемента();//RequestData
		ЗаписьXML.ЗаписатьКонецЭлемента();//Request
		
		ТелоЗапроса = ЗаписьXML.Закрыть();
	ИначеЕсли Формат = "json" Тогда
		СтуктураЗапроса = Новый Структура;
		СтруктураДанные = Новый Структура;
		СтруктураДанные.Вставить("RequestData", ПараметрыЗапроса);
		СтуктураЗапроса.Вставить("Request", СтруктураДанные);
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();	
		ЗаписатьJSON(ЗаписьJSON, СтуктураЗапроса);
		ТелоЗапроса = ЗаписьJSON.Закрыть();
	Иначе//Неизвестный формат
		Возврат "";
	КонецЕсли;
	
	Возврат ТелоЗапроса;
	
КонецФункции

Процедура ДобавитьСтруктуруАргументовВXML(ЗаписьXML, СтруктураАргументов)
	
	Для каждого Аргумент Из СтруктураАргументов Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента(Аргумент.Ключ);
		Если ТипЗнч(Аргумент.Значение) = Тип("Массив") Тогда
			Для каждого СтрокаКоллекции Из Аргумент.Значение Цикл
				ЗаписьXML.ЗаписатьНачалоЭлемента("item");
				ДобавитьСтруктуруАргументовВXML(ЗаписьXML, СтрокаКоллекции);
				ЗаписьXML.ЗаписатьКонецЭлемента();
			КонецЦикла;
		ИначеЕсли ТипЗнч(Аргумент.Значение) = Тип("Структура") Тогда
			ДобавитьСтруктуруАргументовВXML(ЗаписьXML, Аргумент.Значение);
		Иначе
			ЗаписьXML.ЗаписатьТекст(XMLСтрока(Аргумент.Значение));
		КонецЕсли;
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	
КонецПроцедуры

//Возвращает новый(пустой) ОбъектXDTO полученный по имени из схемы XSD
Функция ПолучитьОбъектОтвет(ТелоОтвета, ИмяОбъекта, Формат) Экспорт
	
	//Попытка
	Если Формат = "xml" Тогда
		ТекущаяФабрика = СоздатьФабрикуXDTO("http://soap.userapi.qwep.ru/?wsdl&schemaOnly");
		ТипОтвета = ТекущаяФабрика.Тип("http://qwep.ru/soap.php/XSD", ИмяОбъекта);
        ЧтениеXML = Новый ЧтениеXML;
        ЧтениеXML.УстановитьСтроку(ТелоОтвета);
        ОтветОбъект = ТекущаяФабрика.ПрочитатьXML(ЧтениеXML, ТипОтвета);
		ОтветОбъект = ОбъектXDTOвСтруктуру(ОтветОбъект);
	ИначеЕсли Формат = "json" Тогда
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТелоОтвета);
		ОтветОбъект = ПрочитатьJSON(ЧтениеJSON);
		ОтветОбъект = ОтветОбъект.Response;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	Возврат ОтветОбъект;
	//Исключение
	//	Сообщить("Ошибка получения объекта XDTO: " + ИмяОбъекта);
	//	Возврат Неопределено;
	//КонецПопытки;
	
КонецФункции

//Возвращает структуру полученную из объекта XDTO
Функция ОбъектXDTOвСтруктуру(Знач ОбъектXDTO)

	ОтветСтруктура = Новый Структура;
	Для каждого Свойство Из ОбъектXDTO.Свойства() Цикл
		//Вложенный объект
		Если ТипЗнч(ОбъектXDTO[Свойство.Имя]) = Тип("ОбъектXDTO") Тогда
			Значение = ОбъектXDTOвСтруктуру(ОбъектXDTO[Свойство.Имя]);
			Если ТипЗнч(Значение) = Тип("Структура") И Значение.Количество() = 1 Тогда
				Для каждого СвойствоСтурктуры Из Значение Цикл
					Если ТипЗнч(СвойствоСтурктуры.Значение) = Тип("Массив") И СвойствоСтурктуры.Ключ = "item" Тогда
						Значение = СвойствоСтурктуры.Значение;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			ОтветСтруктура.Вставить(Свойство.Имя, Значение);
		//Коллекция	
		ИначеЕсли ТипЗнч(ОбъектXDTO[Свойство.Имя]) = Тип("СписокXDTO") Тогда
			мЭлементов = Новый Массив;
			Для каждого Элемент Из ОбъектXDTO[Свойство.Имя] Цикл
				мЭлементов.Добавить(ОбъектXDTOвСтруктуру(Элемент));
			КонецЦикла;
			Если мЭлементов.Количество() > 0 Тогда
				ОтветСтруктура.Вставить(Свойство.Имя, мЭлементов);
			КонецЕсли;
		Иначе//Примитивные типы
			ОтветСтруктура.Вставить(Свойство.Имя, ОбъектXDTO[Свойство.Имя]);	
		КонецЕсли;
	КонецЦикла;
	Возврат ОтветСтруктура;
	
КонецФункции

// Получает или обновляет элементы справочника Города из QWEP API
Процедура ПолучитьГорода() Экспорт
	
	ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат;
	КонецЕсли;
	ПараметрыЗапроса = Новый Структура;
	АдресРесурса = "/geo/cities";
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "CitiesResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивЭлементов = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.cities");
	Если НЕ ТипЗнч(МассивЭлементов) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Если МассивЭлементов.Количество() > 0 Тогда
		QWEP_Сервер.СоздатьОбновитьГорода(МассивЭлементов);
	КонецЕсли;
	
КонецПроцедуры

// Получает или обновляет элементы справочника Поставщики из QWEP API
Процедура ПолучитьПоставщиков() Экспорт
	
	ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат;
	КонецЕсли;
	ПараметрыЗапроса = Новый Структура;
	АдресРесурса = "/vendors";
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "VendorsResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат;	
    КонецЕсли;

	МассивЭлементов = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.vendors");
	//МассивЭлементов = ОтветСтруктура.vendors;
	Если НЕ ТипЗнч(МассивЭлементов) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	Если МассивЭлементов.Количество() > 0 Тогда
		QWEP_Сервер.СоздатьОбновитьПоставщиков(МассивЭлементов);
	КонецЕсли;
	
КонецПроцедуры

// Активирует аккаунт и получает код аккаунта на QWEP AP 
Функция ПолучитьКодАктивированногоАккаунта(ВхСтруктураПараметров=Неопределено) Экспорт
	
	Если ВхСтруктураПараметров = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат "";
	КонецЕсли;
	мАккаунтов = Новый Массив();
	мАккаунтов.Добавить(ВхСтруктураПараметров);
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("accounts", мАккаунтов);
	АдресРесурса = "accounts/add";
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "AccountsAddResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат "";	
    КонецЕсли;

	ОтветМассив = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.accounts"); 
	Если НЕ ТипЗнч(ОтветМассив) = Тип("Массив") ИЛИ ОтветМассив.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	ОтветСтруктура = ОтветМассив[0];
	
	Возврат ОтветСтруктура.id;	
	
КонецФункции

//Удаляет аккаунт по коду
Функция УдалитьАккаунтыНаAPI(мУдаляемыхАккаунтов) Экспорт

	мУдаленных = Новый Массив;
	Если мУдаляемыхАккаунтов.Количество()=0 Тогда
		Возврат мУдаленных;
	КонецЕсли;
	
	ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат мУдаленных;
	КонецЕсли;
	
	мАккаунтов = Новый Массив();
	Для каждого Строка Из мУдаляемыхАккаунтов Цикл
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("id", Строка);
		мАккаунтов.Добавить(СтруктураПараметров);
	КонецЦикла;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("accounts", мАккаунтов);
	АдресРесурса = "accounts/delete";
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "AccountsDeleteResponse");
    
    ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат мУдаленных;	
    КонецЕсли;
	
    ОтветМассив = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.accounts");
    Если ОтветМассив = Неопределено ИЛИ НЕ ТипЗнч(ОтветМассив) = Тип("Массив") ИЛИ ОтветМассив.Количество() = 0 Тогда
		Возврат мУдаленных;
	КонецЕсли;
	
	Для каждого Строка Из ОтветМассив Цикл
		мУдаленных.Добавить(Строка.id);
	КонецЦикла;
	
	QWEP_Сервер.УдалитьАккаунтыИзСправочника(мУдаленных);
    
	Возврат мУдаленных;

КонецФункции

// Включает или отключает аккаунт по коду
Процедура ОбновитьАккаунтыНаAPI(мДляИзменения, Включить) Экспорт

    Если мДляИзменения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат;
	КонецЕсли;
	
	мАккаунтов = Новый Массив();
	Для каждого Строка Из мДляИзменения Цикл
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("id", Строка);
	    СтруктураПараметров.Вставить("enabled", Включить);
		мАккаунтов.Добавить(СтруктураПараметров);
	КонецЦикла;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("accounts", мАккаунтов);
	АдресРесурса = "accounts/update";
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "AccountsUpdateResponse");
    
    ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат;	
    КонецЕсли;
	
    ОтветМассив = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.accounts");     
    Если ОтветМассив = Неопределено ИЛИ НЕ ТипЗнч(ОтветМассив) = Тип("Массив") ИЛИ ОтветМассив.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
    МассивАккаунтов = Новый Массив;
	Для каждого ОтветСтруктура Из ОтветМассив Цикл
	    МассивАккаунтов.Добавить(ОтветСтруктура);
	КонецЦикла;
    QWEP_Сервер.СоздатьОбновитьАккаунты(МассивАккаунтов, Истина);

КонецПроцедуры

// Получает или обновляет элементы справочника Аккаунты из QWEP API
Процедура ПолучитьАккаунты() Экспорт
	
	ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат;
	КонецЕсли;
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("excludePromo", Истина);
	ПараметрыЗапроса.Вставить("excludeDisabled", Истина);
	АдресРесурса = "/accounts/get";
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "AccountsGetResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	МассивЭлементов = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.accounts");
	Если НЕ ТипЗнч(МассивЭлементов) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	Если МассивЭлементов.Количество() > 0 Тогда
		QWEP_Сервер.СоздатьОбновитьАккаунты(МассивЭлементов);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает значение свойства объекта XDTO по полному имени свойства (старый вариант), актуальная процедура ПолучитьЗначениеСвойстваОбъектаСтруктуры
Функция ПолучитьЗначениеСвойстваОбъектаXDTO(ОбъектXDTO, ПолноеИмяСвойства)
	
	Если НЕ ТипЗнч(ОбъектXDTO) = Тип("ОбъектXDTO") Тогда
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
	СвойствоОбъектаXDTO = ОбъектXDTO.Свойства().Получить(ИмяСвойства);
	Если СвойствоОбъектаXDTO = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	НовыйОбъектXDTO = ОбъектXDTO[ИмяСвойства];
	Если ПустаяСтрока(ИмяСвойстваХвост) Тогда
		Если ТипЗнч(НовыйОбъектXDTO) = Тип("Строка") Тогда
			Если НовыйОбъектXDTO = "true" Тогда
				НовыйОбъектXDTO = Истина;
			ИначеЕсли НовыйОбъектXDTO = "false" Тогда
				НовыйОбъектXDTO = Ложь;
			КонецЕсли;
		КонецЕсли;
		Возврат НовыйОбъектXDTO;
	Иначе
		Возврат ПолучитьЗначениеСвойстваОбъектаXDTO(НовыйОбъектXDTO, ИмяСвойстваХвост);
	КонецЕсли;
	
КонецФункции

// Возвращает значение свойства структуры по полному имени свойства
Функция ПолучитьЗначениеСвойстваОбъектаСтруктуры(Структура, ПолноеИмяСвойства)
	
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

// Выполняет поиск вариантов коротких артикулов перед основным поиском
Функция ВыполнитьЗапросНаСерверПередПоиском(ПараметрыЗапроса, ТокенДоступа=Неопределено) Экспорт        
	
	ПустойМассив = Новый Массив;
	Если НЕ ЗначениеЗаполнено(ТокенДоступа) Тогда
		ТокенДоступа = ПолучитьТокенДоступа();
	    Если ПустаяСтрока(ТокенДоступа) Тогда
	        Возврат ПустойМассив;
	    КонецЕсли;
	КонецЕсли;
	
    ПараметрыЗапросаПередПоиском = Новый Структура;
    ПараметрыЗапросаПередПоиском.Вставить("article", ПараметрыЗапроса.article);
    ПараметрыЗапросаПередПоиском.Вставить("excludePromo", ПараметрыЗапроса.excludePromo);        
    
    мАкканутовДляПоиска = QWEP_Сервер.ПолучитьМассивАккаунтовДляПоиска();
	Если мАкканутовДляПоиска.Количество() > 0 Тогда
		ПараметрыЗапросаПередПоиском.Вставить("accounts", мАкканутовДляПоиска);
    КонецЕсли;
    
    АдресРесурса = "/preSearch";
    ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапросаПередПоиском, ТокенДоступа, "PreSearchResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);

    Если ОтветОбъект = Неопределено Тогда
		Возврат ПустойМассив;	
    КонецЕсли;
    
    мРезультат = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.shortNumbers");
	Если мРезультат = Неопределено Тогда
		Возврат ПустойМассив;
	Иначе
		Возврат мРезультат;
	КонецЕсли;
    
КонецФункции
 
// Выплняет поиск на API QWEP
Процедура ВыполнитьПоиск(ПараметрыЗапроса, ИдентификаторПоиска, ВсегоУточнений, ВсегоПредложений) Экспорт	    
    
    ТокенДоступа = ПолучитьТокенДоступа();
    Если ПустаяСтрока(ТокенДоступа) Тогда
        Возврат;
    КонецЕсли;
	
	УдалитьПустыеЗначенияВСтуктуре(ПараметрыЗапроса);
    
    Состояние("Идет поиск по поставщикам", 0);
	//На текущий момент нет возможности включить/выключить аккаунт на сервере, поэтому состояние храним на клиенте(в базе)
	мАкканутовДляПоиска = QWEP_Сервер.ПолучитьМассивАккаунтовДляПоиска();
	Если мАкканутовДляПоиска.Количество() > 0 Тогда
		ПараметрыЗапроса.Вставить("accounts", мАкканутовДляПоиска);
	КонецЕсли;
	
	АдресРесурса = "/search";
    
    Состояние("Идет поиск по поставщикам", 25);
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "SearchResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект); 
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат;	
    КонецЕсли;
    
    Состояние("Идет поиск по поставщикам", 50);
	ИдентификаторПоиска = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.searchId");
	Если ИдентификаторПоиска = Неопределено Тогда
		Возврат;	
    КонецЕсли;
    
	ПодсчитатьКоличествоУточненийИПредложений(ПараметрыЗапроса, ОтветОбъект, ВсегоУточнений, ВсегоПредложений);

    Состояние("Идет поиск по поставщикам", 75);
	QWEP_Сервер.СоздатьЗаписиРСРезультатыПоиска(ОтветОбъект, ИдентификаторПоиска, ПараметрыЗапроса);
    Состояние("Идет поиск по поставщикам", 100);
    
КонецПроцедуры

// Раскрывает уточнение
Процедура РаскрытьУточнение(ПараметрыЗапроса) Экспорт

    ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьПустыеЗначенияВСтуктуре(ПараметрыЗапроса);		
	
	АдресРесурса = "/search";
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "SearchResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);

	Если ОтветОбъект = Неопределено Тогда
		Возврат;	
    КонецЕсли;
    
    ИдентификаторПоиска = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.searchId");
	Если ИдентификаторПоиска = Неопределено Тогда
		Возврат;	
	КонецЕсли;
    
    НетПредложений = Ложь;
    QWEP_Сервер.СоздатьЗаписиРСРезультатыПоиска(ОтветОбъект, ИдентификаторПоиска, ПараметрыЗапроса, Ложь, НетПредложений);
    Если НетПредложений Тогда        	
        Сообщить("Нет предложений.");
    КонецЕсли; 

КонецПроцедуры

// Добавляет в корзину поставщика на сайте
Функция ДобавитьВКорзину(ПараметрыЗапроса) Экспорт
    
    ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат Неопределено;
	КонецЕсли;
    
    УдалитьПустыеЗначенияВСтуктуре(ПараметрыЗапроса);
    
    АдресРесурса = "/cart/add";
    
    ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "CartAddResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат Неопределено;	
    КонецЕсли;
    
    СтатусДобавления = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.status");
    Если СтатусДобавления = Неопределено Тогда
        Возврат Неопределено;
    КонецЕсли;
    
    Возврат СтатусДобавления;
    
КонецФункции

// Удаляет элементы структуры с пустым значением
Процедура УдалитьПустыеЗначенияВСтуктуре(Структура)            
    
    Для каждого Строка Из Структура Цикл
        Если НЕ ЗначениеЗаполнено(Строка.Значение) Тогда
            Структура.Удалить(Строка.Ключ);
        КонецЕсли;
    КонецЦикла;
    
КонецПроцедуры 
 
// Возвращает часть готовых результатов, подготовленных на API QWEP после асинхронного запроса поиска
Процедура ПолучитьГотовуюПорциюРезультатов(ПараметрыЗапроса, ИдентификаторПоиска, ОчищатьРезультаты, ПоискЗавершен, КоличествоПредложений, КоличествоУточнений) Экспорт
	
	ТокенДоступа = ПолучитьТокенДоступа();
	Если ПустаяСтрока(ТокенДоступа) Тогда
		Возврат;
	КонецЕсли;
	
	АдресРесурса = "/search/updates";
	
	ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "SearchUpdatesResponse");
	
	ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат;	
    КонецЕсли;
	
	ИдентификаторПоиска = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.searchId");
	Если ИдентификаторПоиска = Неопределено Тогда
		Возврат;	
    КонецЕсли;
    
    ПоискЗавершен = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.finished");
	Если ПоискЗавершен = Неопределено Тогда
		Возврат;	
    КонецЕсли;
	
	ПодсчитатьКоличествоУточненийИПредложений(ПараметрыЗапроса, ОтветОбъект, КоличествоУточнений, КоличествоПредложений);
	
	QWEP_Сервер.СоздатьЗаписиРСРезультатыПоиска(ОтветОбъект, ИдентификаторПоиска, ПараметрыЗапроса, ОчищатьРезультаты);
	Если ПоискЗавершен Тогда
		ИдентификаторПоиска = "";
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодсчитатьКоличествоУточненийИПредложений(ПараметрыЗапроса, ОтветОбъект, КоличествоУточнений, КоличествоПредложений)

	Если ПараметрыЗапроса.Свойство("flatView") И ПараметрыЗапроса.flatView Тогда        	         
		
		МассивУточнений = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.flatResults.clarifications");
		Если НЕ МассивУточнений = Неопределено Тогда
			КоличествоУточнений = КоличествоУточнений + МассивУточнений.Количество();
		КонецЕсли;
		
		МассивПредложений = ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.flatResults.items");
		Если НЕ МассивПредложений = Неопределено Тогда
        	КоличествоПредложений = КоличествоПредложений + МассивПредложений.Количество();
		КонецЕсли;
		
    КонецЕсли;

КонецПроцедуры

// Возвращает спискок покупок с API QWEP 
Функция ПолучитьСписокПокупок() Экспорт
    
	ТокенДоступа = ПолучитьТокенДоступа();
    Если ПустаяСтрока(ТокенДоступа) Тогда
        Возврат Неопределено;
    КонецЕсли;
    
    ПараметрыЗапроса = Новый Структура;                    
    
    АдресРесурса = "cart/purchases";
    ОтветОбъект = ПолучитьОтветНаЗапросОтAPI(АдресРесурса, ПараметрыЗапроса, ТокенДоступа, "CartPurchasesResponse");
   
    ПроверитьВывестиОшибки(ОтветОбъект);
	
	Если ОтветОбъект = Неопределено Тогда
		Возврат Неопределено;	
    КонецЕсли;
	
	Возврат ПолучитьЗначениеСвойстваОбъектаСтруктуры(ОтветОбъект, "entity.purchases");
    
КонецФункции