# Create TU,TUV and LM tables for super company (company ID is 1)

UPDATE company SET SEPARATE_LM_TU_TUV_TABLES = 1 WHERE id = 1;

--  TRANSLATION_UNIT_1
--
CREATE TABLE TRANSLATION_UNIT_1
(
  ID BIGINT
     PRIMARY KEY,
  ORDER_NUM INT
     NOT NULL,
  TM_ID INT,
  DATA_TYPE VARCHAR(20),
  TU_TYPE VARCHAR(50),
  LOCALIZE_TYPE CHAR(1)
     NOT NULL
     CHECK (LOCALIZE_TYPE IN ('L','T')),
  LEVERAGE_GROUP_ID BIGINT
     NOT NULL,
  PID INT
     NOT NULL,
  SOURCE_TM_NAME VARCHAR(60),
  XLIFF_TRANSLATION_TYPE VARCHAR(60),
  XLIFF_LOCKED CHAR(1)
     NOT NULL DEFAULT 'N'
     CHECK (XLIFF_LOCKED IN ('Y', 'N')),
  IWS_SCORE VARCHAR(50),
  XLIFF_TARGET_SEGMENT MEDIUMTEXT,
  XLIFF_TARGET_LANGUAGE varchar(30) DEFAULT NULL,
  GENERATE_FROM varchar(50) DEFAULT NULL,
  SOURCE_CONTENT varchar(30) DEFAULT NULL,
  PASSOLO_STATE varchar(60) DEFAULT NULL,
  TRANSLATE varchar(12) DEFAULT NULL,
  REPETITION_OF_ID BIGINT DEFAULT NULL,
  IS_REPEATED CHAR(1) DEFAULT 'N'
     CHECK (IS_REPEATED IN ('Y', 'N')),
  KEY `REPETITION_OF_ID` (`REPETITION_OF_ID`)
) AUTO_INCREMENT = 1000;


-- -- -- -Begin Translation_Unit_1 Indexes

CREATE INDEX INDEX_ID_LG ON TRANSLATION_UNIT_1(ID, LEVERAGE_GROUP_ID);

CREATE INDEX IDX_TU_LG_ID_ORDER
     ON TRANSLATION_UNIT_1
        (LEVERAGE_GROUP_ID, ID, ORDER_NUM);


CREATE INDEX INDEX_IDLT_TU_TM ON
   TRANSLATION_UNIT_1(ID, LOCALIZE_TYPE, TU_TYPE, TM_ID);

CREATE INDEX IDX_TU_TYPE_ID ON
   TRANSLATION_UNIT_1(TU_TYPE, ID);
-- -- -- Close Translation_Unit_1 Indexes


--  TRANSLATION_UNIT_VARIANT_1
--
CREATE TABLE TRANSLATION_UNIT_VARIANT_1
(
  ID BIGINT
     PRIMARY KEY,
  ORDER_NUM BIGINT
     NOT NULL,
  LOCALE_ID BIGINT
     NOT NULL,
  TU_ID BIGINT
     NOT NULL,
  IS_INDEXED CHAR(1)
     NOT NULL
     CHECK (IS_INDEXED IN ('Y', 'N')),
  SEGMENT_CLOB MEDIUMTEXT,
  SEGMENT_STRING TEXT,
  WORD_COUNT INT(10),
  EXACT_MATCH_KEY BIGINT,
  STATE VARCHAR(40)
     NOT NULL
     CHECK (STATE IN ('NOT_LOCALIZED','LOCALIZED','OUT_OF_DATE',
             'COMPLETE','LEVERAGE_GROUP_EXACT_MATCH_LOCALIZED',
             'EXACT_MATCH_LOCALIZED', 'ALIGNMENT_LOCALIZED',
             'UNVERIFIED_EXACT_MATCH')),
  MERGE_STATE VARCHAR(20)
     NOT NULL
     CHECK (MERGE_STATE IN ('NOT_MERGED','MERGE_START',
                            'MERGE_MIDDLE','MERGE_END')),
  `TIMESTAMP` DATETIME
     NOT NULL,
  LAST_MODIFIED DATETIME
     NOT NULL,
  MODIFY_USER  VARCHAR(80),
  CREATION_DATE  DATETIME,
  CREATION_USER  VARCHAR(80),
  UPDATED_BY_PROJECT VARCHAR(40),
  SID VARCHAR(255),
  SRC_COMMENT TEXT
) AUTO_INCREMENT = 1000;


-- -- -- - Begin Translation_Unit_Variant_1 Indexes

CREATE INDEX INDEX_ID_LOCALE_STATE ON
   TRANSLATION_UNIT_VARIANT_1(ID, LOCALE_ID, STATE);

CREATE INDEX INDEX_TU_LOC_STATE ON
   TRANSLATION_UNIT_VARIANT_1(TU_ID, LOCALE_ID, STATE);

CREATE INDEX IDX_TUV_EMKEY_LOC_TU ON
   TRANSLATION_UNIT_VARIANT_1(EXACT_MATCH_KEY, LOCALE_ID, TU_ID);

-- CREATE INDEX  index_tuid_emkey ON
--    translation_unit_variant_1(exact_match_key);
--  don't know if that one is needed

CREATE INDEX INDEX_TUV_TUID_STATE ON
   TRANSLATION_UNIT_VARIANT_1(TU_ID, STATE);

CREATE UNIQUE INDEX IDX_TUV_ID_TU
    ON TRANSLATION_UNIT_VARIANT_1
    (ID, TU_ID);


CREATE INDEX IDX_TUV_LOC_TU_ORDER_ID
     ON TRANSLATION_UNIT_VARIANT_1
        (LOCALE_ID, TU_ID, ORDER_NUM, ID);

-- -- -- -Close Translation_Unit_Variant_1 Indexes



--  LEVERAGE_MATCH_1
--
CREATE TABLE LEVERAGE_MATCH_1
(
  SOURCE_PAGE_ID INT,
  ORIGINAL_SOURCE_TUV_ID BIGINT,
  SUB_ID VARCHAR(40),
  MATCHED_TEXT_STRING TEXT,
  MATCHED_TEXT_CLOB MEDIUMTEXT,
  TARGET_LOCALE_ID BIGINT,
  MATCH_TYPE VARCHAR(80),
  ORDER_NUM SMALLINT,
  SCORE_NUM DECIMAL(8, 4) DEFAULT 0.00,
  MATCHED_TUV_ID INT,
  MATCHED_TABLE_TYPE SMALLINT DEFAULT '0',
  PROJECT_TM_INDEX int(4) DEFAULT '-1',
  TM_ID bigint(20) DEFAULT '0',
  TM_PROFILE_ID bigint(20) DEFAULT '0',
  MT_NAME VARCHAR(40),
  MATCHED_ORIGINAL_SOURCE MEDIUMTEXT,
  JOB_DATA_TU_ID BIGINT DEFAULT '-1',
  PRIMARY KEY (ORIGINAL_SOURCE_TUV_ID, SUB_ID, TARGET_LOCALE_ID, ORDER_NUM)
);

-- -- -- -Begin Leverage_Match_1 Indexes

CREATE INDEX INDEX_ORIG_LEV_ORD ON
   LEVERAGE_MATCH_1(ORIGINAL_SOURCE_TUV_ID);

CREATE INDEX IDX_LM_ORDER_ORIGSOURCETUV
    ON LEVERAGE_MATCH_1
    (ORDER_NUM, ORIGINAL_SOURCE_TUV_ID);

CREATE INDEX IDX_LM_SRCPGID_TGTLOCID_ORDNUM
   ON LEVERAGE_MATCH_1
   (SOURCE_PAGE_ID, TARGET_LOCALE_ID,ORDER_NUM);

CREATE INDEX IDX_LM_ORIGSRCTUV_TGTLOCID
   ON LEVERAGE_MATCH_1
   (ORIGINAL_SOURCE_TUV_ID, TARGET_LOCALE_ID);

-- -- --  Close Leverage_Match_1 Indexes