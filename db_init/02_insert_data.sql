USE Security_system;

-- ***************************************************************
-- Секція 1: Очищення та підготовка всіх таблиць
-- ***************************************************************

-- Тимчасове вимкнення Safe Update Mode для будь-яких прихованих DML операцій
SET SQL_SAFE_UPDATES = 0;

-- Очищення всіх таблиць у правильному порядку залежностей
TRUNCATE TABLE sensor_settings;
TRUNCATE TABLE sensor_notifications;
TRUNCATE TABLE system_notifications;
TRUNCATE TABLE user_object_access;
TRUNCATE TABLE sensors;
TRUNCATE TABLE rooms;
TRUNCATE TABLE zones;
TRUNCATE TABLE objects;
TRUNCATE TABLE users;
TRUNCATE TABLE sensor_types;
TRUNCATE TABLE notification_settings;

-- ***************************************************************
-- Секція 2: Фінальна Вставка УНІКАЛЬНИХ Даних
-- ***************************************************************

-- --------------------------
-- users (з ON DUPLICATE KEY UPDATE для уникнення помилок)
-- --------------------------
INSERT INTO users (username, email, password_hash, full_name, phone, role, is_active) VALUES
( 'admin01', 'admin01@mail.com', 'hash123', 'John Smith', '+380501112233', 'admin', 1), -- ID 1
( 'operator01', 'op01@mail.com', 'hash124', 'Alice Johnson', '+380502223344', 'operator', 1), -- ID 2
( 'user01', 'user01@mail.com', 'hash125', 'Bob Brown', '+380503334455', 'user', 1), -- ID 3
( 'user02', 'user02@mail.com', 'hash126', 'Charlie Davis', '+380504445566', 'user', 0), -- ID 4
( 'user03', 'user03@mail.com', 'hash127', 'Eva Green', '+380505556677', 'user', 1), -- ID 5
( 'operator02', 'op02@mail.com', 'hash128', 'Michael White', '+380506667788', 'operator', 1), -- ID 6
( 'admin02', 'admin02@mail.com', 'Sarah Parker', 'hash129', '+380507778899', 'admin', 1) -- ID 7
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name);

-- --------------------------
-- objects (Офіси 1-5)
-- --------------------------
INSERT INTO objects (` name`, address, description) VALUES
('Office A', 'Kyiv, Shevchenko 10', 'Head office'), -- ID 1
('Warehouse B', 'Lviv, Franka 22', 'Storage facility'), -- ID 2
('Factory C', 'Dnipro, Haharina 101', 'Production plant'), -- ID 3
('Data Center D', 'Kharkiv, Sumska 55', 'Critical IT infrastructure'), -- ID 4
('Store E', 'Odesa, Deribasivska 12', 'Retail store') -- ID 5
ON DUPLICATE KEY UPDATE address = VALUES(address);


-- --------------------------
-- zones (Об'єкти 1-5)
-- --------------------------
INSERT INTO zones (object_id, name, description, access_level) VALUES
(1, 'Reception', 'Main entrance zone', 1), -- Z1: O1
(1, 'Server Room', 'Critical servers', 5), -- Z2: O1
(2, 'Loading Dock', 'Cargo zone', 2), -- Z3: O2
(2, 'Storage Hall', 'Warehouse main area', 3), -- Z4: O2
(3, 'Production Line 1', 'Assembly area', 2), -- Z5: O3
(3, 'Production Line 2', 'Packaging area', 2), -- Z6: O3
(4, 'Control Room', 'Network monitoring', 5), -- Z7: O4
(5, 'Sales Floor', 'Open area for customers', 1) -- Z8: O5
ON DUPLICATE KEY UPDATE description = VALUES(description);


-- --------------------------
-- rooms (Забезпечення унікальності та коректності Q1)
-- --------------------------
INSERT INTO rooms (zone_id, name, room_type, floor_number) VALUES
-- O1 (Office A): 2 зони
(1, 'Reception Desk', 'Office', 1),
(1, 'Waiting Area', 'Lobby', 1),
(2, 'Server Rack A', 'Server', -1),
(2, 'Server Rack B', 'Server', -1),
-- O2 (Warehouse B): 2 зони
(3, 'Dock 1', 'Cargo', 0),
(3, 'Dock 2', 'Cargo', 0),
(4, 'Storage A1', 'Warehouse', 1),
(4, 'Storage A2', 'Warehouse', 1),
-- O3 (Factory C): 2 зони
(5, 'Assembly Hall A', 'Industrial', 2),
(6, 'Packaging Hall B', 'Industrial', 2),
-- Кімнати-Коридори для Q1:
(1, 'Main Corridor', 'Corridor', 1),   -- O1 має 1 коридор (Ціль для Q1)
(3, 'West Corridor', 'Corridor', 0),   -- O2 має 2 коридори
(4, 'East Corridor', 'Corridor', 1);   -- O2 має 2 коридори


-- --------------------------
-- sensor_types
-- --------------------------
INSERT INTO sensor_types (name, description) VALUES
('Motion Sensor', 'Detects movements'), -- ID 1
('Smoke Detector', 'Detects smoke and fire'), -- ID 2
('Temperature Sensor', 'Monitors temperature'), -- ID 3
('Access Card Reader', 'Controls access with cards'), -- ID 4
('CCTV Camera', 'Video surveillance'), -- ID 5
('Gas Sensor', 'Detects hazardous gases'), -- ID 6
('Glass Break Sensor', 'Detects window breakage') -- ID 7
ON DUPLICATE KEY UPDATE description = VALUES(description);


-- --------------------------
-- sensors (Q2: O4 Data Center D має MAX 10 датчиків)
-- --------------------------
INSERT INTO sensors (sensor_type_id, room_id, name, last_maintenance) VALUES
-- O1 (Office A): 5 датчиків
(1, 1, 'M-REC-01', '2025-01-10'), (4, 1, 'R-REC-01', '2025-01-20'), (2, 3, 'S-SRV-01', '2025-02-15'), (3, 4, 'T-SRV-02', '2025-03-01'), (5, 2, 'CCTV-LOBBY', '2025-04-01'),
-- O2 (Warehouse B): 4 датчики
(3, 5, 'T-DOCK-01', '2025-03-01'), (6, 7, 'G-STORAGE-01', '2025-02-25'), (1, 8, 'M-STORAGE-02', '2025-03-05'), (2, 6, 'S-DOCK-02', '2025-02-10'),
-- O3 (Factory C): 4 датчики
(3, 9, 'T-ASM-01', '2025-03-22'), (7, 10, 'GBS-PACK-01', '2025-03-18'), (2, 9, 'S-ASM-01', '2025-02-10'), (6, 10, 'G-PACK-01', '2025-02-25'),
-- O4 (Data Center D): 10 датчиків (MAX)
(3, 11, 'T-DC-01', '2025-05-01'), (3, 11, 'T-DC-02', '2025-05-01'), (3, 11, 'T-DC-03', '2025-05-01'), (3, 11, 'T-DC-04', '2025-05-01'),
(2, 11, 'S-DC-01', '2025-05-01'), (5, 11, 'C-DC-01', '2025-05-01'), (5, 11, 'C-DC-02', '2025-05-01'),
(4, 11, 'R-DC-01', '2025-05-01'), (1, 11, 'M-DC-01', '2025-05-01'), (6, 11, 'G-DC-01', '2025-05-01'),
-- O5 (Store E): 2 датчики
(1, 12, 'M-SALES-01', '2025-03-05'), (5, 12, 'C-SALES-01', '2025-04-01');


-- --------------------------
-- user_object_access (Q3: HAVING > 5 зон)
-- --------------------------
INSERT INTO user_object_access (user_id, object_id, access_level) VALUES
(1, 1, 5), (1, 2, 5), (1, 3, 5), (1, 5, 5), -- John Smith (7 зон)
(2, 1, 3), (2, 2, 3), (2, 4, 3), (2, 5, 3), -- Alice Johnson (6 зон)
(6, 3, 3), (6, 4, 3), (6, 5, 3), -- Michael White (4 зони)
(3, 4, 1) -- Bob Brown (1 зона)
ON DUPLICATE KEY UPDATE access_level = VALUES(access_level);


-- --------------------------
-- sensor_settings (Q4)
-- --------------------------
INSERT INTO sensor_settings (sensor_id, parameter_name, parameter_value) VALUES
(3, 'Max_Temp', '30.0C'),
(3, 'Min_Temp', '15.0C'),
(5, 'Recording_FPS', '30'),
(6, 'Gas_Type', 'Methane'),
(9, 'Smoke_Threshold', '40ppm'),
(1, 'Sensitivity', 'High'),
(15, 'Polling_Rate', '10s') -- Один із датчиків O4
ON DUPLICATE KEY UPDATE parameter_value = VALUES(parameter_value);


-- --------------------------
-- sensor_notifications (Q5: O4 Data Center D має MAX тривог)
-- --------------------------
INSERT INTO sensor_notifications (sensor_id, notification_type, ` severity`, message) VALUES
-- O4: 10 сповіщень датчиків
(15, 'High Temp', 5, 'T-DC-01 alert'), (15, 'High Temp', 5, 'T-DC-02 alert'), (16, 'Smoke', 4, 'Smoke alert S-DC-01'),
(17, 'Movement', 3, 'Motion in corridor'), (17, 'Movement', 3, 'Motion in corridor'), (17, 'Movement', 3, 'Motion in corridor'),
(18, 'Access', 2, 'Access attempt R-DC-01'), (18, 'Access', 2, 'Access attempt R-DC-01'), (18, 'Access', 2, 'Access attempt R-DC-01'), (19, 'Gas', 4, 'Gas detected G-DC-01'),
-- O1: 5 сповіщень
(1, 'Movement', 2, 'Motion detected at reception'), (2, 'Smoke alarm', 5, 'Smoke detected near servers'),
(3, 'Temperature', 3, 'High temp at Dock 1'), (4, 'Access denied', 2, 'Invalid card swipe'), (5, 'Camera alert', 1, 'CCTV offline temporarily');


-- --------------------------
-- system_notifications (Q5: O4 Data Center D має MAX тривог)
-- --------------------------
INSERT INTO system_notifications (user_id, object_id, ` title`, message, notification_type, severity) VALUES
-- O4: 5 системних сповіщень. Разом: 10 + 5 = 15 (MAX)
(1, 4, 'Power Loss', 'Main power failure', 'Alarm', 5),
(2, 4, 'Network Down', 'Core switch offline', 'Alarm', 5),
(6, 4, 'UPS Warning', 'Battery level low', 'Warning', 3),
(1, 4, 'System Restart', 'Scheduled reboot completed', 'Info', 1),
(2, 4, 'Cooling Failure', 'HVAC system offline', 'Alarm', 5),
-- O1: 2 системних сповіщення. Разом: 5 + 2 = 7 тривог
(1, 1, 'Server Critical', 'Database connection lost', 'Alarm', 5),
(6, 1, 'Config Change', 'Access levels modified', 'Info', 1);


-- --------------------------
-- notification_settings
-- --------------------------
INSERT INTO notification_settings (user_id, object_id, notification_type, ` delivery_method`, is_enabled, min_severity) VALUES
(1, 1, 'Alarm', 'Email', 1, 5),
(1, 4, 'Warning', 'SMS', 1, 3),
(2, 2, 'All', 'Push', 1, 1),
(3, 3, 'Alarm', 'Email', 0, 4),
(6, 4, 'System', 'Push', 1, 2),
(7, 5, 'Info', 'Email', 1, 1),
(4, 1, 'Movement', 'SMS', 1, 2)
ON DUPLICATE KEY UPDATE is_enabled = VALUES(is_enabled);