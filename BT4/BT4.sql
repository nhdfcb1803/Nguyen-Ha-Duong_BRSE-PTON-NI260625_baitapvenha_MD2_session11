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

CREATE TABLE transactions(
	transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    amount DECIMAL(15,2),
    log_message VARCHAR(255),
    transaction_date DATETIME,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

DELIMITER $$
	CREATE PROCEDURE deposit_with_logging (IN p_account_id INT,
											IN p_amount DECIMAL(15,2))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Đã xảy ra lỗi hệ thống! Giao dịch bị huỷ.' AS status;
	END;
    
    START TRANSACTION;
    
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;
    
     INSERT INTO transactions(account_id, amount, log_message)
     VALUES (p_account_id, p_amount, 'Nạp tiền vào tài khoản');
     
     COMMIT;
     SELECT 'Nạp tiền và ghi log thành công!' AS status;
     
     END $$
     DELIMITER ;

SELECT * FROM accounts WHERE account_id = 3;
SELECT * FROM transactions;

CALL deposit_with_logging(3, 1000000);

SELECT * FROM accounts WHERE account_id = 3;
SELECT * FROM transactions;

INSERT INTO accounts (account_id, balance)
VALUES
	(4, 2000000),
	(5, 0);
SELECT * FROM accounts;
DELIMITER $$

CREATE PROCEDURE transfer_money(
    IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_amount DECIMAL(15,2)
)
BEGIN

    DECLARE sender_balance DECIMAL(15,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại, đã ROLLBACK' AS message;
    END;

    START TRANSACTION;
    SELECT balance
    INTO sender_balance
    FROM accounts
    WHERE account_id = p_sender_id;

    IF sender_balance < p_amount THEN
        ROLLBACK;
        SELECT 'Số dư người gửi không đủ' AS message;
    ELSE
        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = p_sender_id;
        UPDATE accounts
        SET balance = balance + p_amount
        WHERE account_id = p_receiver_id;
        COMMIT;
        SELECT 'Chuyển tiền thành công' AS message;
    END IF;
END $$
DELIMITER ;

CALL transfer_money(4, 5, 300000);
SELECT * FROM accounts;
							