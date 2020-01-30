--- Plik do raportu wejsc zamowien dla Reisenberga

 drop procedure POLARYS.DKKRAP081;
CREATE PROCEDURE POLARYS.DKKRAP081(
	FIRMA DECIMAL(2, 0),
	DATOD DECIMAL(8, 0), 
	DATDO DECIMAL(8, 0)	) 
	DYNAMIC RESULT SETS 1 
	LANGUAGE SQL
	
	SPECIFIC POLARYS.DKKRAP081 
	DETERMINISTIC

  	READS SQL DATA

BEGIN

DECLARE C1 CURSOR FOR

with vbnrlst as ( select tfirm, cast(left(tdane, 4) as decimal(3, 0)) as tnrvbnr, substring(tdane, 11, 30) as opis_verb
  from nodat.notab where tfirm=1 and tnrtab='HK0067' and tdane<>'' ),
NVNTRLST as ( select tfirm, cast(left(tdane, 4) as decimal(3, 0)) as tnrvbnr, rtrim(substring(tdane, 11, 60)) as opis_VNTNR
  from nodat.notab where tfirm=1 and tnrtab='HK0007' and  RTRIM(LEFT(tdane, 3))<>''  ),
TAUK AS ( SELECT * 
 FROM KLDAT2.TAUK#T 
 WHERE NFIRM = FIRMA AND NWW=20 AND 
          (NREDAT BETWEEN DATOD AND DATDO OR ( NREDAT=0 and NAUVOM BETWEEN DATOD AND DATDO ) ) AND  ( NLOEKZ=' ' or NLOEKZ='A' ) AND NYY>14 AND NAUFAR=''  and NVBNR=900 
UNION ALL

SELECT * 
 FROM KLDAT2.TAUK#T 
 WHERE NFIRM = FIRMA AND NWW=20 AND 
          (NREDAT BETWEEN DATOD AND DATDO OR ( NREDAT=0 and NAUVOM BETWEEN DATOD AND DATDO ) ) AND  ( NLOEKZ=' ' or NLOEKZ='A' ) AND NYY>14 AND NAUFAR=''  and NVBNR<>900 
		  AND NKDNR IN (
150206,152605,152628,152646,152657,152677,152683,152689,152697,154926,154930,156097,157101,158613,158727,159070,159071,159073,159128,159779, 
164940,165719,165730,165741,165744,165753,165754,165755,165756,165866,165867,165868,165878,169607,170050,170306,172301,173071,173164,178030) 

), 
TAUP AS (SELECT C.*, (C.RMENGE*C.RBEPRS) RWFAKT
  FROM TAUK A join KLDAT2.TAUP#T C ON
  c.RFIRM=a.nFIRM and 
  c.RWW=a.NWW and 
  c.RYY=a.NYY and 
  c.RKOMNR=a.NKOMNR 
), 
tmp as ( 
SELECT  a.nfirm,  
BVBNR AS Verband, 
--- a.nvbnr as Verband , 
tx.opis_verb, 
a.nkdnr as Kunde,  
A.NAUVOM, 
K.BNAME, 
K.BPLZ, K.BORT, K.BSTR,  K.BKZAUS, 
---kl2.KALKZ, kl2.KAVORW, kl2.KATEL, kl2.KAFAX, 
---C.RVTNR, 
k.bvtnr as RVTNR, 
K.BRAB1, 
K.BSKONT, 
VNT.opis_VNTNR, 
A.NYY, 
A.NKOMNR, 
C.RPOSNR, 
c.RFIRMP as Prod ,
---c.RARTNR7 as Artnr, 
---c.rchcmb as CHCMB , 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 800), 0) as nr800, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.rCHCMB, 1), 0) as nr1, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 2), 0) as nr2, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 3), 0) as nr3, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 8), 0) as nr8, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 20), 0) as nr20, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 31), 0) as nr31, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 351), 0) as nr351, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 353), 0) as nr353, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 360), 0) as nr360, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 370), 0) as nr370, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 400), 0) as nr400, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 410), 0) as nr410, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 347), 0) as nr347, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 348), 0) as nr348, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 349), 0) as nr349, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 350), 0) as nr350, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 352), 0) as nr352, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 355), 0) as nr355, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 358), 0) as nr358, 

--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 604), 0) as nr604, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 601), 0) as nr601, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 602), 0) as nr602, 
--- COALESCE(sqlf.cmb2cech(c.RFIRMP, c.RCHCMB, 603), 0) as nr603, 
--- 20
--- 355
--- 358
 --- coalesce(p.Program, '*Null')  as Prog,
 --- coalesce(p.txt01, '*Null')    as Funkcja,
 rtrim(substring(coalesce(sqlf.ggcn(NFIRM, 'PROGR', RARTNR7), ''), 7, 30)) as Prog, 
 SQLF.SO_GET_TEI_VAR ( rfirm , RARTNR7 , '#PROG#DKKKMK' ) as NProg,
 SQLF.GETTAB ( t.tFIRM , 'HK0031' , SUBSTRING ( t.AFR01 , 1 , 2 ) ) AS Funkcja, 
 SQLF.SO_GET_TEI_VAR ( rfirm , RARTNR7 , '#FUKC#DKKKMK' ) as NFunkcja,
 
 --- rtrim(substring(coalesce(sqlf.ggcn(NFIRM, 'PROG3', RARTNR7), ''), 7, 30)) AS PROGRAM3, 
sqlf.ggcn(NFIRM, 'PROG3', RARTNR7) as PROGRAM3, 
rartnr7, rabez, 
COALESCE(Y.YYYY, 0) AS YYYY, 
COALESCE(Y.YYYYMM, 0) AS YYYYMM, 
(b.WERT4*aufar2w.znak) as wert4,
(b.WERT2*aufar2w.znak) as wert2,
(b.WERT3*aufar2w.znak) as wert3,
(C.RWERT) as  SRWERT, 
(C.RWFAKT) as SRFAKTPR , 
(c.RWFAKT * K.BRAB1/100.00) as RABAT1, 
(c.rmenge*aufar2w.znak) as menge,
c.rfrei6 
--- b.EKPR,
--- b.wertek,
--- B.NAZCMBALL, 
--- B.WARTMATRLC,
--- tx2.tsondw 

FROM TAUK A join TAUP C ON
  c.RFIRM=a.nFIRM and 
  c.RWW=a.NWW and 
  c.RYY=a.NYY and 
   c.RKOMNR=a.NKOMNR left join KLDAT2.FK4DB#T b on 
            a.NFIRM=b.FIRM and 
            a.NWW=b.WW and 
			a.NYY=b.YY and 
			a.NKOMNR=b.KOMNR and 
			c.RPOSNR =b.posnr
left join kldat2.komdxd p on
 p.FiRM=c.rFIRM and 
 p.WW=c.rWW and 
 p.YY=c.rYY and 
 p.KOMNR=c.rKOMNR 
 and p.POSNR =c.RPOSNR
left join nodat.teis#t t on 
c.rfirm = t.tfirm and 
c.rartnr = t.tteiln  LEFT JOIN kldat2.pfkust2 k 
 on 
    a.nfirm = k.bfirm and 
	a.nkdnr = k.bkdnr  
        join kldat2.aufar2w  aufar2w on a.naufar = aufar2w.naufar LEFT JOIN NODAT.DNI Y ON 
A.NREDAT = Y.YYYYMMDD   left join vbnrlst tx on 
 a.nfirm = tx.tfirm and 
 k.BVBNR = tx.tnrvbnr LEFT JOIN NVNTRLST VNT ON 
 A.NFIRM = VNT.TFIRM AND 
 k.bvtnr = VNT.tnrvbnr
---  left join DIRECTFAXF.FAXKA kl2 on 
 --- (k.bkdnr*1000000000) =  (kl2.kaintn) 
---    left join kldat2.PFSONW tx2 on 
---    c.rfirm = tx2.tfirm and
    --- c.rww = tx2.tww and 
	--- c.ryy = tx2.tyy and 
	---c.rkomnr = tx2.tkomnr and 
	--- c.rposnr = tx2.tposnr
 ), 
 TMP2 AS ( select NFIRM,
 x.rfrei6, 
 x.VERBAND,x.OPIS_VERB,x.KUNDE,x.BNAME,x.BPLZ,x.BORT,
 x.BSTR,x.BKZAUS,
 --- x.KALKZ,
 --- x.KAVORW,
 --- x.KATEL,
 --- x.KAFAX,
 x.RVTNR,
 x.BRAB1,
 x.BSKONT,
 x.OPIS_VNTNR,
 x.NYY, 
 x.NKOMNR, 
 x.RPOSNR, 
 x.PROD,
 --- x.nr800, 
--- x.nr2, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=2 AND LWAEHR='DE' AND LCHVAL=x.nr2) AS cecha_nr2_Stoff, 
--- x.nr3, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=2 AND LWAEHR='DE' AND LCHVAL=x.nr3) AS cecha_nr3_Stoff2, 

--- x.nr8, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=8 AND LWAEHR='DE' AND LCHVAL=x.nr8) AS cecha_nr8_Plattenform, 

--- x.nr20, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=20 AND LWAEHR='DE' AND LCHVAL=x.nr20) AS cecha_nr20_Gestell, 

--- x.nr31, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=31 AND LWAEHR='DE' AND LCHVAL=x.nr31) AS cecha_nr31_Fuss, 
--- x.nr351, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=351 AND LWAEHR='DE' AND LCHVAL=x.nr351) AS cecha_nr351_Lehne, 
--- x.nr353, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=353 AND LWAEHR='DE' AND LCHVAL=x.nr353) AS cecha_nr353_Sitzkomfort, 
--- x.nr355, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=355 AND LWAEHR='DE' AND LCHVAL=x.nr355) AS cecha_nr355_Sitzschale, 
--- x.nr358, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=358 AND LWAEHR='DE' AND LCHVAL=x.nr358) AS cecha_nr358_Steppung, 

--- x.nr360 as cecha_nr_360_Lange_1, 
--- x.nr370 as cecha_nr_370_Lange_2, 
--- x.nr400, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=400 AND LWAEHR='DE' AND LCHVAL=x.nr400) AS cecha_nr400_Zusatzteile, 
--- x.nr410, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=410 AND LWAEHR='DE' AND LCHVAL=x.nr410) AS cecha_nr410_VersionEcke, 
--- x.nr347, 
--- x.nr348, 
--- x.nr349, 
--- x.nr350, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=350 AND LWAEHR='DE' AND LCHVAL=x.nr350) AS cecha_nr350_VersionEcke, 
--- x.nr352, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=352 AND LWAEHR='DE' AND LCHVAL=x.nr352) AS cecha_nr352_VersionGestel, 

--- x.nr604, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=604 AND LWAEHR='DE' AND LCHVAL=x.nr604) AS cecha_nr604_Armlehne, 
--- x.nr601, 
--- x.nr602, 
--- x.nr603, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=603 AND LWAEHR='DE' AND LCHVAL=x.nr603) AS cecha_nr603_Aplikacja, 
--- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=800 AND LWAEHR='DE' AND LCHVAL=x.nr800) AS cecha_nr800_HolzArt, 
--- x.nr1, 
   --- (SELECT LCHVBZ FROM SMARDAT.CECHVL WHERE  LFIRM=X.Prod AND LCHKOD=1 AND LWAEHR='DE' AND LCHVAL=x.nr1) AS cecha_nr1_Beizton, 
 x.PROG,
 x.NProg,
 x.FUNKCJA,
 x.NFunkcja, 
 x.PROGRAM3,x.rartnr7, 
 x.rabez, 
 x.YYYY,
 x.YYYYMM, 
 X.NAUVOM, 
 x.WERT4,
 x.WERT2,
 x.WERT3,
 x.SRWERT, 
 x.SRFAKTPR, 
 ---((x.SRFAKTPR- (x.SRFAKTPR*(x.BRAB1/100)))- ((x.SRFAKTPR- (x.SRFAKTPR*(x.BRAB1/100)))- ((x.SRFAKTPR- (x.SRFAKTPR*(x.BRAB1/100)))*(x.BSKONT/100)))) as "2x Netto", 
 X.RABAT1, 
 round((x.SRFAKTPR-X.RABAT1), 2) as NETTO, 
 ---((x.SRFAKTPR-X.RABAT1)-((x.SRFAKTPR-X.RABAT1)*(cast(x.BSKONT as decimal(2, 0))/100.00))) as Netto2x, 
 x.MENGE,
--- X.EKPR,
--- X.wertek,
--- X.NAZCMBALL, 
--- X.WARTMATRLC,
---x.tsondw
 from tmp x
 )
 SELECT NFIRM,
 rfrei6, 
 Y.VERBAND as "VB-NR",
 Y.OPIS_VERB AS "VERBAND",
 grk.klient as "Gr_Kl_Klient", 
 (select nazwa from newage.klient where firma=nfirm and klientnr=grk.klient fetch first 1 rows only  ) as "Gr_Kl_Klient_Opis", 
 grk.nadgrupa as "Gr_Kl_Nadgrupa", 
 (select nazwa from newage.klient where firma=nfirm and klientnr=grk.nadgrupa fetch first 1 rows only  ) as "Gr_Kl_Nadgrupa_Opis", 
 grk.grupa as "Gr_Kl_Verband",
 (select nazwa from newage.klient where firma=nfirm and klientnr=grk.grupa fetch first 1 rows only  ) as "Gr_Kl_Verband_Opis", 
 Y.KUNDE AS "KD-NR",
 Y.BNAME AS "KUNDE",
 Y.BPLZ AS "PLZ",
 Y.BORT AS "ORT",
 Y.BSTR AS "STR",
 Y.BKZAUS AS "LAND",
 ---Y.KALKZ AS ,
 --- Y.KAVORW AS "VORWAHL",
 --- Y.KATEL AS "TEL",
 --- Y.KAFAX AS "FAX",
 Y.RVTNR AS "VT-NR",
 Y.BRAB1 AS "RABAT",
 Y.BSKONT AS "SKONTO",
 Y.OPIS_VNTNR AS "VT",
 y.NYY, 
 y.NKOMNR, 
 y.RPOSNR, 
 Y.PROD,
--- y.nr800, 
--- y.cecha_nr800_HolzArt, 
--- 	y.nr1, 
   --- y.cecha_nr1_Beizton,  
   
--- y.nr2, 
--- y.cecha_nr2_Stoff,
--- y.nr3, 
--- y.cecha_nr3_Stoff2, 

--- y.nr20, 
--- y.cecha_nr20_Gestell, 

--- y.nr355, 
--- y.cecha_nr355_Sitzschale, 

--- y.nr31, 
--- y.cecha_nr31_Fuss, 
--- y.nr351, 
--- y.cecha_nr351_Lehne, 

--- y.nr353, 
--- y.cecha_nr353_Sitzkomfort, 
--- y.nr358, 
--- y.cecha_nr358_Steppung, 

--- y.nr8, 
--- y.cecha_nr8_Plattenform, 
--- y.cecha_nr_360_Lange_1, 
--- y.cecha_nr_370_Lange_2, 
--- y.nr400, 
--- y.cecha_nr400_Zusatzteile, 
--- y.nr410, 
--- y.cecha_nr410_VersionEcke, 
--- y.nr347, 
--- y.nr348, 
--- y.nr349, 
--- y.nr350, 
--- y.cecha_nr350_VersionEcke, 
--- y.nr352, 
--- y.cecha_nr352_VersionGestel, 
--- y.nr8, 
--- y.cecha_nr8_Plattenform, 

--- y.nr603, 
--- y.cecha_nr603_Aplikacja, 
--- y.nr604, 
--- y.cecha_nr604_Armlehne, 
--- y.nr601, 
--- y.nr602, 
   
 Y.PROG AS "PROGRAMM",
 Y.NProg, 
 Y.FUNKCJA AS "STATISTIC",
 Y.NFunkcja, 
 Y.PROGRAM3 AS "TISCHSYSTEM",
 Y.rartnr7, 
 Y.rabez, 
 Y.YYYY AS "JAHR",
 Y.YYYYMM AS "MONAT",
 Y.NAUVOM, 
 Y.SRFAKTPR AS "FAKTURA", 
 Y.NETTO AS "NETTO", 
 ROUND((Y.NETTO-(Y.NETTO*Y.BSKONT/100.00)), 2) AS "2X_NETTO", 
 Y.SRWERT AS "3X_NETTO", 
 ---Y.WERT3 AS "3X_NETTO",
 ---Y.WERT4,
 ---Y.WERT2,
 ---,
 Y.MENGE 
 --- Y.EKPR,
--- Y.wertek,
--- Y.NAZCMBALL, 
--- Y.WARTMATRLC  , 
--- tsondw, 
 1 AS INF 
 FROM TMP2 Y left join newage.grupyk grk on 
          y.nfirm = grk.firma and 
		  y.KUNDE = grk.sklep  and grk.sklep>0 
 

FOR READ ONLY ;

OPEN C1 ;
SET RESULT SETS CURSOR C1 ;

END  ;
COMMENT ON SPECIFIC procedure POLARYS.DKKRAP081 IS 	'DKK RAP FILIP ' ; 
GRANT EXECUTE ON procedure POLARYS.DKKRAP081 TO PUBLIC  ; 
CALL POLARYS.DKKRAP081(1, 20110701, 20110731)