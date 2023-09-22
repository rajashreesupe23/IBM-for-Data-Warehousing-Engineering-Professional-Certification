-- Drop the table in case it exists

DROP TABLE PETSALE;

-- Create the table

CREATE TABLE PETSALE (
	ID INTEGER NOT NULL,
	ANIMAL VARCHAR(20),
	SALEPRICE DECIMAL(6,2),
	SALEDATE DATE,
	QUANTITY INTEGER,
	PRIMARY KEY (ID)
	);

-- Insert sample data into the table

INSERT INTO PETSALE VALUES
(1,'Cat',450.09,'2018-05-29',9),
(2,'Dog',666.66,'2018-06-01',3),
(3,'Parrot',50.00,'2018-06-04',2),
(4,'Hamster',60.60,'2018-06-11',6),
(5,'Goldfish',48.48,'2018-06-14',24);

-- Retrieve all records from the table

SELECT * FROM PETSALE;

--create a stored procedure routine named RETRIEVE_ALL.
--This RETRIEVE_ALL routine will contain an SQL query to retrieve all the records from the PETSALE table, 
--so you don't need to write the same query over and over again. You just call the stored procedure routine to execute the query everytime.

--#SET TERMINATOR @
CREATE PROCEDURE RETRIEVE_ALL       -- Name of this stored procedure routine
LANGUAGE SQL                        -- Language used in this routine 
READS SQL DATA                      -- This routine will only read data from the table
DYNAMIC RESULT SETS 1               -- Maximum possible number of result-sets to be returned to the caller query
BEGIN 
    DECLARE C1 CURSOR               -- CURSOR C1 will handle the result-set by retrieving records row by row from the table
    WITH RETURN FOR                 -- This routine will return retrieved records as a result-set to the caller query
    SELECT * FROM PETSALE;          -- Query to retrieve all the records from the table
    OPEN C1;                        -- Keeping the CURSOR C1 open so that result-set can be returned to the caller query
END
@                            

CALL RETRIEVE_ALL;      -- Caller query

DROP PROCEDURE RETRIEVE_ALL;

CALL RETRIEVE_ALL;


--create a stored procedure routine named UPDATE_SALEPRICE with parameters Animal_ID and Animal_Health.
--This UPDATE_SALEPRICE routine will contain SQL queries to update the sale price of the animals in the PETSALE table depending on their health conditions, BAD or WORSE.
--This procedure routine will take animal ID and health conditon as parameters which will be used to update the sale price of animal in the PETSALE table by an amount depending on their health condition. 
--Suppose -
--For animal with ID XX having BAD health condition, the sale price will be reduced further by 25%.
--For animal with ID YY having WORSE health condition, the sale price will be reduced further by 50%.
--For animal with ID ZZ having other health condition, the sale price won't change.

--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_SALEPRICE ( 
    IN Animal_ID INTEGER, IN Animal_Health VARCHAR(5) )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table

BEGIN 

    IF Animal_Health = 'BAD' THEN                           -- Start of conditional statement
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.25)
        WHERE ID = Animal_ID;
    
    ELSEIF Animal_Health = 'WORSE' THEN
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.5)
        WHERE ID = Animal_ID;
        
    ELSE
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE
        WHERE ID = Animal_ID;

    END IF;                                                 -- End of conditional statement
    
END
@                                                           -- Routine termination character

CALL RETRIEVE_ALL;

CALL UPDATE_SALEPRICE(1, 'BAD');        -- Caller query

CALL RETRIEVE_ALL;

CALL RETRIEVE_ALL;

CALL UPDATE_SALEPRICE(3, 'WORSE');      -- Caller query

CALL RETRIEVE_ALL;
