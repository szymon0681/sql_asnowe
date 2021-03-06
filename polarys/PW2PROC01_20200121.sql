drop procedure POLARYS.PW2PROC01; 
CREATE PROCEDURE POLARYS.PW2PROC01 ( 
	IN PARFIRMA DECIMAL(2, 0) , 
	IN PARDAT6OD DECIMAL(6, 0) , 
	IN PARDAT6DO DECIMAL(6, 0)) 
	DYNAMIC RESULT SETS 1 
	LANGUAGE SQL 
	SPECIFIC POLARYS.PW2PROC01 
	DETERMINISTIC  
	READS SQL DATA  
	CALLED ON NULL INPUT  
	SET OPTION  ALWBLK = *ALLREAD , 
	ALWCPYDTA = *OPTIMIZE , 
	COMMIT = *NONE , 
	CLOSQLCSR = *ENDMOD , 
	DECRESULT = (31, 31, 00) , 
	DFTRDBCOL = *NONE , 
	DYNDFTCOL = *NO , 
	DYNUSRPRF = *USER , 
	SRTSEQ = *HEX   
	BEGIN  
DECLARE C1 CURSOR FOR 
with matdok as ( select matdat.MATDOK#T.*, (SELECT WGESP 
FROM MATDAT.MATB#T WHERE 
 MATDAT.MATB#T.WFIRM = MATDAT.MATDOK#T.WFIRM AND 
 MATDAT.MATB#T.WLGO = MATDAT.MATDOK#T.WLGNRE AND 
 MATDAT.MATB#T.WVORG = MATDAT.MATDOK#T.WVORG AND 
 MATDAT.MATB#T.WPERJ = MATDAT.MATDOK#T.WPERJ AND 
 MATDAT.MATB#T.WBNR = MATDAT.MATDOK#T.WBNR AND 
 MATDAT.MATB#T.WPOS = MATDAT.MATDOK#T.WPOS 
  AND MATDAT.MATB#T.WLOEKZ='' 
 ) AS WART_DOK,
SQLF.GGCN ( WFIRM , LEFT ( COALESCE ( SQLF.GGCN ( WFIRM , 'GRUXX' , WTEILN ) , 'XXXXX' ) , 5 ) , WTEILN ) AS GR_PROGRAM 
 FROM  matdat.MATDOK#T 
 WHERE WFIRM=PARFIRMA AND WVORG='PW' AND WBWW=20 AND WBDAT BETWEEN PARDAT6OD AND PARDAT6DO 
 ), 
 TMP AS (
 SELECT W.WFIRM, W.GR_PROGRAM, W.WTEILN, W.WCHCMB, W.WBDAT, W.WLGNRE, W.WPSR, Y.YBEZ AS OPIS_KIERUNKU, 
   W.WBNR, W.WPOS, 
   W.WMENGE, W.WART_DOK, D.PTEILN, 
   D.PBEREI, D.PMNR, D.POPRNR, D.PABGBE, coalesce(D.PTE , 0.00) as PTE 
 FROM matdok W JOIN ZLECDAT.ZS2ZP#T F ON 
						W.WFIRM = F.FFIRM AND 
                             W.WWWZS = F.FWWZS AND  
                             W.WYYZS = F.FYYZS AND 
                             W.WNRZS = F.FNRZS AND 
                             W.WLPZS     = F.FLP JOIN ZLECDAT.ZLECPX#T P ON 
                             F.FFIRM = P.PFIRM AND 
                             F.FWWZP = P.PWW AND
                             F.FYYZP = P.PYY AND 
                             F.FNRZP = P.PNRZP JOIN SMARDAT.proctmp#t D ON 
                             P.DRZEWO_ID = D.PJOBNR LEFT JOIN nodat.PFSYMB#T Y ON 
							 W.WFIRM = Y.YFIRM AND 
							 W.WPSR = Y.YSYMB 
), 
TMP2 AS ( 
SELECT W.WFIRM, W.GR_PROGRAM, W.WTEILN, W.WCHCMB, W.WBDAT, W.WLGNRE, W.WPSR, W.OPIS_KIERUNKU, 
   W.WBNR, W.WPOS, 
   W.WMENGE, W.WART_DOK, W.PBEREI, SUM(coalesce(W.PTE, 0.00)) AS CZAS
   FROM TMP W 
   GROUP BY W.WFIRM, W.GR_PROGRAM, W.WTEILN, W.WCHCMB, W.WBDAT, W.WLGNRE, W.WPSR, W.OPIS_KIERUNKU, 
   W.WBNR, W.WPOS, 
   W.WMENGE, W.WART_DOK, W.PBEREI ), 
TMP3 AS ( 
SELECT W.WFIRM, W.GR_PROGRAM, W.WTEILN, W.WCHCMB, W.WBDAT, W.WLGNRE, W.WPSR, W.OPIS_KIERUNKU, 
   W.WBNR, W.WPOS, 
   W.WMENGE, W.WART_DOK, W.SUM_CZAS, 
   
   COALESCE(W42.CZAS, 0.00) AS CZAS_42, 
   COALESCE(W44.CZAS, 0.00) AS CZAS_44, 
   COALESCE(W51.CZAS, 0.00) AS CZAS_51,
   COALESCE(W54.CZAS, 0.00) AS CZAS_54,
   COALESCE(W61.CZAS, 0.00) AS CZAS_61,
   COALESCE(W71.CZAS, 0.00) AS CZAS_71,
   COALESCE(W74.CZAS, 0.00) AS CZAS_74
   
FROM (SELECT W.WFIRM, W.GR_PROGRAM, W.WTEILN,  W.WCHCMB, W.WBDAT, W.WLGNRE, W.WPSR, W.OPIS_KIERUNKU, 
   W.WBNR, W.WPOS, 
   W.WMENGE, W.WART_DOK, SUM(CZAS) AS SUM_CZAS 
      FROM  TMP2 W 
	  GROUP BY W.WFIRM, W.GR_PROGRAM, W.WTEILN, W.WCHCMB, W.WBDAT, W.WLGNRE, W.WPSR, W.OPIS_KIERUNKU, 
   W.WBNR, W.WPOS, 
   W.WMENGE, W.WART_DOK) W left join tmp2 w42 on 
        W.WFIRM = W42.WFIRM AND 
		W.WLGNRE = W42.WLGNRE AND 
		W.WBDAT = W42.WBDAT AND 
		W.WBNR = W42.WBNR AND 
		W.WPOS = W42.WPOS AND 
		W42.PBEREI='42' left join tmp2 w51 on 
        W.WFIRM = W51.WFIRM AND 
		W.WLGNRE = W51.WLGNRE AND 
		W.WBDAT = W51.WBDAT AND 
		W.WBNR = W51.WBNR AND 
		W.WPOS = W51.WPOS AND 
		W51.PBEREI='51'  left join tmp2 w61 on 
        W.WFIRM = W61.WFIRM AND 
		W.WLGNRE = W61.WLGNRE AND 
		W.WBDAT = W61.WBDAT AND 
		W.WBNR = W61.WBNR AND 
		W.WPOS = W61.WPOS AND 
		W61.PBEREI='61' left join tmp2 w71 on 
        W.WFIRM = W71.WFIRM AND 
		W.WLGNRE = W71.WLGNRE AND 
		W.WBDAT = W71.WBDAT AND 
		W.WBNR = W71.WBNR AND 
		W.WPOS = W71.WPOS AND 
		W71.PBEREI='71' left join tmp2 w44 on 
        W.WFIRM = W44.WFIRM AND 
		W.WLGNRE = W44.WLGNRE AND 
		W.WBDAT = W44.WBDAT AND 
		W.WBNR = W44.WBNR AND 
		W.WPOS = W44.WPOS AND 
		W44.PBEREI='44'  left join tmp2 w54 on 
        W.WFIRM = W54.WFIRM AND 
		W.WLGNRE = W54.WLGNRE AND 
		W.WBDAT = W54.WBDAT AND 
		W.WBNR = W54.WBNR AND 
		W.WPOS = W54.WPOS AND 
		W54.PBEREI='54'  left join tmp2 w74 on 
        W.WFIRM = W74.WFIRM AND 
		W.WLGNRE = W74.WLGNRE AND 
		W.WBDAT = W74.WBDAT AND 
		W.WBNR = W74.WBNR AND 
		W.WPOS = W74.WPOS AND 
		W74.PBEREI='74'
) 
   
SELECT X.WFIRM, X.GR_PROGRAM, 
(SELECT SCH_NAME FROM AMCORE.SOSCH WHERE SCH_ID=TLAGO#Q) AS OPIS_SCHEMATU,  
X.WTEILN, T.TBEZ, 
X.WCHCMB, 
SQLF.NAZCMBL(X.WFIRM, X.WCHCMB, 'PL', 255) AS OPIS_KOBINACJI, 
X.WBDAT,X.WLGNRE,X.WPSR,
X.OPIS_KIERUNKU,
X.WBNR,X.WPOS,X.WMENGE,
X.WART_DOK,X.SUM_CZAS,X.CZAS_42,X.CZAS_44,X.CZAS_51,X.CZAS_54,X.CZAS_61,X.CZAS_71,X.CZAS_74, 1 AS INF 
FROM TMP3 X LEFT JOIN NODAT.TEIS#T T ON 
      X.WFIRM = T.TFIRM AND 
	  X.WTEILN = T.TTEILN 
FOR READ ONLY ; 
OPEN C1 ; 
SET RESULT SETS CURSOR C1 ; 
END  ; 
COMMENT ON SPECIFIC PROCEDURE POLARYS.PW2PROC01 IS 'PFM Wejscie na PW ' ;
GRANT EXECUTE ON procedure POLARYS.PW2PROC01 TO PUBLIC  ; 
CALL POLARYS.PW2PROC01(60, 171001, 171005) 