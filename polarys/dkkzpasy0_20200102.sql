--  Procedura do szybkiego sprawdzania inwentaryzacji z stanem magazynu
--  Utw: Szymon Kaczykowski
--  Dla Marcin Pastwa
--  Data utw: 2013-05-29
  
SET PATH "QSYS","QSYS2","SYSPROC","SYSIBMADM","QGPL","QTEMP","SMARDAT","NODAT","NOOBJ","TSOBJ","TSDAT","SMAROBJ" ; 
drop procedure POLARYS.DKKZAPASY0; 
CREATE PROCEDURE POLARYS.DKKZAPASY0 ( 
	IN PARFIRMA DECIMAL(2, 0),
	IN PAROKRESOD DECIMAL(8, 0),
	IN PAROKRESDO DECIMAL(8, 0)) 
	DYNAMIC RESULT SETS 1 
	LANGUAGE SQL 
	SPECIFIC POLARYS.DKKZAPASY0 
	NOT DETERMINISTIC 
	READS SQL DATA 
	CALLED ON NULL INPUT 
	SET OPTION  ALWBLK = *ALLREAD , 
	ALWCPYDTA = *OPTIMIZE , 
	COMMIT = *NONE , 
	CLOSQLCSR = *ENDMOD , 
	DECRESULT = (31, 31, 00) , 
	DFTRDBCOL = SMARDAT , 
	DYNDFTCOL = *NO , 
	DYNUSRPRF = *USER , 
	SRTSEQ = *HEX   
	BEGIN 
DECLARE C1 CURSOR FOR 
WITH TMP AS ( 
select X.IDY,X.FIRMA,X.ZAPASNADZIEN, X.WIEK,X.ROK,X.KOMNR,X.POZ,
X.INDEKS,X.KOMB,X.ILOSC,X.WART,X.DATA_WEJ,X.DATA_WYJ,X.STAT1,X.STAT2,
X.OPIS,
X.UWAGI, 

---X.DATA_KAS, 
R.RARTNR, 
R.RABEZ, 
R.RBEZB2, 
R.RCHCMB, 
R.RFIRMP, 
R.RLNR, 
(CASE R.RLNR WHEN 412420 THEN '1_DIRECT'
			 WHEN 513957 THEN '2_PFM' 
             WHEN 511644 THEN '3_CFM' 
			 WHEN 511645 THEN '4_GFM'
			 WHEN 600000 THEN '6_FABAK'
			 WHEN 600001 THEN '6_FABAK' 
			 ELSE '6_XXX' END ) AS OPIS_PRODUCENT, 
R.RM3, R.RKG, R.RCOLLI, R.RMENGE, R.REKPR, R.RWERT, 
N.NAUFAR, 
F2.FFIRM AS FAK_FIRM_ZAKUP,
F2.FDATS AS FAK_DATA_ZAKUP, 
(F2.FYY ||'/'|| F2.FNRFA) AS F_ROK_NR_ZAKUP, 
A.ALPFA AS POZ_FAKTURY_ZAKUP, 

F.FDATS AS F_KOR_DATA, 
(F.FYY ||'/'|| F.FNRFA) AS F_KOR_ROK_NR,

A.ASKOR AS KOR_POZYCJA, 
F.FSKOR, 
F2.FSKOR AS FSKOR2,

(A.ASKOR || F2.FSKOR || F.FSKOR  ) AS POWINA_BYC_KOR, 
F2.FSTAT7 AS TYP_KOR,
F.FSTAT7 AS TYP_KOR2,


X.DATA_UTW, X.DATA_AKT, 

1 AS INF 

from NEWAGE.ZAPASYDKK X LEFT JOIN KLDAT2.TAUP#T R ON 
          ----X.FIRMA = R.RFIRM AND 
		  1 = R.RFIRM AND 
		  X.WIEK = R.RWW AND 
		  X.ROK = R.RYY AND 
		  X.KOMNR = R.RKOMNR AND 
		  X.POZ = R.RPOSNR LEFT JOIN KLDAT2.TAUK#T N ON 
R.RFIRM = N.NFIRM AND 
R.RWW = N.NWW AND 
R.RYY = N.NYY AND 
R.RKOMNR = N.NKOMNR   LEFT JOIN KLDAT2.KOM2EIN Z ON
R.RFIRM = Z.FIRM AND
R.RWW = Z.WW AND
R.RYY = Z.YY AND
R.RKOMNR = Z.KOMNR AND
R.RPOSNR = Z.POSNR AND
R.RFIRMP = Z.FIRMPL LEFT JOIN ZLECDAT.FAKTDT$# A ON
Z.FIRMPL = A.AFIRM AND
Z.WWPL = A.AWW AND
Z.YYPL = A.AYY AND
Z.NRFAPL = A.ANRFA AND
Z.LFFAPL = A.ALPFA AND A.ASTAT3 = 'Z'
LEFT JOIN ZLECDAT.FAKTUR F ON
A.AFIRM = F.FFIRM AND
A.AWW = F.FWWFAK AND
A.AYY = F.FYYFAK AND
A.ANRFA = F.FNRFAK AND
			A.ASTAT3 = F.FSTAT3 
LEFT JOIN ZLECDAT.FAKTUR F2 ON
A.AFIRM = F2.FFIRM AND
A.AWW = F2.FWW AND
A.AYY = F2.FYY AND
A.ANRFA = F2.FNRFA AND
			A.ASTAT3 = F2.FSTAT3
		  ---
where X.firma=PARFIRMA  AND ZAPASNADZIEN  BETWEEN  PAROKRESOD AND PAROKRESDO  and DATA_KAS is null 
--- and X.DATA_WEJ>'2017-06-29' 
) 
SELECT IDY,x.FIRMA,x.ZAPASNADZIEN,x.WIEK,x.ROK,x.KOMNR,x.POZ,x.INDEKS,x.KOMB,x.ILOSC,x.WART,x.DATA_WEJ,x.DATA_WYJ,x.STAT1,
x.STAT2,
--- x.OPIS,
(SELECT cHAR_VALUE  
FROM AMCORE.TAB WHERE TAB_ID_UP=675 and SNAME=X.OPIS) AS OPIS, 

x.UWAGI,x.RARTNR,x.RABEZ,x.RBEZB2,x.RCHCMB,x.RFIRMP,x.RLNR,x.OPIS_PRODUCENT,x.RM3,x.RKG,x.RCOLLI,x.RMENGE,
x.REKPR,x.RWERT,x.NAUFAR,x.FAK_FIRM_ZAKUP,x.FAK_DATA_ZAKUP,x.F_ROK_NR_ZAKUP,x.POZ_FAKTURY_ZAKUP,x.F_KOR_DATA,x.F_KOR_ROK_NR,
x.KOR_POZYCJA,x.FSKOR,x.FSKOR2,x.POWINA_BYC_KOR,x.TYP_KOR,x.TYP_KOR2,x.DATA_UTW,x.DATA_AKT,x.INF 
FROM TMP X 
FOR READ ONLY ; 
OPEN C1 ; 
SET RESULT SETS CURSOR C1 ; 
END  ; 
  
COMMENT ON SPECIFIC PROCEDURE POLARYS.DKKZAPASY0 IS 'ZAPASY DKK V0' ; 
GRANT EXECUTE ON procedure POLARYS.DKKZAPASY0 TO PUBLIC  ;
call POLARYS.DKKZAPASY0(1, 20180430, 20180531);