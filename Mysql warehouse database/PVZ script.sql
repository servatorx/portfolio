DROP DATABASE IF EXISTS pvz;
CREATE DATABASE pvz;
USE pvz;

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  order_info VARCHAR(1024) COMMENT '������ ������',
  barcode1 VARCHAR(255) NOT NULL,
  barcode2 VARCHAR(255) DEFAULT NULL,
  current_location BIGINT UNSIGNED NOT NULL,
  desription TEXT COMMENT '�������������� ��������' DEFAULT NULL,
  order_shipper BIGINT UNSIGNED COMMENT '��������� ������',
  order_value DECIMAL(10, 2) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_barcode1_id (barcode1)
) COMMENT = '������ � �����������';

DROP TABLE IF EXISTS order_status;
CREATE TABLE order_status (
	order_status_id SERIAL PRIMARY KEY,
	order_id BIGINT UNSIGNED NOT NULL,
	is_accepted TINYINT DEFAULT 1,
	is_delivered TINYINT DEFAULT 0,
	is_returned TINYINT DEFAULT 0,
	is_problem TINYINT DEFAULT 0,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP) COMMENT = '������� �����������';

DROP TABLE IF EXISTS warehouses;
CREATE TABLE warehouses (
	warehouse_id SERIAL PRIMARY KEY,
	warehouse_name VARCHAR(512) NOT NULL,
	address VARCHAR(1024),
	phone VARCHAR(100)) COMMENT = '������ ������� ���';

DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
	location_id SERIAL PRIMARY KEY,
	location_name VARCHAR(255),
	location_warehouse BIGINT UNSIGNED NOT NULL DEFAULT 1) COMMENT = '����� �������� �����������';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	first_name VARCHAR(150),
	last_name VARCHAR(150),
	phone VARCHAR(100),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);
  	
DROP TABLE IF EXISTS shippers;
CREATE TABLE shippers (
 	shipper_id SERIAL PRIMARY KEY,
 	shipper_name VARCHAR(100)) COMMENT = '���������� �������';

DROP TABLE IF EXISTS orders_movements;
CREATE TABLE orders_movements (
	movement_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	order_id BIGINT UNSIGNED NOT NULL,
	move_description VARCHAR(512),
	by_user BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	KEY index_movements_order_id (order_id)) COMMENT = '������� �������� �����������';

DROP TABLE IF EXISTS orders_arrival;
CREATE TABLE orders_arrival (
	arrival_id SERIAL PRIMARY KEY,
	arrival_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	shipper_id BIGINT UNSIGNED NOT NULL,
	total_orders INT UNSIGNED DEFAULT 0,
	by_user BIGINT UNSIGNED NOT NULL,
	warehouse BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP) COMMENT = '������ � ��������� �����������';

DROP TABLE IF EXISTS daily_reports;
CREATE TABLE daily_reports (
	report_id SERIAL PRIMARY KEY,
	report_date DATE DEFAULT (CURRENT_DATE),
	warehouse BIGINT UNSIGNED NOT NULL,
	total_accepted INT UNSIGNED DEFAULT 0,
	total_delivered INT UNSIGNED DEFAULT 0,
	total_returned INT UNSIGNED DEFAULT 0) COMMENT = '������ �� ����';

DROP TABLE IF EXISTS problem_orders;
CREATE TABLE problem_orders (
	problem_order_id SERIAL PRIMARY KEY,
	order_id BIGINT UNSIGNED NOT NULL,
	problem_description TEXT NOT NULL,
	problem_type BIGINT UNSIGNED,
	by_user BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP) COMMENT = '������ � ���������� ����������';	
		
DROP TABLE IF EXISTS problem_types;
CREATE TABLE problem_types (
	prob_type_id SERIAL PRIMARY KEY,
	problem_name VARCHAR(512) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP) COMMENT = '���� ���������� ����������';
 
 -- ALTER TABLE orders DROP FOREIGN KEY order_shipper_id_fk;
ALTER TABLE orders 
	ADD CONSTRAINT order_shipper_id_fk
		FOREIGN KEY (order_shipper) REFERENCES shippers(shipper_id);

ALTER TABLE orders 
	ADD CONSTRAINT current_location_id_fk
		FOREIGN KEY (current_location) REFERENCES locations(location_id);
	
ALTER TABLE orders_movements
	ADD CONSTRAINT order_id_fk
		FOREIGN KEY (order_id) REFERENCES orders(order_id),
	ADD CONSTRAINT by_user_id_fk
		FOREIGN KEY (by_user) REFERENCES users(user_id);

ALTER TABLE locations 
	ADD CONSTRAINT warehouse_id_fk
		FOREIGN KEY (location_warehouse) REFERENCES warehouses(warehouse_id);
	
ALTER TABLE daily_reports 
	ADD CONSTRAINT report_warehouse_id_fk
		FOREIGN KEY (warehouse) REFERENCES warehouses(warehouse_id);

ALTER TABLE problem_orders 
	ADD CONSTRAINT problem_order_id_fk
		FOREIGN KEY (order_id) REFERENCES orders(order_id),
	ADD CONSTRAINT problem_orders_by_user_id_fk
		FOREIGN KEY (by_user) REFERENCES users(user_id),
	ADD CONSTRAINT problem_type_fk
		FOREIGN KEY (problem_type) REFERENCES problem_types(prob_type_id);

ALTER TABLE orders_arrival 
	ADD CONSTRAINT arrival_shipper_id_fk
		FOREIGN KEY (shipper_id) REFERENCES shippers(shipper_id),
	ADD CONSTRAINT arrival_by_user_id_fk
		FOREIGN KEY (by_user) REFERENCES users(user_id),
	ADD CONSTRAINT arrival_warehouse_id_fk
		FOREIGN KEY (warehouse) REFERENCES warehouses(warehouse_id);	

ALTER TABLE order_status 
	ADD CONSTRAINT order_status_id_fk
		FOREIGN KEY (order_id) REFERENCES orders(order_id);
		
INSERT INTO users (first_name, last_name, phone) VALUES 
	('�������', '������', '+79260011111'),
	('�����', '�������', '+79297755666'),
	('������', '�������', '+79160857698');

INSERT INTO warehouses (warehouse_name, address, phone) VALUES 
	('����', '���������� 63�', '+79260011111'),
	('������', '����������� 12', '+79297755666');



INSERT INTO locations (location_name, location_warehouse) VALUES 
	('������� 1-2', 1),
	('������� 1-3', 1),
	('������� 2-1', 1),
	('������� 2-2', 1),
	('������� 3-1', 1),
	('������� 1-2', 2),
	('������� 1-3', 2),
	('������� 2-1', 2),
	('������� 2-2', 2),
	('������� 3-1', 2);

INSERT INTO problem_types (problem_name ) VALUES 
	('������������ ��������'),
	('������� ����� �����������'),
	('�����'),
	('����������� ����������');
	
INSERT INTO shippers (shipper_name) VALUES 
	('BoxBerry'),
	('DPD'),
	('PickPoint'),
	('ShopLogistics');

INSERT INTO orders_arrival (arrival_date, shipper_id, total_orders, by_user, warehouse) VALUES 
	('2020-05-20', 1, 5, 1, 1),
	('2020-05-30', 2, 3, 2, 1),
	('2020-05-31', 2, 3, 2, 1);



DELIMITER |
CREATE TRIGGER insert_new_order_status AFTER INSERT ON pvz.orders 
FOR EACH ROW BEGIN 
	INSERT INTO order_status(is_accepted, order_id) VALUES (1, NEW.order_id);
END;|


CREATE TRIGGER test_order_status BEFORE INSERT ON pvz.order_status 
FOR EACH ROW BEGIN 
	IF NEW.is_accepted = 1 AND NEW.is_delivered = 1 THEN 
		SIGNAL SQLSTATE '45000' SET  MESSAGE_TEXT = 'Incorrect order status!';
	END IF;
END;|


DELIMITER |
CREATE PROCEDURE update_daily_report ()
BEGIN
	DECLARE total_delivered INT;
	DELETE FROM pvz.daily_reports WHERE pvz.daily_reports.report_date = CURRENT_DATE(); 
	SELECT COUNT(*) INTO total_delivered FROM pvz.orders LIMIT 1;
	INSERT pvz.daily_reports(total_delivered, warehouse) VALUES (total_delivered, 1);
END;|
DELIMITER ;

-- DROP PROCEDURE update_daily_report;

INSERT INTO orders (order_info, barcode1, current_location, order_shipper, order_value) VALUES
	('���� ������� 5469843', '000025565714800001', 2, 1, 2999),
	('��������� ������� �������� 599502780', '000025560640400001', 3, 1, 1399.66),
	('�������� ���� ��������� 33376303-0001-1', '000025570751400001', 3, 1, 3999);

INSERT INTO orders_movements (order_id, move_description, by_user) VALUES
	(1, '��������� �� �����', 1),
	(1, '������ �������', 1),
	(2, '��������� �� �����', 2);

INSERT INTO daily_reports (report_date, warehouse, total_accepted, total_delivered) VALUES
	('2020-05-17', 1, 2,3),
	('2020-05-18', 1, 5,17),
	('2020-05-31', 1, 8, 5);
	
CALL update_daily_report();

CREATE OR REPLACE VIEW on_balance AS
SELECT 
	order_info AS '������ ������', 
	order_value AS '���������',
	shippers.shipper_name AS '���������',
	locations.location_name AS '����� ��������'
	FROM orders JOIN shippers ON orders.order_shipper = shippers.shipper_id
	JOIN locations ON orders.current_location = locations.location_id;
	
SELECT * FROM on_balance;

CREATE OR REPLACE VIEW orders_movements_info AS
SELECT 
	order_info AS '������ ������', 
	orders_movements.move_description AS '����������� ������',
	orders_movements.created_at AS '����'
	FROM orders JOIN orders_movements ON orders.order_id = orders_movements.order_id;
	
SELECT * FROM orders_movements_info;