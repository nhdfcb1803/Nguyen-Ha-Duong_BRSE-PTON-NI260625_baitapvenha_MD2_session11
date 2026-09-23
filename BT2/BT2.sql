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

DELIMITER $$

CREATE PROCEDURE withdraw_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE current_balance DECIMAL(10,2);

    START TRANSACTION;

    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_account_id;

    SELECT balance
    INTO current_balance
    FROM accounts
    WHERE account_id = p_account_id;

    IF current_balance <= 0 THEN

        ROLLBACK;

        SELECT 'Số dư không đủ.' AS message;

    ELSE

        COMMIT;

        SELECT 'Rút tiền thành công' AS message;

    END IF;

END $$

DELIMITER ;