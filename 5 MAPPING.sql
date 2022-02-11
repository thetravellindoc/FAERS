﻿USE FAERS_B
GO

/*************************** MAPPING ***********************************/

-- THIS STEP TO MAP PRODUCTS@FDA TO RxNorm
-- Products@FDA TABLE IS IMPORTED INTO MS ACCESS, THEN EXPORTED TO SQL SERVER, FAERS_B

SELECT  [ID]
      ,[ApplNo]
      ,[ProductNo]
      ,[Form]
      ,[Strength]
      ,[ReferenceDrug]
      ,[DrugName]
      ,[ActiveIngredient]
      ,[ReferenceStandard]
      ,[Substance_name]
  FROM [FAERS_B].[dbo].[Products@FDA];
 -------------------------------
 alter table Products@FDA
 add RXAUI varchar(8);
go

alter table Products@FDA
 add AI_2 varchar(300);
go
-----------------------------

update [Products@FDA]
set AI_2 = CASE WHEN  
 CHARINDEX('(',[ActiveIngredient]) > 0  AND CHARINDEX(')', [ActiveIngredient]) > 0 AND CHARINDEX('(', [ActiveIngredient]) < CHARINDEX(')', [ActiveIngredient]) 
 then
 SUBSTRING([ActiveIngredient],CHARINDEX('(', [ActiveIngredient])+1,CHARINDEX(')',[ActiveIngredient])-CHARINDEX('(',[ActiveIngredient])-1) ELSE [ActiveIngredient] end
	  
		

update [Products@FDA]
set AI_2= replace (AI_2 ,';' , ' / ');


update [Products@FDA]
set AI_2= replace (AI_2 ,'  ' , ' ');


update [Products@FDA]
set AI_2= replace (AI_2 ,'  ' , ' ');
------------------------------------------
UPDATE Products@FDA
SET        Products@FDA.RXAUI = RXNCONSO.RXAUI
FROM     Products@FDA INNER JOIN
               RXNCONSO ON Products@FDA.AI_2 = RXNCONSO.STR
where SAB = 'RXNORM'
and TTY in ('IN','MIN')


UPDATE Products@FDA
SET        Products@FDA.RXAUI = RXNCONSO.RXAUI
FROM     Products@FDA INNER JOIN
               RXNCONSO ON Products@FDA.AI_2 = RXNCONSO.STR
where  TTY ='IN'
AND Products@FDA.RXAUI IS NULL



UPDATE Products@FDA
SET        Products@FDA.RXAUI = RXNCONSO.RXAUI
FROM     Products@FDA INNER JOIN
               RXNCONSO ON Products@FDA.AI_2 = RXNCONSO.STR
where  Products@FDA.RXAUI IS NULL



---------------------------------------------------------------------------
--START MAPPING DRUGS TO RxNorm

UPDATE  DRUG_MAPPER 
SET RXAUI = C.RXAUI,RXCUI = C.RXCUI, NOTES = '1.0'
, SAB = C.SAB, TTY = C.TTY, STR= C.STR, CODE  =C.CODE
FROM DRUG_MAPPER A INNER JOIN Products@FDA B 
ON (CASE WHEN LEFT(NDA_NUM, 1) = '0' THEN RIGHT(NDA_NUM, Len(NDA_NUM) - 1)
ELSE NDA_NUM END) = ApplNo INNER JOIN RXNCONSO C
ON B.RXAUI = C.RXAUI
WHERE  NOTES IS NULL
AND ISNUMERIC(NDA_NUM) = 1
AND B.RXAUI IS NOT NULL
AND CHARINDEX ('.', NDA_NUM)=0
AND LEN(NDA_NUM) < 6 

----------------------------------------------------------------------------------- 
UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '1.1'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM DRUGNAME)) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'IN'
AND NOTES IS NULL;

----------------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '1.2'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE

FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM DRUGNAME)) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'MIN'
AND NOTES IS NULL;

--------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '2.1'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM PROD_AI)) =  [RXNCONSO].STR
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'IN'
AND NOTES IS NULL;

------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '2.2'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM PROD_AI)) =  [RXNCONSO].STR
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'MIN'
AND NOTES IS NULL;

-----------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '1.2.2'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM DRUGNAME)) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'PIN'
AND NOTES IS NULL;

----------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '2.2.2'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM PROD_AI)) =  [RXNCONSO].STR
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'PIN'
AND NOTES IS NULL;

----------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '1.3'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM DRUGNAME)) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'MTHSPL'
AND NOTES IS NULL;

------------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '2.3'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM PROD_AI)) =  [RXNCONSO].STR
AND [RXNCONSO].SAB = 'MTHSPL'
AND NOTES IS NULL;

----------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '1.4'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM DRUGNAME)) =  [RXNCONSO].STR 
AND [RXNCONSO].TTY = 'IN'
AND NOTES IS NULL;

------------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '2.4'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM PROD_AI)) =  [RXNCONSO].STR
AND [RXNCONSO].TTY = 'IN'
AND NOTES IS NULL;

------------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '1.5'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE

FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM DRUGNAME)) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'RXNORM'
AND NOTES IS NULL;

------------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = 2.5
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM PROD_AI)) =  [RXNCONSO].STR
AND [RXNCONSO].SAB = 'RXNORM'
AND NOTES IS NULL;


------------------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '1.6'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM DRUGNAME)) =  [RXNCONSO].STR 
AND NOTES IS NULL;

-----------------------

UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = 2.6
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM PROD_AI)) =  [RXNCONSO].STR
AND NOTES IS NULL;



---------------------------------------
-- CLEANING THIS PATTERN OF DRUGNAME (FENTANYL     /00174601/)


UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '3.1'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE  ( CASE WHEN PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) > 0	
THEN LEFT([DRUGNAME], PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) - 1)
ELSE [DRUGNAME] END) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'IN'
AND NOTES IS NULL

-----------------------------------------------
 UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '3.2'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE  ( CASE WHEN PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) > 0	
THEN LEFT([DRUGNAME], PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) - 1)
ELSE [DRUGNAME] END) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'MIN'
AND NOTES IS NULL

-----------------
 UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '3.3'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE  ( CASE WHEN PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) > 0	
THEN LEFT([DRUGNAME], PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) - 1)
ELSE [DRUGNAME] END) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'RXNORM'
AND [RXNCONSO].TTY = 'PIN'
AND NOTES IS NULL

----------------------
 UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '3.4'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE  ( CASE WHEN PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) > 0	
THEN LEFT([DRUGNAME], PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) - 1)
ELSE [DRUGNAME] END) =  [RXNCONSO].STR 
AND [RXNCONSO].SAB = 'MTHSPL'
AND NOTES IS NULL

------------------------
 UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '3.5'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE  ( CASE WHEN PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) > 0	
THEN LEFT([DRUGNAME], PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) - 1)
ELSE [DRUGNAME] END) =  [RXNCONSO].STR 
AND [RXNCONSO].TTY = 'IN'
 
AND NOTES IS NULL

------------------------
 UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '3.6'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE  ( CASE WHEN PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) > 0	
THEN LEFT([DRUGNAME], PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) - 1)
ELSE [DRUGNAME] END) =  [RXNCONSO].STR 
 
AND [RXNCONSO].SAB = 'RXNORM'
AND NOTES IS NULL

------------------------------------------------------------------------------
 UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI,RXCUI = [RXNCONSO].RXCUI, NOTES = '3.7'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE  ( CASE WHEN PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) > 0	
THEN LEFT([DRUGNAME], PATINDEX('%/%[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) - 1)
ELSE [DRUGNAME] END) =  [RXNCONSO].STR 
AND NOTES IS NULL

----------------------------------------------------------------------
UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = 4.1
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE

FROM [RXNCONSO] 
WHERE
	DRUGNAME = (CASE 
		WHEN CHARINDEX('[', RXNCONSO.STR)>0 AND CHARINDEX(']',RXNCONSO.STR)> CHARINDEX('[', RXNCONSO.STR)
		THEN SUBSTRING(RXNCONSO.STR,CHARINDEX('[', RXNCONSO.STR)+1,CHARINDEX(']',RXNCONSO.STR)-CHARINDEX('[',RXNCONSO.STR)-1)
		 ELSE (TRIM (' :.,?/`~!@#$%^&*-_=+ ' FROM RXNCONSO.STR))  END)

		AND NOTES IS NULL
		AND RXNCONSO.SAB ='MTHSPL'  
---------------------------------------------------------------------------
UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '4.2'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE
FROM [RXNCONSO] 
WHERE
	 (CASE WHEN PATINDEX('%/[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) > 0	
THEN LEFT([DRUGNAME], PATINDEX('%/[0-9][0-9][0-9][0-9][0-9]%/%', [DRUGNAME]) - 1)
ELSE [DRUGNAME] END)  = (CASE 
		WHEN CHARINDEX('[', RXNCONSO.STR)>0 AND CHARINDEX(']',RXNCONSO.STR)> CHARINDEX('[', RXNCONSO.STR)
		THEN SUBSTRING(RXNCONSO.STR,CHARINDEX('[', RXNCONSO.STR)+1,CHARINDEX(']',RXNCONSO.STR)-CHARINDEX('[',RXNCONSO.STR)-1)
		  
			ELSE RXNCONSO.STR END)

		AND NOTES IS NULL
		AND RXNCONSO.SAB ='MTHSPL'
-----------------------------------------------------------
-->> INSIDE BRAKETS () OR [] FOR PROD_AI
UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = 4.3
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE

FROM [RXNCONSO] 
WHERE
	PROD_AI = (CASE 
		WHEN CHARINDEX('[', RXNCONSO.STR)>0 AND CHARINDEX(']',RXNCONSO.STR)> CHARINDEX('[', RXNCONSO.STR)
		THEN SUBSTRING(RXNCONSO.STR,CHARINDEX('[', RXNCONSO.STR)+1,CHARINDEX(']',RXNCONSO.STR)-CHARINDEX('[',RXNCONSO.STR)-1)
		ELSE RXNCONSO.STR END)

		AND NOTES IS NULL
		AND RXNCONSO.SAB ='MTHSPL'
	

-- MATCH INSIDE DRUGNAME() WITH STR
UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '5.1'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE

FROM [RXNCONSO] 
WHERE
	RXNCONSO.STR = (CASE 
	    WHEN CHARINDEX('(', DRUGNAME)>0 AND CHARINDEX(')',DRUGNAME)> CHARINDEX('(', DRUGNAME)
		THEN SUBSTRING(DRUGNAME,CHARINDEX('(', DRUGNAME)+1,CHARINDEX(')',DRUGNAME)-CHARINDEX('(',DRUGNAME)-1)
		
		ELSE DRUGNAME END)

		AND NOTES IS NULL
		AND   CHARINDEX('(', DRUGNAME)>0
 AND  (CASE WHEN CHARINDEX('(', DRUGNAME)>0 AND CHARINDEX(')',DRUGNAME)> CHARINDEX('(', DRUGNAME)
		THEN SUBSTRING(DRUGNAME,CHARINDEX('(', DRUGNAME)+1,CHARINDEX(')',DRUGNAME)-CHARINDEX('(',DRUGNAME)-1)
		ELSE DRUGNAME END)NOT IN ('CAPLET', 'CAPLETS', 'CAPSULE', 'CAPSULES', 'UNSPECIFIED', 'NOS', 'LOTION', 'GRANULATE','TABLET', 'TABLETS', 'RED')
		AND RXNCONSO.SAB = 'RXNORM'
		AND RXNCONSO.TTY = 'IN'

----------------------------------
UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '5.2'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE

FROM [RXNCONSO] 
WHERE
	RXNCONSO.STR = (CASE 
		  
		  WHEN CHARINDEX('(', DRUGNAME)>0 AND CHARINDEX(')',DRUGNAME)> CHARINDEX('(', DRUGNAME)
		THEN SUBSTRING(DRUGNAME,CHARINDEX('(', DRUGNAME)+1,CHARINDEX(')',DRUGNAME)-CHARINDEX('(',DRUGNAME)-1)
		
		ELSE DRUGNAME END)

		AND NOTES IS NULL
		AND   CHARINDEX('(', DRUGNAME)>0
 AND  (CASE WHEN CHARINDEX('(', DRUGNAME)>0 AND CHARINDEX(')',DRUGNAME)> CHARINDEX('(', DRUGNAME)
		THEN SUBSTRING(DRUGNAME,CHARINDEX('(', DRUGNAME)+1,CHARINDEX(')',DRUGNAME)-CHARINDEX('(',DRUGNAME)-1)
		ELSE DRUGNAME END)NOT IN ('CAPLET', 'CAPLETS', 'CAPSULE', 'CAPSULES', 'UNSPECIFIED', 'NOS', 'LOTION', 'GRANULATE','TABLET', 'TABLETS', 'RED')
		AND RXNCONSO.TTY = 'IN'
	----------------------------------------------------------------------------------------------
UPDATE  DRUG_MAPPER 
SET RXAUI = [RXNCONSO].RXAUI, RXCUI = [RXNCONSO].RXCUI,  NOTES = '5.3'
, SAB = [RXNCONSO].SAB, TTY = [RXNCONSO].TTY, STR=[RXNCONSO].STR, CODE  =[RXNCONSO].CODE

FROM [RXNCONSO] 
WHERE
	RXNCONSO.STR = (CASE 
		  
		  WHEN CHARINDEX('(', DRUGNAME)>0 AND CHARINDEX(')',DRUGNAME)> CHARINDEX('(', DRUGNAME)
		THEN SUBSTRING(DRUGNAME,CHARINDEX('(', DRUGNAME)+1,CHARINDEX(')',DRUGNAME)-CHARINDEX('(',DRUGNAME)-1)
		
		ELSE DRUGNAME END)

		AND NOTES IS NULL
		AND   CHARINDEX('(', DRUGNAME)>0
		AND  (CASE WHEN CHARINDEX('(', DRUGNAME)>0 AND CHARINDEX(')',DRUGNAME)> CHARINDEX('(', DRUGNAME)
		THEN SUBSTRING(DRUGNAME,CHARINDEX('(', DRUGNAME)+1,CHARINDEX(')',DRUGNAME)-CHARINDEX('(',DRUGNAME)-1)
		ELSE DRUGNAME END)NOT IN  ('CAPLET', 'CAPLETS', 'CAPSULE', 'CAPSULES', 'CAPS' , 'CAP', 'UNSPECIFIED'
		, 'NOS', 'LOTION', 'GRANULATE','TABLET', 'TABLETS', 'RED', 'INJECTION', 'TA','SOLUTION','CP','SPRAY', 'DROPS' , 'UNKNOWN')
		AND (( RXNCONSO.SAB <>'RXNORM' OR RXNCONSO.TTY <>'DF')  
			AND (RXNCONSO.SAB <>'ATC' OR RXNCONSO.TTY <>'PT')
			AND (RXNCONSO.SAB <>'VANDF' OR RXNCONSO.TTY <>'PT')
			AND (RXNCONSO.SAB <>'NDDF' OR RXNCONSO.TTY <>'DF')
			AND (RXNCONSO.SAB <>'MMSL' OR RXNCONSO.TTY <>'MS'))
------------------------------------------------------------------
-- MAPPING USING IDD V.1
-----------------------------------------------------------------
UPDATE DRUG_Mapper
SET       DRUG_Mapper.NOTES = '6.1'
		, DRUG_Mapper.RXAUI = IDD.RXAUI
		, DRUG_Mapper.RXCUI = IDD.RXCUI
		, DRUG_Mapper.SAB = IDD.SAB
		, DRUG_Mapper.TTY = IDD.TTY
		, DRUG_Mapper.STR= IDD.STR
		, DRUG_Mapper.CODE  = IDD.CODE

FROM   DRUG_Mapper INNER JOIN
             IDD ON DRUG_Mapper.DRUGNAME = IDD.Drugname
			
WHERE (DRUG_Mapper.NOTES IS NULL)
and IDD.RXAUI is not null 
and IDD.SAB= 'RXNORM'
and IDD.TTY in( 'IN', 'MIN', 'PIN')
 -----------------------------------------------

UPDATE DRUG_Mapper
SET       DRUG_Mapper.NOTES = '6.2'
		, DRUG_Mapper.RXAUI = IDD.RXAUI
		, DRUG_Mapper.RXCUI = IDD.RXCUI
		, DRUG_Mapper.SAB = IDD.SAB
		, DRUG_Mapper.TTY = IDD.TTY
		, DRUG_Mapper.STR= IDD.STR
		, DRUG_Mapper.CODE  = IDD.CODE

FROM   DRUG_Mapper INNER JOIN
             IDD ON DRUG_Mapper.prod_ai = IDD.Drugname
WHERE (DRUG_Mapper.NOTES IS NULL)
and IDD.RXAUI is not null
and IDD.SAB= 'RXNORM'
and IDD.TTY in( 'IN', 'MIN', 'PIN')
----------
UPDATE DRUG_Mapper
SET       DRUG_Mapper.NOTES = '6.3'
		, DRUG_Mapper.RXAUI = IDD.RXAUI
		, DRUG_Mapper.RXCUI = IDD.RXCUI
		, DRUG_Mapper.SAB = IDD.SAB
		, DRUG_Mapper.TTY = IDD.TTY
		, DRUG_Mapper.STR= IDD.STR
		, DRUG_Mapper.CODE  = IDD.CODE

FROM   DRUG_Mapper INNER JOIN
       IDD ON DRUG_Mapper.DRUGNAME = IDD.Drugname
WHERE (DRUG_Mapper.NOTES IS NULL)
and IDD.RXAUI is not null 
----------------------------------------------

UPDATE DRUG_Mapper
SET       DRUG_Mapper.NOTES = '6.4'
		, DRUG_Mapper.RXAUI = IDD.RXAUI
		, DRUG_Mapper.RXCUI = IDD.RXCUI
		, DRUG_Mapper.SAB = IDD.SAB
		, DRUG_Mapper.TTY = IDD.TTY
		, DRUG_Mapper.STR= IDD.STR
		, DRUG_Mapper.CODE  = IDD.CODE

FROM   DRUG_Mapper INNER JOIN
             IDD ON DRUG_Mapper.prod_ai = IDD.Drugname
WHERE (DRUG_Mapper.NOTES IS NULL)
and IDD.RXAUI is not null
and IDD.TTY = 'IN'

----------------------------------------

UPDATE DRUG_Mapper
SET       DRUG_Mapper.NOTES = '6.5'
		, DRUG_Mapper.RXAUI = IDD.RXAUI
		, DRUG_Mapper.RXCUI = IDD.RXCUI
		, DRUG_Mapper.SAB = IDD.SAB
		, DRUG_Mapper.TTY = IDD.TTY
		, DRUG_Mapper.STR= IDD.STR
		, DRUG_Mapper.CODE  = IDD.CODE

FROM   DRUG_Mapper INNER JOIN
             IDD ON DRUG_Mapper.DRUGNAME = IDD.Drugname
			
WHERE (DRUG_Mapper.NOTES IS NULL)
and IDD.RXAUI is not null 
---------------------------------------------

UPDATE DRUG_Mapper
SET       DRUG_Mapper.NOTES = '6.6'
		, DRUG_Mapper.RXAUI = IDD.RXAUI
		, DRUG_Mapper.RXCUI = IDD.RXCUI
		, DRUG_Mapper.SAB = IDD.SAB
		, DRUG_Mapper.TTY = IDD.TTY
		, DRUG_Mapper.STR= IDD.STR
		, DRUG_Mapper.CODE  = IDD.CODE

FROM   DRUG_Mapper INNER JOIN
             IDD ON DRUG_Mapper.prod_ai = IDD.Drugname
WHERE (DRUG_Mapper.NOTES IS NULL)
and IDD.RXAUI is not null

---------------------------------------------------------------
CREATE TABLE FAERS_B.dbo.MANUAL_MAPPING (
  DRUGNAME VARCHAR(500) NULL
  , COUNT INT
 ,RXAUI BIGINT NULL
 ,RXCUI BIGINT NULL
 ,SAB VARCHAR(20) NULL
 ,TTY VARCHAR(20) NULL
 ,STR VARCHAR(3000) NULL
 ,CODE VARCHAR(50) NULL
 ,NOTES VARCHAR(100) NULL
)
GO
------------------------------------------------------------
INSERT INTO MANUAL_MAPPING
                 (COUNT, DRUGNAME)
SELECT COUNT(DRUGNAME) AS COUNT, DRUGNAME
FROM    DRUG_Mapper
WHERE (NOTES IS NULL)
GROUP BY DRUGNAME
HAVING (COUNT(DRUGNAME) > 199)


-- PERFORM MANUAL MAPPING USING MS ACCESS ON THE REMAINING UN-MAPPED DRUGS, 
-- IMPORT MANUAL_MAPPING FILE TO SQL SERVER 
---------------------------------------------------------------
UPDATE DRUG_Mapper
SET       DRUG_Mapper.NOTES = '7.1' 
		, DRUG_Mapper.RXAUI = MANUAL_MAPPING
	    , DRUG_Mapper.RXCUI = RXNCONSO.RXCUI
		, DRUG_Mapper.SAB = RXNCONSO.SAB
		, DRUG_Mapper.TTY = RXNCONSO.TTY
		, DRUG_Mapper.STR= RXNCONSO.STR
		, DRUG_Mapper.CODE  = RXNCONSO.CODE

FROM   DRUG_Mapper INNER JOIN
             MANUAL_MAPPING ON DRUG_Mapper.DRUGNAME = MANUAL_MAPPING.Drugname
			 inner join RXNCONSO on MANUAL_MAPPING.RXAUI = RXNCONSO.RXAUI
WHERE (DRUG_Mapper.NOTES IS NULL)
and MANUAL_MAPPING.RXAUI is not null
