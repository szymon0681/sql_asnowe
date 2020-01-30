--- User: Filip Szymoniak
--- Sprawdzenie czy Awizacja jest ok

drop procedure POLARYS.kmkrap008;
CREATE PROCEDURE POLARYS.kmkrap008(

	PARIDWYSYLKI INTEGER 
	
	) 
	DYNAMIC RESULT SETS 1
	LANGUAGE SQL
	SPECIFIC POLARYS.kmkrap008
	DETERMINISTIC
  	--- READS SQL DATA 
BEGIN 

DECLARE C1 CURSOR FOR 

select p.idy, p.wysylkah_idy, p.firmap, p.rok, p.zamnr, p.zampos, r.rartnr, r.rchcmb, r.rilzam, r.rdatr, n.dosdatz, n.stat2 , 1 as inf 
from newage.wysylka p left join zlecdat.zamd#t r on 
               p.firmap = r.rfirm and 
               p.rok=r.ryy and
                20=r.rww and
               p.zamnr = r.rnrzs and
               p.zampos = r.rlp left join newage.zamowh n on 
			   80 = n.firma and 
			   20 || p.rok  = n.rok and 
			   p.zamnr = n.zamnr 
where p.wysylkah_idy=PARIDWYSYLKI 

FOR READ ONLY;

---SET idProgram   = SQLF.SO_GET_KAT_ID( '#DKKKMK#PROGRAM');

OPEN C1 ;

SET RESULT SETS  CURSOR C1;

END  ;
COMMENT ON SPECIFIC procedure POLARYS.kmkrap008 IS 	'KMK SPRAWDZANIE AWIZACJI' ; 
GRANT EXECUTE ON procedure POLARYS.kmkrap008 TO PUBLIC  ;
CALL POLARYS.kmkrap008(2070)