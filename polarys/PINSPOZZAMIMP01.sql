CREATE OR REPLACE  PROCEDURE NEWAGE.PINSPOZZAMIMP01 (
	PAR_FIRMA SMALLINT, 
	PAR_ROK SMALLINT, 
	PAR_ZAMNR INTEGER, 
	PAR_LP SMALLINT, 
	PAR_INDEKS DECIMAL(7, 0),
	PAR_KOMBINACJA DECIMAL(7, 0),
	PAR_ILOSC DECIMAL(10, 3),
	PAR_CENA DECIMAL(12, 2) 
  )
---	DYNAMIC RESULT SETS 1		
	LANGUAGE SQL	
	SPECIFIC NEWAGE.PINSPOZZAMIMP01
	
BEGIN 

DECLARE P_ZAMD_IDY INTEGER;
SET P_ZAMD_IDY = ( SELECT IDY FROM NEWAGE.ZAMOWH WHERE FIRMA=PAR_FIRMA AND ROK=PAR_ROK AND ZAMNR=PAR_ZAMNR);


--- 80201901500001.pdf


INSERT INTO NEWAGE.ZAMOW (ZAMOWH_IDY,FIRMA,LP,ARTNR,KOMB,ILOSC,FIRMAP,ROZM1,OPIS,INFO_DOD, ROZM2,ROZM3,ROZMN,ROZMP,UWAGI,STAT3,REKLAM,RABATD,RABATDK,RABATDU,RABAT,RABATK,DOPLR,DOPLPR,DOPLKW,
WYBARW,TKANS,TKANO,CENA,CENAVAT,CENAB,CENAK,CENAGR,CENAR,CENAZAKUP,CENAM,CENAD,WARTP,WART,VATPR,VATKW,OPERATOR) 
select P_ZAMD_IDY AS ZAMOWH_IDY, FIRMA, PAR_LP AS LP,PAR_INDEKS AS ARTNR, 
 PAR_KOMBINACJA AS KOMB, 
 PAR_ILOSC AS ILOSC, 
 FIRMAP,ROZM1,OPIS,INFO_DOD, ROZM2,ROZM3,ROZMN,ROZMP,UWAGI,STAT3,REKLAM,RABATD,RABATDK,RABATDU,RABAT,RABATK,DOPLR,DOPLPR,DOPLKW,
WYBARW,TKANS,TKANO,CENA,CENAVAT,CENAB,CENAK,CENAGR,CENAR,CENAZAKUP,CENAM,CENAD,WARTP,WART,VATPR,VATKW,OPERATOR
 from newage.zamow where zamowh_idy=6696 and idy=11827;

---SET PARDZIS = CAST(NOW() AS DATE); 
--- SET PARZAMH_IDY = (SELECT  IDY FROM NEWAGE.ZAMOWH   WHERE FIRMA=FIRMA AND NWW=WIEK AND NYY=ROK AND NREJ=REJESTR AND NNRZZ=NUMERZZ) ;
--- INSERT INTO zlecdat.tab2doc ( TAB_ID, REC_ID,        FIRM,    DOCART,  DOCDATE, NAS, NASSRC, DIR, DIRSRC, "FILE", "TYPE",    SRCDLT, TXT, TIMU, BIND_TIMES, USERU )
                     ---VALUES ( 11,    ZAMOWH_IDY, P_FIRMA,  'LFS',  PARDZIS, 'NAS-PFM', 'NAS-PFM', SCIEZKA, SCIEZKA, NAZWAPLIKU, 'PDF', 0, '', 0, NOW(), USERDOD);					 
END 
;

COMMENT ON SPECIFIC procedure NEWAGE.PINSPOZZAMIMP01 IS 	'WSTAWIANIE POZYCJI ZAMOWIEN '; 
GRANT EXECUTE ON procedure NEWAGE.PINSPOZZAMIMP01 TO PUBLIC  ;
---call NEWAGE.PINSPOZZAMIMP01(80, 2020, 813681, 1, 25032, 272658, 8, 0) 