--- Plik do raportu wejsc zamowien dla Reisenberga

--- drop procedure POLARYS.DKKRAP058;
CREATE PROCEDURE POLARYS.DKKRAP058(
	FIRMA DECIMAL(2, 0),
	PARABOD DECIMAL(8, 0),
	PARABDO DECIMAL(8, 0)
)
	DYNAMIC RESULT SETS 1 
	LANGUAGE SQL
	
	SPECIFIC POLARYS.DKKRAP058 
	DETERMINISTIC

  	READS SQL DATA

BEGIN

DECLARE C1 CURSOR FOR


select nfirm, nww, nyy, nkomnr, nposnr, nkdnr, nvtnr, nkdnrf, nliefw, nfitm, nauvom, nlgnr, nvbnr, nkdauf, nudat, nkomna, nname, neidat, nredat, nrenr, naufar, nwuntw, stnegd,
((substring(digits(NFIRM), 1, 2) || NWW || substring(DIGITS(NYY), 1, 2) || substring(DIGITS(NKOMNR), 1, 6) || substring(DIGITS(NPOSNR), 1, 2)) ||'0') as EVNKEY,
E.times, e.jobnr, e.data, 
rtrim(substring(e.data, 5, 79)) as adres_email_send, 
e.evnid, e.dslib, e.dsname,
--- ('20' || RIGHT(NEIDAT, 2)) AS ROK_TYDZIEN, 
(N.NYY || RIGHT(NEIDAT, 2)) AS ROK_TYDZIEN, 
saidat.fgetpathevn( 
		'ASNOWE', 
		((substring(digits(NFIRM), 1, 2) || NWW || substring(DIGITS(NYY), 1, 2) || substring(DIGITS(NKOMNR), 1, 6) || substring(DIGITS(NPOSNR), 1, 2)) ||'0'), 
		'AB'
		) AS PATH,
RTRIM((select substring(TDANE, 11, 50) from nodat.notab where tfirm=nfirm and tnrtab='HK0045' AND LEFT(TDANE, 6) = CAST(NKDNR AS VARCHAR(6)) FETCH FIRST 1 ROWS ONLY )) AS NOWY_ADRES_DO_AB, 
(select COUNT(*) from nodat.notab where tfirm=nfirm and tnrtab='HK0045' AND LEFT(TDANE, 6) = CAST(NKDNR AS VARCHAR(6)) ) AS ILE_ADRESOW_AB,
'In den Anhang Auftragsbestatigung. Diese Nachricht wurde automatisch erstellt. Bitte nicht beantworten. Fragen zu Auftraegen richten Sie bitte direkt an den jeweiligen Bearbeiter, dessen Kurzzeichen Sie auf Ihrer Auftragsbestaetigung finden. As attachment an order confirmation This is an automatic message. Do not reply to this e-mail.
' as TEMAT,
1 as inf 
 from kldat2.tauk#t N LEFT JOIN nodat.evn#t  E ON 
                    e.key= ((substring(digits(NFIRM), 1, 2) || NWW || substring(DIGITS(NYY), 1, 2) || substring(DIGITS(NKOMNR), 1, 6) || substring(DIGITS(NPOSNR), 1, 2)) ||'0') and 
                    e.keyart='ZS' AND 
                    EVENT='AB'
where nfirm=1 and nww=20 and nkdnr in (select klientnr from newage.klient where firma=1 and POTWWYS='BLAT' ) and nloekz='' and nredat=0 and stnegd='K' and nschrd BETWEEN PARABOD AND PARABdo  

FOR READ ONLY ;

OPEN C1 ;
SET RESULT SETS CURSOR C1 ;

END  ;
COMMENT ON SPECIFIC procedure POLARYS.DKKRAP058 IS 	'WYSYLANIE AB' ; 
GRANT EXECUTE ON procedure POLARYS.DKKRAP058 TO PUBLIC  ; 
CALL POLARYS.DKKRAP058(1, 20180202, 20180205)