

					
						
DELIMITER $$
DROP FUNCTION IF EXISTS mysql_func_findNum$$
CREATE FUNCTION mysql_func_findNum(nxame varchar(100)) RETURNS int
BEGIN
    DECLARE id int DEFAULT 0;
		DECLARE inde  int DEFAULT 0;
		 set inde =0;
		 set inde =LOCATE('@',nxame);
		
		IF ( inde>0) THEN 
     set id= CONVERT(LEFT(nxame,inde),SIGNED);
		 ELSE
		 set id=-1;
		END IF;
		
RETURN id;
END $$
DELIMITER ;

  SELECT mysql_func_findNum('123@chhar');-- 123