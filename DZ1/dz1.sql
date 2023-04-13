/* Задача 1
Создайте таблицу с мобильными телефонами, используя графический интерфейс. Заполните БД данными (поля и наполнение см. в презентации)
*/

CREATE TABLE mobile_phones (
    id INT PRIMARY KEY,
    product_name VARCHAR(25),
    manufacturer VARCHAR(25),
    product_count INT,
    price INT
);

INSERT INTO mobile_phones (id, product_name, manufacturer, product_count, price)
VALUES (1, 'iPhone X', 'Apple', 3, 76000),
       (2, 'iPhone 8', 'Apple', 2, 51000),
       (3, 'Galaxy S9', 'Samsung', 2, 56000),
       (4, 'Galaxy S8', 'Samsung', 1, 41000),
       (5, 'P20 Pro', 'Huawei', 5, 36000);

SELECT * FROM mobile_phones

/* Задача 2
Создать запрос, который выведет название, производителя и цену для товаров, количество 
которых превышает 2 */

SELECT product_name, manufacturer, price FROM mobile_phones WHERE product_count > 2;

/* Задача 3
Выведите весь ассортимент товаров марки “Samsung” */
SELECT * FROM mobile_phones WHERE manufacturer = 'Samsung';

/* Задача 4 
С помощью регулярных выражений найти: */

-- Товары, в которых есть упоминание “Iphone”:
SELECT product_name, manufacturer, product_count, price 
FROM mobile_phones 
WHERE product_name REGEXP 'Iphone' || manufacturer REGEXP 'Iphone';

-- Товары, в которых есть упоминание “Samsung”:
SELECT product_name, manufacturer, product_count, price 
FROM mobile_phones 
WHERE product_name REGEXP 'Samsung' || manufacturer REGEXP 'Samsung'; 

-- Товары, в которых есть ЦИФРЫ:
SELECT product_name, manufacturer, product_count, price 
FROM mobile_phones  
WHERE product_name REGEXP '[[:digit:]]' = 1 || manufacturer REGEXP '[[:digit:]]' = 1; 

-- Товары, в которых есть ЦИФРА “8”:
SELECT product_name, manufacturer, product_count, price 
FROM mobile_phones
WHERE product_name REGEXP '[[8]]' = 1 || manufacturer REGEXP '[[8]]' = 1; 