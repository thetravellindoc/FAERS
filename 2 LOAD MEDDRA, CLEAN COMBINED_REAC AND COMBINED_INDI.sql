﻿
/* THIS STEP IS TO STANDARDIZE THE COMBINED_REAC AND COMBINED_INDI PREFERRED TERMS,
AS SOME TERMS ARE NOT STANDARD (PRESENCE OF WHITE SPACES)
ALSO THIS STEP WOULD ALLOW ADDING THE MedDRA NUMERICAL CODES, 
IN ADDITION TO THE TERMS ALREADY AVAILABLE IN THE DATABASE, 
THIS WOULD HELP RESEARCHERS WHO OWN MedDRA LICENCE TO KEEP IT IN MedDRA NUMERICAL CODES IF THEY WANT.

 UNFORTUNATELY, FOR COPYRIGHTS REASONS , WE COULD NOT KEEP MedDRA NUMERICAL CODES IN THE FINAL DATASET. 


---------------------------------------  LOAD MedDRA  ---------------------------------------------------------


 REPLACE THE FOLDER LOCATION IN THE CODE TO THE DATA LOCATION IN YOUR PC


 */


use FAERS_A
GO

DROP  TABLE IF EXISTS low_level_term
create table low_level_term 
		(llt_code bigint, llt_name nvarchar(100), pt_code nchar(8), llt_whoart_code nchar(7),llt_harts_code bigint,
		 llt_costart_sym nvarchar(21), llt_icd9_code nchar(8), llt_icd9cm_code nchar(8), llt_icd10_code nchar(8), llt_currency nchar(1),
		 llt_jart_code nchar(6));

BULK INSERT low_level_term FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\llt.asc'  WITH (fieldterminator='$', rowterminator='$\n');
                              
-----------

DROP  TABLE IF EXISTS pref_term
create table pref_term 
		(pt_code bigint, pt_name nvarchar(100), null_field nchar(1), pt_soc_code bigint,
	 pt_whoart_code nchar(7), pt_harts_code bigint, pt_costart_sym nchar(21), 
	 pt_icd9_code nchar(8), pt_icd9cm_code nchar(8), pt_icd10_code nchar(8), pt_jart_code nchar(6));

BULK INSERT pref_term FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\pt.asc'  WITH (fieldterminator='$', rowterminator='$\n');


-----------


DROP  TABLE IF EXISTS hlt_pref_term
create table hlt_pref_term 
		(hlt_code bigint, hlt_name nvarchar(100), hlt_whoart_code nchar(7), hlt_harts_code bigint, hlt_costart_sym nchar(21),
	 hlt_icd9_code nchar(8), hlt_icd9cm_code nchar(8), hlt_icd10_code nchar(8), hlt_jart_code nchar(6));

BULK INSERT hlt_pref_term FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\hlt.asc'  WITH (fieldterminator='$', rowterminator='$\n');


-------------


DROP  TABLE IF EXISTS hlt_pref_comp
create table hlt_pref_comp 
		(hlt_code bigint, pt_code bigint);

BULK INSERT hlt_pref_comp FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\hlt_pt.asc'  WITH (fieldterminator='$', rowterminator='$\n');


------------------------------------------


DROP  TABLE IF EXISTS hlgt_pref_term
create table hlgt_pref_term 
		(hlgt_code bigint, hlgt_name nvarchar(100), hlgt_whoart_code nchar(7), hlgt_harts_code bigint, hlgt_costart_sym nchar(21),
	 hlgt_icd9_code nchar(8), hlgt_icd9cm_code nchar(8), hlgt_icd10_code nchar(8), hlgt_jart_code nchar(6));

BULK INSERT hlgt_pref_term FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\hlgt.asc'  WITH (fieldterminator='$', rowterminator='$\n');

---------------------------------------


DROP  TABLE IF EXISTS hlgt_hlt_comp
create table hlgt_hlt_comp 
		(hlgt_code bigint, hlt_code bigint );

BULK INSERT hlgt_hlt_comp FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\hlgt_hlt.asc'  WITH (fieldterminator='$', rowterminator='$\n');

-----------------------------------


DROP  TABLE IF EXISTS soc_term
create table soc_term 
		(soc_code bigint, soc_name nvarchar(100), soc_abbrev nvarchar(5), soc_whoart_code nchar(7), soc_harts_code bigint,
	 soc_costart_sym nchar(21), soc_icd9_code nchar(8), soc_icd9cm_code nchar(8), soc_icd10_code nchar(8), soc_jart_code nchar(6));

BULK INSERT soc_term FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\soc.asc'  WITH (fieldterminator='$', rowterminator='$\n');
--------------------------------



DROP  TABLE IF EXISTS soc_hlgt_comp
create table soc_hlgt_comp 
		(soc_code bigint, hlgt_code bigint );

BULK INSERT soc_hlgt_comp FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\soc_hlgt.asc'  WITH (fieldterminator='$', rowterminator='$\n');
--------------------------------


DROP  TABLE IF EXISTS md_hierarchy
create table md_hierarchy 
		(pt_code bigint, hlt_code bigint, hlgt_code bigint, soc_code bigint, pt_name nvarchar(100),
	 hlt_name nvarchar(100), hlgt_name nvarchar(100), soc_name nvarchar(100), soc_abbrev nvarchar(5),
	 null_field nchar(1), pt_soc_code bigint, primary_soc_fg nchar(1));

BULK INSERT md_hierarchy FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\mdhier.asc'  WITH (fieldterminator='$', rowterminator='$\n');
--------------------------------


DROP  TABLE IF EXISTS soc_intl_order
create table soc_intl_order 
		(intl_ord_code bigint, soc_code bigint);

BULK INSERT soc_intl_order FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\intl_ord.asc'  WITH (fieldterminator='$', rowterminator='$\n');
--------------------------------


DROP  TABLE IF EXISTS smq_list
create table smq_list 
		(SMQ_code bigint, SMQ_name nvarchar(100), SMQ_level int, SMQ_description ntext, SMQ_source varchar(2000),
	 SMQ_note varchar(2000), MedDRA_version nchar(5), status nchar(1), SMQ_Algorithm varchar(2000));

BULK INSERT smq_list FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\SMQ_List.asc'  WITH (fieldterminator='$', rowterminator='$\n');
--------------------------------


DROP  TABLE IF EXISTS smq_Content
create table smq_Content 
		(SMQ_code bigint, Term_code bigint, Term_level int, Term_scope int, Term_category nchar(1), Term_weight int,
	 Term_status nchar(1), Term_addition_version nchar(5), Term_last_modified nchar(5));

BULK INSERT smq_Content FROM 'D:\medDRA\MedDRA_24.0_English_0\MedAscii\SMQ_Content.asc'  WITH (fieldterminator='$', rowterminator='$\n');
--------------------------------




---- INDI_Combined


USE FAERS_A
------------------------------
ALTER TABLE INDI_Combined
ADD MEDDRA_CODE INT
go
----------------------------
ALTER TABLE INDI_Combined
ADD CLEANED_PT VARCHAR(100)
go
------------------------------
--remove white spaces in the cleaned PT
update [INDI_Combined]
  set CLEANED_PT = UPPER ( LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(INDI_PT, CHAR(10), ''), CHAR(13), ''), CHAR(9), ''))))
  from [INDI_Combined]
 ------------------

UPDATE INDI_Combined
SET MEDDRA_CODE = pt_code
FROM INDI_Combined a
inner join [pref_term] b
on a.CLEANED_PT = b.pt_name
WHERE MEDDRA_CODE IS NULL


UPDATE INDI_Combined
SET MEDDRA_CODE = [llt_code]
FROM INDI_Combined a
inner join [low_level_term] b
on a.CLEANED_PT = b.llt_name
WHERE MEDDRA_CODE IS NULL

-------------------------------------------------------------------------------------

update INDI_Combined
  set medDRA_CODE = case
  WHEN CLEANED_PT = 'ACUTE  LYMPHOCYTIC LEUKAEMIA' THEN '10000846'
WHEN CLEANED_PT = 'ACUTE ISCHEMIC STROKE' THEN '10061256'
WHEN CLEANED_PT = 'ALZHEIMER''S  DISEASE' THEN '10001896'
WHEN CLEANED_PT = 'ARTRIAL FIBRILLATION' THEN '10003658'
WHEN CLEANED_PT = 'BACTERIAL PNEUMONIA' THEN '10060946'
WHEN CLEANED_PT = 'CONVULSION  PROPHYLAXIS' THEN '10049885'
WHEN CLEANED_PT = 'CORONARY STENT INSERTION' THEN '10052086'
WHEN CLEANED_PT = 'DRUG INDUCED LIVER INJURY' THEN '10072268'
WHEN CLEANED_PT = 'DRUG USE FOR  UNKNOWN INDICATION' THEN '10057097'
WHEN CLEANED_PT = 'DRUG USE FOR UNKNOWN  INDICATION' THEN '10057097'
WHEN CLEANED_PT = 'ESCHERICHIA  INFECTION' THEN '10061126'
WHEN CLEANED_PT = 'EXUDATIVE SENILE MACULAR DEGENERATIVE OF RETINA' THEN '10015902'
WHEN CLEANED_PT = 'HEPATITIS  PROPHYLAXIS' THEN '10019717'
WHEN CLEANED_PT = 'HEPATITIS B  IMMUNIZATION' THEN '10054130'
WHEN CLEANED_PT = 'HER-2 POSITIVE GASTRIC CANCER' THEN '10065430'
WHEN CLEANED_PT = 'HUMAN HERPESVIRUS  6  INFECTION' THEN '10020431'
WHEN CLEANED_PT = 'HYPOTHYROID' THEN '10021114'
WHEN CLEANED_PT = 'MALIGNANT NEOPLASM OF  PROSTATE' THEN '10026389'
WHEN CLEANED_PT = 'METHICILLIN-RESISTANT STAPHYLOCOCCAL AUREUS INFECTION' THEN '10027508'
WHEN CLEANED_PT = 'NECROTIZING PNEUMONIA' THEN '10049271'
WHEN CLEANED_PT = 'OSTEOPORISIS' THEN '10031282'
WHEN CLEANED_PT = 'PERIPHERAL ARTERIAL  DISEASE' THEN '10067825'
WHEN CLEANED_PT = 'REACTIVE AIRWAY DISEASE' THEN '10037993'
WHEN CLEANED_PT = 'SCHIZOAFFECTIVE  DISORDER' THEN '10039621'
WHEN CLEANED_PT = 'SKIN AND SOFT TISSUE INFECTION' THEN '10081417'
WHEN CLEANED_PT = 'SMOKING CESSATION' THEN '10008374'
WHEN CLEANED_PT = 'SPINAL LUMBAR DISORDER' THEN '10061368'
WHEN CLEANED_PT = 'SUPERIOR VENA CAVAL OCCLUSION' THEN '10042568'
WHEN CLEANED_PT = 'THYROID HORMONE REPLACEMENT' THEN '10068076'
WHEN CLEANED_PT = 'UPPER RESPIRATORY TRACT  INFECTION' THEN '10046306'
WHEN CLEANED_PT = 'URINARY TRACT  INFECTION' THEN '10046571'
WHEN CLEANED_PT = 'ACID REFLUX' THEN '10017885'
WHEN CLEANED_PT = 'ACUTE  MYELOID  LEUKAEMIA' THEN '10000880'
WHEN CLEANED_PT = 'AEROMONA INFECTION' THEN '10054205'
WHEN CLEANED_PT = 'AUTIOIMMUNE INDUCED RASH' THEN ''
WHEN CLEANED_PT = 'B-CELL  LYMPHOMA' THEN '10003899'
WHEN CLEANED_PT = 'CARDIC DISORDER' THEN '10061024'
WHEN CLEANED_PT = 'CHOLESTEROL  HIGH' THEN '10008661'
WHEN CLEANED_PT = 'CHRONIC HEPATITIS  B' THEN '10008910'
WHEN CLEANED_PT = 'CHRONIC NERVE PAIN' THEN '10029181'
WHEN CLEANED_PT = 'COMPLEX PARTIAL EPILEPSY' THEN '10010145'
WHEN CLEANED_PT = 'CONVULSION  DISORDER' THEN '10010907'
WHEN CLEANED_PT = 'DEPRESIION' THEN '10012378'
WHEN CLEANED_PT = 'DRUG KNOWN FOR UNKNOWN INDICATION' THEN '10057097'
WHEN CLEANED_PT = 'DRUG USE UNKNOWN INDICATION' THEN '10057097'
WHEN CLEANED_PT = 'HEAVY BLEEDING' THEN '10005103'
WHEN CLEANED_PT = 'HEPATOBILLIARY DISORDER PROPHYLAXIS' THEN '10081385'
WHEN CLEANED_PT = 'HER-2 POSITIVE BREAST CANCER' THEN '10065430'
WHEN CLEANED_PT = 'HERPES  ZOSTER' THEN '10019974'
WHEN CLEANED_PT = 'HYPERTENSION  ARTERIAL' THEN '10020775'
WHEN CLEANED_PT = 'INFECTIVE ENDOCARDITIS' THEN '10014678'
WHEN CLEANED_PT = 'LACTATION  INHIBITION THERAPY' THEN '10069058'
WHEN CLEANED_PT = 'LENNOX--GASTAUT SYNDROME' THEN '10048816'
WHEN CLEANED_PT = 'LUMBAR SPONDYLOSIS WITH SCOLIOSIS AND ARTHRITIS' THEN '10025007'
WHEN CLEANED_PT = 'PRODUCT USED FOR UNKNOWN  INDICATION' THEN '10070592'
WHEN CLEANED_PT = 'SCHIZOPRENIA' THEN '10039626'
WHEN CLEANED_PT = 'SIEZURE' THEN '10039906'
WHEN CLEANED_PT = 'STAGE IV RECTAL ADENOCARCINOMA' THEN '10038029'
WHEN CLEANED_PT = 'SYSTEMIC INFLAMMATORY  RESPONSE SYNDROME' THEN '10051379'
WHEN CLEANED_PT = 'THYROID CONDITION' THEN '10043710'
WHEN CLEANED_PT = 'TYPE  IIB  HYPERLIPIDAEMIA' THEN '10045263'
WHEN CLEANED_PT = 'WET  MACULAR DEGENERATION' THEN '10067791'
WHEN CLEANED_PT = 'DRUG USE FO RUNKNOWN INDICATION' THEN '10057097'
WHEN CLEANED_PT = 'ACQUIRED IMMUNODEFICIENCY  SYNDROME' THEN '10000565'
WHEN CLEANED_PT = 'ACUTE  LYMPHOBLASTIC LEUKEMIA' THEN '10000845'
WHEN CLEANED_PT = 'ATRIAL FILBRILLATION' THEN '10003658'
WHEN CLEANED_PT = 'BLODD PRESSURE' THEN '10005727'
WHEN CLEANED_PT = 'CARDIAC  ABLATION' THEN '10059864'
WHEN CLEANED_PT = 'DEPRESSION NEC' THEN '10012378'
WHEN CLEANED_PT = 'DISBACTERIOSIS' THEN '10064389'
WHEN CLEANED_PT = 'DRUG USED FOR UNKNOWN INDICATION' THEN '10057097'
WHEN CLEANED_PT = 'FOLLICLE-STIMULATING HORMONE DEFICIENCY' THEN '10071084'
WHEN CLEANED_PT = 'GASTRO-JEJUNOSTOMY' THEN '10017882'
WHEN CLEANED_PT = 'HER-2 PROTEIN OVEREXPRESSION' THEN '10075638'
WHEN CLEANED_PT = 'INHALATION' THEN '10061218'
WHEN CLEANED_PT = 'INTERVERTEBRAL DISKITIS' THEN '10060738'
WHEN CLEANED_PT = 'IRREGULAR HEARTBEAT' THEN '10019323'
WHEN CLEANED_PT = 'LOW  BACK PAIN' THEN '10024891'
WHEN CLEANED_PT = 'METHICILLIN-RESISTANT STAPHYLOCOCCAL AUREUS SEPSIS' THEN '10058867'
WHEN CLEANED_PT = 'METHICILLIN-RESISTANT STAPHYLOCOCCAL AUREUS TEST' THEN '10053429'
WHEN CLEANED_PT = 'PANIC DISORDER/ DEPRESSION' THEN '10033666'
WHEN CLEANED_PT = 'PRODUCT  USED FOR UNKNOWN INDICATION' THEN '10070592'
WHEN CLEANED_PT = 'PULMONARY ARTERY HYPERTENSION' THEN '10064911'
WHEN CLEANED_PT = 'SKIN  ABRASION' THEN '10064990'
WHEN CLEANED_PT = 'SQUAMOUS CELL  CARCINOMA OF THE CERVIX' THEN '10041848'
WHEN CLEANED_PT = 'STAGE IV NON-SMALL CELL' THEN '10029522'
WHEN CLEANED_PT = 'STREPTOCOCCAL IDENTIFICATION TEST' THEN '10067006'
WHEN CLEANED_PT = 'TOTAL KNEE ARTHROPLASTY' THEN '10003398'
WHEN CLEANED_PT = 'TUBERCULOUS  MENINGITIS' THEN '10045080'
WHEN CLEANED_PT = 'B LYMPHOBLASTIC LEUKEMIA' THEN '10054448'
WHEN CLEANED_PT = 'BIPOLAR DISORDER II' THEN '10004940'
WHEN CLEANED_PT = 'CARDIAC CATH' THEN '10007527'
WHEN CLEANED_PT = 'CHEMOTHERAPY/RECTOSIGMOID CANCER' THEN '10038093'
WHEN CLEANED_PT = 'COROARY ARTERY STENT PLACEMENT' THEN '10052086'
WHEN CLEANED_PT = 'CORONARY ARTERY DISEASE/HYPERTENSION' THEN '10020772'
WHEN CLEANED_PT = 'CROHNS DISEASE' THEN '10011401'
WHEN CLEANED_PT = 'DEPRESSON' THEN '10012378'
WHEN CLEANED_PT = 'DRUG USE  FOR UNKNOWN INDICATION' THEN '10057097'
WHEN CLEANED_PT = 'DRUG USE FOR UNAPPROVED  INDICATION' THEN '10053746'
WHEN CLEANED_PT = 'EVAN''S SYNDROME' THEN '10053873'
WHEN CLEANED_PT = 'GENERAL ANXIETY DISORDER' THEN '10018075'
WHEN CLEANED_PT = 'H1NI INFLUENZA' THEN '10069767'
WHEN CLEANED_PT = 'HEADACHE/PROPHYLAXIS' THEN '10019211'
WHEN CLEANED_PT = 'HEADACHES' THEN '10019211'
WHEN CLEANED_PT = 'HELICOBACTER PYLORI PROPHYLAXIS' THEN '10054263'
WHEN CLEANED_PT = 'HUNTINGTONS DISEASE' THEN '10070668'
WHEN CLEANED_PT = 'HYPOTHALAMO-PITUITARY DISORDERS' THEN '10021111'
WHEN CLEANED_PT = 'INFECTION  MRSA' THEN '10021839'
WHEN CLEANED_PT = 'INR INCREAESD' THEN '10022402'
WHEN CLEANED_PT = 'METASTATIC CHOLANGIOCARCINOMA' THEN '10077846'
WHEN CLEANED_PT = 'METHICILLIN-RESISTANT STAPHYLOCOCCAL AUREUS TEST POSITIVE' THEN '10053427'
WHEN CLEANED_PT = 'OSEOPOROSIS' THEN '10031282'
WHEN CLEANED_PT = 'OSTEOMYLITIS' THEN '10031252'
WHEN CLEANED_PT = 'PRODUCT USED FOR UNKNOWN INDCATION' THEN '10070592'
WHEN CLEANED_PT = 'RHEUMATOID  ARTHRITIS' THEN '10039073'
WHEN CLEANED_PT = 'TYPE II DIABETES' THEN '10045242'

 end
  where medDRA_CODE is null
 ------------------

CREATE INDEX INDI_MedDRA_CODE
ON INDI_Combined ( MEDDRA_CODE )
go

---------------------
ALTER TABLE REAC_Combined
ADD MEDDRA_CODE INT
go


UPDATE REAC_Combined
SET MEDDRA_CODE = pt_code
FROM REAC_Combined a
inner join [pref_term] b
on a.PT = b.pt_name
WHERE MEDDRA_CODE IS NULL

-----------------------
UPDATE REAC_Combined
SET MEDDRA_CODE = llt_code
FROM REAC_Combined a
inner join [low_level_term] b
on a.PT = b.llt_name
WHERE MEDDRA_CODE IS NULL

--------------
  update [REAC_Combined]
  set medDRA_CODE = case
  when PT ='ANO-RECTAL STENOSIS' then 10002581 
  when PT ='HER-2 POSITIVE BREAST CANCER' then 10065430 
  when PT ='STAPHYLOCOCCAL IDENTIFICATION TEST POSITIVE' then 10067140 
  when PT ='STREPTOCOCCAL IDENTIFICATION TEST' then 10067006 
  when PT ='STREPTOCOCCAL SEROLOGY' then 10059987 
  when PT ='ANO-RECTAL ULCER' then 10002582 
  when PT ='BLASTIC PLASMACYTOID DENDRITRIC CELL NEOPLASIA' then 10075460 
  when PT ='CORNELIA DE-LANGE SYNDROME' then 10077707 
  when PT ='FRONTAL SINUS OPERATIONS' then 10017379 
  when PT ='HER-2 POSITIVE GASTRIC CANCER' then 10066896 
  when PT ='MAXILLARY ANTRUM OPERATIONS' then 10026950 
  when PT ='METHICILLIN-RESISTANT STAPHYLOCOCCAL AUREUS TEST NEGATIVE' then 10053428 
  when PT ='METHICILLIN-RESISTANT STAPHYLOCOCCAL AUREUS TEST POSITIVE' then 10053427 
  when PT ='PAROVARIAN CYST' then 10052456 
  when PT ='STAPHYLOCOCCAL IDENTIFICATION TEST NEGATIVE' then 10067005 
  when PT ='STREPTOCOCCAL IDENTIFICATION TEST POSITIVE' then 10067004 
  when PT ='AEROMONA INFECTION' then 10054205 
  when PT ='DISBACTERIOSIS' then 10064389 
  when PT ='GASTRO-ENTEROSTOMY' then 10017873 
  when PT ='HER-2 PROTEIN OVEREXPRESSION' then 10075638 
  when PT ='HYPOTHALAMO-PITUITARY DISORDERS' then 10021111 
  when PT ='SUPERIOR VENA CAVAL OCCLUSION' then 10058988 
  when PT ='AEROMONA INFECTION' then 10054205 
  when PT ='CAPNOCYTOPHAGIA INFECTION' then 10061738 
  when PT ='DISBACTERIOSIS' then 10064389 
  when PT ='EAGLES SYNDROME' then 10066835 
  when PT ='EVAN''S SYNDROME' then 10053873 
  when PT ='GASTRO-INTESTINAL FISTULA' then 10071258 
  when PT ='GLYCOPEPTIDE ANTIBIOTIC RESISTANT STAPHYLOCOCCAL AUREUS INFECTION' then 10052101 
  when PT ='HEPATOBILLIARY DISORDER PROPHYLAXIS' then 10081385 
  when PT ='HER-2 POSITIVE BREAST CANCER' then 10065430 
  when PT ='MENINGEOMAS SURGERY' then 10053765 
  when PT ='METHICILLIN-RESISTANT STAPHYLOCOCCAL AUREUS TEST' then 10053429 
  when PT ='SPHENOID SINUS OPERATIONS' then 10041508 
  when PT ='STREPTOCOCCAL SEROLOGY POSITIVE' then 10059988 
  when PT ='SUPERIOR VENA CAVAL STENOSIS' then 10064771 
  when PT ='SUPERIOR VENA CAVAL STENOSIS' then 10064771   
  when PT ='GASTRO-JEJUNOSTOMY' then 10017882   

 end
  where medDRA_CODE is null
 -----------------------------------------
CREATE INDEX RAEC_MedDRA_CODE
ON REAC_Combined ( MEDDRA_CODE )
go
