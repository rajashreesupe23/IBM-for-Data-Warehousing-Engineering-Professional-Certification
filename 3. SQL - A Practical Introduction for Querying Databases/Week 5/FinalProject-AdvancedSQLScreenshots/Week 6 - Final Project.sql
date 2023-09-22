--Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.
SELECT P.NAME_OF_SCHOOL, C.COMMUNITY_AREA_NAME, P.AVERAGE_STUDENT_ATTENDANCE
FROM CHICAGO_PUBLIC_SCHOOLS P 
LEFT JOIN CENSUS_DATA C
ON P.COMMUNITY_AREA_NUMBER = C.COMMUNITY_AREA_NUMBER
WHERE C.HARDSHIP_INDEX = 98;

--Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.
SELECT CRD.CASE_NUMBER, CRD.PRIMARY_TYPE, CED.COMMUNITY_AREA_NAME FROM CHICAGO_CRIME_DATA CRD
LEFT JOIN CENSUS_DATA CED
ON CRD.COMMUNITY_AREA_NUMBER = CED.COMMUNITY_AREA_NUMBER 
WHERE CRD.LOCATION_DESCRIPTION LIKE '%SCHOOL%';

--Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.
CREATE VIEW PUBLIC_SCHOOLS_VIEW(School_Name, Safety_Rating,Family_Rating,Environment_Rating, Instruction_Rating,Leaders_Rating,Teachers_Rating)
AS 
SELECT NAME_OF_SCHOOL,Safety_Icon,Family_Involvement_Icon,Environment_Icon,Instruction_Icon,Leaders_Icon,Teachers_Icon
FROM CHICAGO_PUBLIC_SCHOOLS;

--Write and execute a SQL statement that returns all of the columns from the view.
SELECT * FROM PUBLIC_SCHOOLS_VIEW;

--Write and execute a SQL statement that returns just the school name and leaders rating from the view.
SELECT SCHOOL_NAME, LEADERS_RATING
FROM PUBLIC_SCHOOLS_VIEW;

--Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer. 
--Don’t forget to use the #SET TERMINATOR statement to use the @ for the CREATE statement terminator.
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE(
IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

LANGUAGE SQL 
MODIFIES SQL DATA 
DYNAMIC RESULT SETS 1 

BEGIN 
	
	DECLARE C1 CURSOR 
	WITH RETURN FOR
	
	SELECT * 
	FROM CHICAGO_PUBLIC_SCHOOLS;
	OPEN C1;
	
END 

@

--Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE(
IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

LANGUAGE SQL 
MODIFIES SQL DATA 

BEGIN 

	UPDATE CHICAGO_PUBLIC_SCHOOLS 
	SET "Leaders_Score" = in_Leader_Score
	WHERE "School_ID" = in_School_ID; 
	
END 

@

--Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the following information.
--80 to 99 --> Very Strong 
--60 to 79 --> Strong 
--40 to 59 --> Average
--20 to 39 --> Weak
--0 to 19 --> Very Weak 
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (
    IN in_School_ID  INTEGER, IN in_Leader_Score INTEGER) 
LANGUAGE SQL 
MODIFIES SQL DATA
  BEGIN
    UPDATE "CHICAGO_PUBLIC_SCHOOLS"
    SET "LEADERS_SCORE" = in_Leader_Score
    WHERE "SCHOOL_ID" = in_School_ID;
    IF in_Leader_Score >=  80 THEN 
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Very_Strong'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score>= 60 and in_Leader_Score <= 79  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Strong'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  40 and in_Leader_Score <= 59  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Average'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  20 and in_Leader_Score <= 39  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Weak'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSE
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Very Weak'
        WHERE "SCHOOL_ID" = in_School_ID;
        END IF;
  END 
  @

--Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the procedure works as expected.
call UPDATE_LEADERS_SCORE(50,50);

--Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back the current work if the score did not fit any of the preceding categories.
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (
    IN in_School_ID  INTEGER, IN in_Leader_Score INTEGER) 
LANGUAGE SQL 
MODIFIES SQL DATA
  BEGIN
    UPDATE "CHICAGO_PUBLIC_SCHOOLS"
    SET "LEADERS_SCORE" = in_Leader_Score
    WHERE "SCHOOL_ID" = in_School_ID;
    IF in_Leader_Score >=  80 THEN 
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Very_Strong'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score>= 60 and in_Leader_Score <= 79  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Strong'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  40 and in_Leader_Score <= 59  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Average'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  20 and in_Leader_Score <= 39  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Weak'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  0 and in_Leader_Score <= 19  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Very Weak'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSE 
    	ROLLBACK WORK;
        END IF;
  END 
  @

--Update your stored procedure definition again. Add a statement to commit the current unit of work at the end of the procedure.
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (
    IN in_School_ID  INTEGER, IN in_Leader_Score INTEGER) 
LANGUAGE SQL 
MODIFIES SQL DATA
  BEGIN
    UPDATE "CHICAGO_PUBLIC_SCHOOLS"
    SET "LEADERS_SCORE" = in_Leader_Score
    WHERE "SCHOOL_ID" = in_School_ID;
    IF in_Leader_Score >=  80 THEN 
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Very_Strong'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score>= 60 and in_Leader_Score <= 79  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Strong'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  40 and in_Leader_Score <= 59  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Average'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  20 and in_Leader_Score <= 39  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Weak'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  0 and in_Leader_Score <= 19  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Very Weak'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSE 
    	ROLLBACK WORK;
        END IF;
        COMMIT WORK;
  END 
  @





