# GBS-4039 : update default SRX rule

ALTER TABLE segmentation_rule
    ADD COLUMN IS_DEFAULT CHAR(1)
    NOT NULL DEFAULT 'N'
    CHECK(IS_DEFAULT IN ('Y', 'N'))
    AFTER IS_ACTIVE;

DELIMITER $$
DROP PROCEDURE IF EXISTS upgradeForGBS4039$$

CREATE PROCEDURE upgradeForGBS4039()
BEGIN
	DECLARE done INTEGER DEFAULT 0;

	DECLARE companyId BIGINT(20) DEFAULT 0;
	DECLARE srxId BIGINT(20) DEFAULT 0;
	DECLARE srxCount INTEGER DEFAULT 0;

	-- cursor
	DECLARE company_id_cur CURSOR FOR 
		SELECT id FROM company WHERE IS_ACTIVE = 'Y' AND id != 1;

	-- error handler 
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' SET done = 1;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' BEGIN END;

	OPEN company_id_cur;
	companyId_lable: LOOP
		FETCH company_id_cur INTO companyId;
		-- logger
		SELECT companyId AS CURRENT_COMPANY_ID;

		IF done = 1 THEN
			LEAVE companyId_lable;
		END IF;

		-- insert default rule if needed
		SELECT COUNT(*) INTO srxCount FROM `segmentation_rule` WHERE IS_DEFAULT = 'Y' AND COMPANY_ID = companyId;
		SELECT srxCount AS CURRENT_SRXCOUNT;
		IF srxCount = 0 THEN
			INSERT INTO `segmentation_rule`
			(`NAME`,
			`COMPANY_ID`,
			`SR_TYPE`,
			`DESCRIPTION`,
			`RULE_TEXT`,
			`IS_ACTIVE`,
			`IS_DEFAULT`)
			VALUES
			('GlobalSight Predefined',
			companyId,
			0,
			'Predefined Segmentation rule for GlobalSight.',
			'<?xml version="1.0" encoding="UTF-8" ?>
<srx version="2.0" xmlns="http://www.lisa.org/srx20" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.lisa.org/srx20 srx20.xsd">
  <header cascade="yes" segmentsubflows="yes">
    <formathandle include="no" type="start"/>
    <formathandle include="yes" type="end"/>
    <formathandle include="yes" type="isolated"/>
  </header>
  <body>
    <languagerules>

<languagerule languagerulename="English">
<rule break="no"><beforebreak>\\b[Aa]bs\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Aa]bstr\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bAdd\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bapp\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bappr\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Aa]pprox\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Aa]pr\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Aa]tm\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Aa]ug\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Bb]ill\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Bb]n\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Bb]ull\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Cc]a\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Cc]alc\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Cc]apt\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bCdn\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bcert\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bC[Ff]\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bCh\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Cc]hap\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bcirc\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Cc]oeff\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Cc]ol\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bCom\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Cc]onc\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Cc]ond\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bD\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]ec\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]eriv\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]ia\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]iam\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]in\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]ir\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bDiv\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bdoc\\.com\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]ocs\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]ott\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Dd]r\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ee]\\.g\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\beg\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ee]sp\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ee]st\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bestim\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ee]xc\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ee]xcl\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ff]eb\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ff]ed\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bF[Ii][Gg]\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bFIGS\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ff]ri\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Gg]ovt\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ii]\\.e\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bie\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ii]nc\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ii]ncl\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ii]nd\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ii]ng\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bINT\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Jj]an\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bJul\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bJun\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bLtd\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]ar\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]ax\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]essrs\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]fg\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]gr\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]ill\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]isc\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]M\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]on\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bM[Rr]\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bM[Rr][Ss]\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]s\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Mm]t\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Nn]eg\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bN[Oo]\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Nn]os\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Nn]ov\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bN°\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Oo]\\.J\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bObj\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Oo]ct\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bpag\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Pp]ar\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Pp]ara\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Pp]os\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Pp]p\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Pp]rep\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Pp]rof\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bPte\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bPvt\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Rr]ec\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Rr]ef\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Rr]eg\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Rr]es\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Rr]esp\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Rr]ev\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ss]at\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ss]ep\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ss]ept\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bsp\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bspp\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ss]q\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ss]t\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ss]ta\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ss]un\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ss]uppl\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Tt]el\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Tt]emp\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Tt]hu\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Tt]hur\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Tt]hurs\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Tt]ue\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Tt]ues\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Uu]niv\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bU\\.K\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Uu]til\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Vv]iz\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\bvs\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
<rule break="no"><beforebreak>\\b[Ww]ed\\.</beforebreak><afterbreak>\\s</afterbreak></rule>
</languagerule>

<languagerule languagerulename="Chinese">
<rule>
<beforebreak>[｡。．！？]+</beforebreak></rule></languagerule>

<languagerule languagerulename="Catalan">
        <rule break="no">
          <beforebreak>\\ba\\. C\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ba\\. m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\babr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bact\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\badd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\badj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]dm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\badmtiu\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]dv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bag\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bagr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bagron\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]jt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bajud\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bal\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\balim\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\balt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bampl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ban\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bangl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\banot\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bant\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]pmt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bapr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\baprox\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]pt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\barq\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\barquit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bas\\.\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bassign\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ssoc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\baut\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ux\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]da\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ibl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcast\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcat\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcatedr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcert\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcia\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcin\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcircul\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcol·l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]om\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcomp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcompl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]on\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bconstr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcontr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcoop\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcorr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcte\\. ct\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]tra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bd\\. C\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bded\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ept\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdes\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ir\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdisp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]istr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdoc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bds\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ta\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdte\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdupl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bef\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]ntl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]sc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\besp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]sq\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\betc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]x\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bexc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bexp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bexped\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bext\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ac\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ca\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfebr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bG\\.P\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bgen\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]ov\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bgral\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bil·lustr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bimp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bimpr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\binst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bint\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bjul\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bjur\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bll\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bllic\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bloc\\. cit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bltda\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blín\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmerc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmil·l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmin\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmàx\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmín\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn\\. b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\. del [Tt]rad\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bneg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnom\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnov\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnre\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]úm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\boct\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bop\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bop\\. cit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\. b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\. [Ee]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\. ex\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\. i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\. [Mm]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\. n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\. s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bP\\.D\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpart\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]g\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]obl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bport\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpos\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ral\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprel\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]res\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpriv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bproc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprogr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprov\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ta\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bptes\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]tge\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpts\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpubl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]àg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ça\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bq\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bR\\.D\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]bla\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>Rda</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brda\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bref\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\breg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bres\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brev\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs\\. a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\. [Uu]\\. [Pp]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.A\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.P\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs/c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsecr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bseg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsel\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bset\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsign\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSrta\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bss\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSta\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsup\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsupl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btrad\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btrans\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btransf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]rav\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btít\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bu\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]niv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bv\\. gr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bv\\. i p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bveg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvid\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvocab\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bVs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bVè\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bx\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Àà]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bíd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\búlt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="Czech">
        <rule break="no">
          <beforebreak>\\ba kol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ba\\. s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\baj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bapod\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\batd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\batp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\batpod\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bCSc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdoc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDrSc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bevent\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bInc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bIng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[jJ]iž\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bJUDr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[kK]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[mM]ax\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[mM]ezinár\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bMgr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[mM]in\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bMUDr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn\\. l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[nN]apř\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bobch\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bobec\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[oO]br\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bobyč\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[oO]dst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bos\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bozn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\boznač\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bPaeDr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bPhDr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpopř\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpozn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpř\\. n\\. l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpříp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\br\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bresp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[rR]oč\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs\\. r\\. o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[sS]amohl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[sS]ev\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsouhl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[sS]pol\\. s r\\. o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[sS]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bstol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[sS]tr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[sS]tř\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[sS]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bt\\.r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[tT]ech\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[tT]el\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btzn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btzv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvl\\. jm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvzáj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[vV]ých\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[zZ]ahr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[zZ]n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bzákl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bZákld\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[zZ]áp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[čČ]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bč\\. j\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bè\\. mn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bčísl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bživ\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpísm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bspol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="Danish">
        <rule break="no">
          <beforebreak>\\b[Aa]dm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]fr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]frik\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bafsn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]mer\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]nv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rab\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rt\\.nr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]tt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ut\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bautorisationsnr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bAv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]eg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ek\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]elg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]esl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]et\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]kg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]l\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]rit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ulg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ull\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]and\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]irk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcontainernr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]av\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]hrr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]if\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ir\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ronn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]vs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]gl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]gtl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]ks\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bekskl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]lektr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]lektron\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]ll\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]ndv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]vt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bF\\.[Ee][Kk][Ss]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]g\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]hv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ig\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfo\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ork\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bforordn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]orsk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bFr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]rk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ung\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfær\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ølg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bGen\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]nsntl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]rdl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]ymn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]dl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]enh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]env\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]ft\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]hv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]j\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]pl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]fl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]flg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]ht\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\binkl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]sl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]stf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]tal\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]\\.nr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bJ[Ff]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]fr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]vf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]gl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]gs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]st\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]tr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]ok\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]aks\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]atr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]atr\\.nr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmax\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]edflg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ht\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ia\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]io\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]odsv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]rk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]rs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]dr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]edenn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]edenst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]ederl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]ml\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]ord\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]uv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]uvær\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]bs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]mkr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]mr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]mtr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]p\\.cit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]pg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]pr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]venn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]venst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]vers\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ag\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bPg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ga\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]gl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]inx\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]kt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ort\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ortug\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpåg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ef\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]eg\\.nr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]egn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]esp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]uss\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]chw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]dr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ign\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]kt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]lutn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ml\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]mst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]tat\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]th\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS[Tt][Kk]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]tr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]tud\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsuppl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]åk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ædv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.eks\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ekn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]eoret\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]idl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ilh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ill\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ilsv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]jek\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]jg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]lf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btoldpos\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]yrk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]afh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]dg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]egl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]lt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]ndert\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]ndt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]edk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]edl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]edr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ejl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]etr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ha\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]idensk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]sa\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bVær\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bøkon\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bøvr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="Dutch">
        <rule break="no">
          <beforebreak>\\b[Aa]\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]\\.d\\.\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]\\.h\\.w\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]dm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]fb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]fk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]fl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]fz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ld\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]lg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]lt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]mbt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bAmend\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]mp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]pp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]pr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ss\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ud\\.-mil\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ug\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]at\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]eh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ep\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]esch\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]et\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]etr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ijl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ijv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ijz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ladz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]lz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]lzz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]rig\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bBull\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ur\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]urg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]at\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]at\\.nr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]entr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]ert\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]hr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bCIC\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bCie\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]od\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]odd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bCom\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]omm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]omp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]onf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]orr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]oöp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]resc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]\\.w\\.z\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ag\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ec\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDEF\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ep\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]erg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]gl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]hr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]im\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ir\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ir\\.-gen\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ir\\.-geneesh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]iscr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]istr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]oopsgez\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]rs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]erw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]nz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]vt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]x\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xcl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bext\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ac\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]am\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ebr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ig\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bFl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]eb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]ebr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]el\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]em\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]en\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]estr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]ez\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]eïll\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]ld\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]\\.h\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]\\.k\\.h\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]\\.k\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bHepp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]erz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]fl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]ss\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]st\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.b\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.e\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.e\\.w\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.h\\.b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.p\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.pl\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.s\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.v\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]\\.z\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]bid\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]ii\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bin\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bIn\\.co\\.ge\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]ncl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]x\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]an\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]g\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]hr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]kvr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bJurispr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]ol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]on\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]ic\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]og\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.a\\.w\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.b\\.t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.b\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.d\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.g\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.h\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.i\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.m\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ax\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ej\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]evr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]gr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ij\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ld\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ln\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]rs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]rt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.a\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.chr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]dl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]ed\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bN[Oo]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]ov\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]R\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]rs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]\\.l\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]kt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]p\\.cit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]pm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bor\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\boverw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ag\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bP[Bb]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ct\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]l\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]lv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]seud\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]\\.-k\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bRe\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ed\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ef\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]esp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSci\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ept\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]in\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]l\\.k\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bspp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]tr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ubs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]uppl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.a\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.b\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.e\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.g\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.l\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.n\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.o\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.w\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.w\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.z\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.z\\.t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.z\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]el\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]el\\.nr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]emp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]en\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bter\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]g\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]itg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]itg\\.mij\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bUitv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.chr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.h\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.l\\.n\\.r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.r\\.n\\.l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.w\\.b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.z\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]/h\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]bb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]enn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]er\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]erg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]erm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ert\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]gg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]gl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]lg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]lgg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvo\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]rnl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]db\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]ed\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]eled\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]eled\\.Geb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]eled\\.Zgl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]eledelgeb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]eledelgel\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]eledelgestr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]eleerw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]etb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ww]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.ed\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.g\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.g\\.n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.h\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.k\\.h\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.k\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.pl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.v\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.w\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]at\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]g\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]gn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]itk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]og\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]w\\.bew\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="Finnish">
        <rule break="no">
          <beforebreak>\\balav\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\basiak\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]y\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ritt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]em\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ipl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]nt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]sim\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]v\\.lut\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]il\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]eol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]arj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]enk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]ra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]um\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]uom\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]lt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bjne\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]oht\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]and\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]k\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]ok\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]ät\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]eht\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]ib\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]is\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blopull\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]uot\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]ut\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]yh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]änt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]ääk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]ääket\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]aat\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ahd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]aist\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]at\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]et\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]etsät\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmilj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmin\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]uist\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]yöh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]im\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]imim\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]yk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]\\.s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]ik\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]k\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bos\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]vh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]at\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bper\\.sop\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]erj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ion\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]it\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]k\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ohj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]osit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ros\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpuh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]uol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ys\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ääll\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ad\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ak\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]aut\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ek\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ek\\.n:o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ek\\.nro\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]oom\\.kat\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]uots\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]va\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]al\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]it\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]iv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]kand\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsop\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ot\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bspp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bss\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ubj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]uom\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]äv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ait\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]al\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]arj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]av\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ekn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ekst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]eol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]eoll\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]eor\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ied\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]iet\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]il\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btms\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]od\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]oht\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]oim\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]orst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]ri\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]uom\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]äyd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]gr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]sk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ak\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]alt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]altiot\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]anh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ars\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ast\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]irk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]np\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]oim\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]pj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]rt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Yy]ht\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Yy]ks\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Yy]ksit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Yy]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Yy]lim\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bym\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Yy]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Yy]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Yy]st\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="French">
        <rule break="no">
          <beforebreak>\\b[Aa]dd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]dm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\baff\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]gr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\balc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]pprox\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]pr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bart\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ssoc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\batt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]vr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]is\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ull\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]\\.-à-d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcfr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bCh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]hap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]ie\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]irc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]oeff\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]oll\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]om\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bComm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]omp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]onc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ep\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]iam\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ir\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]iv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdoc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdocs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]éc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]écr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ép\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]lectr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]nv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\best\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]x\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ig\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bFr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bH\\.T\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bincl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bInd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]\\.O\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]an\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]uil\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]ic\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bM\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]aj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ax\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]lle\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]lles\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bMM\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]me\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]mes\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bms\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]eg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]ov\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]°\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]°s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]\\.J\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bObj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]ct\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bOff\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]rig\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]-ê\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ara\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]athol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]hys\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]hysiol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rep\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]réc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpts\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ubl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Qq]qch\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Qq]qf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Qq]qn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Qq]ual\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ec\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ecomm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ef\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\breg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]es\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]esp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bress\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ev\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ègl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bRép\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brév\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.A\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.A\\.S\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsem\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ept\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsid\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.N\\.C\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]oc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bspp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bstbld\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsub\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]uppl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]el\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]emp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]er\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]él\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]niv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="German">
        <rule break="no">
          <beforebreak>\\b[Aa]bb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]bbr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]bk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bAB[Ll]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]bs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]bschn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]bt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]bzg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]dr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bAllg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]nh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bAnl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]nm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]nz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]usg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]z\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bBd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]etr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bB[Gg][Bb]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbiol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbiolog\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bBL\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ull\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbzgl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bB[Zz][Ww]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbürgerl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]\\. h\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]\\.h\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ers\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]esgl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDez\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]iv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDVO\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\behem\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bE[Ii][Nn][Ss][Cc][Hh][Ll]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]ngl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\benv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]vtl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xcl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfolg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]em\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bGen\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]es\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]gf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]mbH\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bHd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nclCL\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nkl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nsb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bLfd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bLGBl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ax\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]bh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bMi\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ia\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ind\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]io\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]rd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]rn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bOrig\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]z\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bPkt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]andnr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bRdn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bRdnr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brdt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]el\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]esp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bR[Ee][Vv]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bRn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bR[Zz]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]lg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]og\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]pez\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]te\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bstk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btausendMio\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]echn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]el\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bTsd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]S\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bverb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ergl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]gl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bWilh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.B\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.Hd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]\\.Z\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]iff\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]ul\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Zz]yl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bzzgl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="Italian">
        <rule break="no">
          <beforebreak>\\b[Aa]bst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]cc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]dj\\.au m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ball''art\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]nc\\.rel\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]nn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rtt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]oll\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]rev\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]\\.c\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]\\.d\\.R\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]\\.l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]\\.m\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]ct\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]fr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]hev\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]irc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bCO\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]od\\.civ\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]onc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]ons\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]onsid\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]onv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcpv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]st\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]\\.l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ec\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdef\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdell''art\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]est\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]iff\\.restr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ir\\.gén\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]isp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]isp\\.fin\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]isp\\.trans\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDiv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDOC\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]rr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]\\.f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bFed\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ig\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bGen\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]ns\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]''art\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]\\.à\\.f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]et\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ll]ib\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blug\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blungh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.p\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]asc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmod\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.c\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.d\\.n\\.c\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.i\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]\\.r\\.s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]\\.s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]bl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.c\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.cont\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.e\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.o\\.p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.p\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.v\\.t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bP[Aa][Gg]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]agg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bP[Aa][Rr]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bPh\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]lur\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]roc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rov\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]\\.p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]acc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ecc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]eg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bRev\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brif\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.a\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.l\\.n\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.l\\.n\\.d\\.n\\.t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.n\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]\\.r\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSA\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS[Ee][Cc]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsett\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSez\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS[Ii][Gg]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]igg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ing\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSta\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.e\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]el\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]it\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]it\\.fin\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]it\\.marg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]rad\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]\\.e\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]niv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]\\.p\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]al\\.p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="Japanese">
<rule>
<beforebreak>[｡。．！？]+</beforebreak></rule></languagerule>

<languagerule languagerulename="Polish">
        <rule break="no">
          <beforebreak>\\ba\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ba\\.[cC]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ba\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ba\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ba\\.s\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ba\\.t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\ba\\.u\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>aa</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\babl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>abp</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\babs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\babsolw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bacc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\baccel\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bagd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bal\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bang\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\barch\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bart\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>at</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>atm</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bb\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bb\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bb\\.p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bb\\.r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bb\\.u\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbelg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bblp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbot\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbł\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bbłp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcdn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bchem\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bchor\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>cos</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcykl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcyt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bcz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bczyt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdcn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdent\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdep\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdgn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdiag\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdoc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdosł\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdot\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bds\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdypl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdyr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdyw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDz\\. U\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDz\\.U\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\be\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\be\\.i\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\beeg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\begz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bekg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bemg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\betc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bew\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bexc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfant\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfarm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bflam\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfot\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bfranc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bgen\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bgm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bgodz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bgr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bhab\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bhol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bhr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bi in\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bi wsp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bib\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bibid\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bin\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\binf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\binst\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\binv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\binż\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\biron\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bitd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bitp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bjm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bjun\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bjw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bjęz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bk\\.p\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkan\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkard\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkop\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkor\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkpr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkpt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bkr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bks\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bksiąż\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bl\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bl\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bl\\.dz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bldz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blek\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blic\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blit\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blmn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blog\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bLtd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bm\\.in\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmec\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmed\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>mgr</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmies\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>mjr</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmkw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bMs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bmuz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn\\.e\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bN\\.N\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn\\.p\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bN\\.T\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnast\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnid\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bniesygn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnlb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bo\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bob\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\boo\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bop\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bopr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bos\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\. Chr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\.C\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\.n\\.e\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpb\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpes\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[pP]kt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpoch\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpoj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpor\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpow\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpow\\.b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpoz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprob\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bproc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprz\\. Chr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprzec\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprzest\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bprzyp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bps\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpsych\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpsychl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpsycht\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpóźn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpłd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>płk</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpłn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bqu\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\br\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bros\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brozdz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brozp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brtg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bryc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brys\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\brż\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.A\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs\\.c\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsam\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsek\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsen\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bss\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bstom\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bstr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsygn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bszt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btab\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btel\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btys\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btzn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btzw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bub\\. m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bub\\. r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bukr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[uU]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bv\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bw\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bw\\.g\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwer\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwet\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bWoj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwsch\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwsp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bww\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwyd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwydz\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwyj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwym\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwyż\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bwł\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bz o\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bza gr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bzach\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bzagr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bzm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bzob\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bzool\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bzł\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\błac\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\błow\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bśp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bśw\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bźr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bżart\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bżeń\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       <rule break="no">
            <beforebreak>\\bust\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
            <beforebreak>\\bpar\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
            <rule break="no">
            <beforebreak>\\bok\\.</beforebreak>
        <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
            <beforebreak>\\bim\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
            <beforebreak>\\bst\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
            <beforebreak>[0-9]{2,4}r\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
            <beforebreak>\\bkom\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
            <beforebreak>\\bk\\.c\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
            <beforebreak>\\s\\(Dz\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
            <beforebreak>\\bk\\.p\\.a\\.</beforebreak>
            <afterbreak>\\s</afterbreak>
        </rule>
</languagerule>

<languagerule languagerulename="Portuguese">
        <rule break="no">
          <beforebreak>\\bAdd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\badic\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bAp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\baprox\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bav\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]ap\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]fr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bC[Oo][Ll]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bColect\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bconc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]rf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDepº\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDepºs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDir\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdisp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdocs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDrs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bex\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xca\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bext\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bExª\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Jj]\\.O\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn\\.os\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bN[Oo]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnos\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]°\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn°s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\. ex\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bPAR\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]roc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpág\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpágs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bref\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bReg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bRev\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSoc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS[Rr]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]rs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bsrª\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvar\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

    <languagerule languagerulename="Spanish">
        <rule break="no">
          <beforebreak>\\bAp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]prox\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rt\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]rts\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bArtº\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bAvda\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]is\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bCorp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bD\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bdef\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDra\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDto\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ua\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDª\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bDña\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bEE\\.UU\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]j\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xcma\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xcmo\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bi\\.e\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]lma\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]lmo\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bJJ\\.OO\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]ms\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bLda\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bLtd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ax\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ill\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bMr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bMrs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bMssrs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bN[Oo]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnos\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]um\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bn°\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]°s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bNº\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bnúm\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bO\\.M\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]z\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\.b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\.ej\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bp\\.p\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ag\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ags\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ta\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]tas\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ts\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]ág\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpágs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bR\\.D\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ec\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]ef\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bReg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Rr]egl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bREP\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bR[Ee][Vv]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.A\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.A\\.U\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.L\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS\\.R\\.L\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS[Rr]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bS[Rr][Aa]\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ras\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]res\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]rs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bSta\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btel\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]er\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bUd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bUds\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bvs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="Swedish">
        <rule break="no">
          <beforebreak>\\b[Aa]dr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]nk\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]vd\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]vg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Aa]vs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]etr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]il\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]itr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]l\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Bb]ull\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]iv\\.ek\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Cc]iv\\.ing\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bCo\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]\\.v\\.s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]ir\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]iv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]oc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Dd]vs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]\\.dyl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bel\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]nl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\betc\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]x\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xkl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xp\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ee]xv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]\\.n\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]\\.v\\.b\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]\\.ö\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bff\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]orts\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]r\\.o\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]ölj\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ff]öreg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Gg]m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Hh]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii] st\\.f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]bl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ii]nkl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]l\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Kk]r\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\blev\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.a\\.o\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.fl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]\\.h\\.t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bm\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ag\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]ax\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Mm]in\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Nn]uv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bo\\.d\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bo\\.dyl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bO\\.s\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bo\\.s\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]bs\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Oo]rdf\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bosv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]\\.g\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bP\\.S\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]g\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bpl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bplur\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Pp]rof\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs\\.a\\.s\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bs\\.k\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ek\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ekr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]id\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]ign\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]pec\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Ss]t\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.ex\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.o\\.m\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]\\.v\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btekn\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]el\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]f\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Tt]im\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\btr\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bu\\.p\\.a\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]ng\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Uu]ppl\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Vv]ol\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bäv\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\b[Åå]rg\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
        <rule break="no">
          <beforebreak>\\bö\\.</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="Thai">
        <rule break="yes">
          <beforebreak>.*</beforebreak>
          <afterbreak>\\s</afterbreak>
        </rule>
       </languagerule>

<languagerule languagerulename="default">
<rule break="no">
<beforebreak>\\w\\s+[A-Z]\\.</beforebreak>
<afterbreak>\\s+[A-Z]</afterbreak></rule>
<rule break="no">
<beforebreak>[\\.\\?!]+["''”\\)]?</beforebreak>
<afterbreak>\\s+[a-zƒšœžßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ]</afterbreak></rule>
<rule break="no">
<beforebreak>[\\(\\[\\{][\\.\\?!][\\)\\]\\}]</beforebreak></rule>
<rule break="no">
<beforebreak>\\b\\S{1,4}\\.</beforebreak>
<afterbreak>(\\s|\\xA0)[0-9\\[\\(]+</afterbreak></rule>
<rule break="no">
<beforebreak>\\b\\S{1,4}\\.</beforebreak>
<afterbreak>(\\s|\\xA0)[A-Z]{1,2}\\d</afterbreak></rule>
<rule break="no">
<beforebreak>\\b[Ee][Tt][Cc]\\.</beforebreak>
<afterbreak>\\s</afterbreak></rule>
<rule break="no">
<beforebreak>\\b:</beforebreak>
<afterbreak>\\s+\\{\\d\\}</afterbreak></rule>
<rule>
<beforebreak>[\\.\\?!]+</beforebreak>
<afterbreak>\\s</afterbreak></rule>
<rule>
<beforebreak>\\S:+["''”\\)]?</beforebreak>
<afterbreak>\\s</afterbreak></rule>
<rule>
<beforebreak>\\u2029</beforebreak></rule>
<rule>
<beforebreak>\\S[\\.\\?!]+["''”\\)]?</beforebreak>
<afterbreak>\\s</afterbreak></rule>
<rule>
<beforebreak>\\S\\t+</beforebreak></rule>
</languagerule>
</languagerules>
    <maprules>
<languagemap languagepattern="en.*" languagerulename="English"/>
<languagemap languagepattern="zh.*" languagerulename="Chinese"/>
<languagemap languagepattern="ca.*" languagerulename="Catalan"/>
<languagemap languagepattern="cs.*" languagerulename="Czech"/>
<languagemap languagepattern="da.*" languagerulename="Danish"/>
<languagemap languagepattern="nl.*" languagerulename="Dutch"/>
<languagemap languagepattern="fi.*" languagerulename="Finnish"/>
<languagemap languagepattern="fr.*" languagerulename="French"/>
<languagemap languagepattern="de.*" languagerulename="German"/>
<languagemap languagepattern="it.*" languagerulename="Italian"/>
<languagemap languagepattern="ja*" languagerulename="Japanese"/>
<languagemap languagepattern="pl.*" languagerulename="Polish"/>
<languagemap languagepattern="pt.*" languagerulename="Portuguese"/>
<languagemap languagepattern="es.*" languagerulename="Spanish"/>
<languagemap languagepattern="sv.*" languagerulename="Swedish"/>
<languagemap languagepattern="th.*" languagerulename="Thai"/>
<languagemap languagepattern=".*" languagerulename="default"/>
</maprules>
  </body>
</srx>',
			'Y', 'Y'
			);

			select @@identity into srxId;
		ELSE
			SELECT ID INTO srxId FROM `segmentation_rule` WHERE IS_DEFAULT = 'Y' AND COMPANY_ID = companyId;
		END IF;
		
		-- logger
		SELECT srxId AS CURRENT_SRXID;
		
		-- update tm profile - segmentation rule
		INSERT INTO `segmentation_rule_tm_profile`
		(`SEGMENTATION_RULE_ID`,
		`TM_PROFILE_ID`)
		SELECT srxId, ID FROM `tm_profile` TMP left join `segmentation_rule_tm_profile` SRXTMP on TMP.ID = SRXTMP.TM_PROFILE_ID 
		WHERE SRXTMP.TM_PROFILE_ID IS NULL and TMP.COMPANY_ID = companyId;


	END LOOP;
	CLOSE company_id_cur;
    END$$

DELIMITER ;


CALL upgradeForGBS4039;
DROP PROCEDURE IF EXISTS upgradeForGBS4039;