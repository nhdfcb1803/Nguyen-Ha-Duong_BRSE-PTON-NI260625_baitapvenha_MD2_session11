CREATE DATABASE Bank;
USE Bank;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(10,2) NOT NULL
);

INSERT INTO accounts (balance)
VALUES
(5000000),
(3000000),
(7000000),
(10000000),
(2500000),
(8000000),
(4500000),
(6000000),
(9000000),
(1500000);

SELECT * FROM accounts;
START TRANSACTION;

UPDATE accounts
SET balance = balance + 1000000
WHERE account_id = 1;

SELECT * FROM accounts
WHERE account_id = 1;

COMMIT;