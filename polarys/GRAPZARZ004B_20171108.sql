--- User: Mirosława Wicka
--- Data zmiany 2014-02-19
 drop procedure POLARYS.grapzarz004B;
CREATE PROCEDURE POLARYS.grapzarz004B(	
	   FIRMA1 DECIMAL(2, 0) , 
       FIRMA2 DECIMAL(2, 0),        
	   FIRMA3 DECIMAL(3, 0),         
	   DATOD DECIMAL(8, 0),         
	   DATDO DECIMAL(8, 0)  ) 	
	   DYNAMIC RESULT SETS 1	
	   LANGUAGE SQL	
	   SPECIFIC POLARYS.grapzarz004B 	
	   DETERMINISTIC  	READS SQL DATA
	   BEGIN
	   DECLARE C1 CURSOR FOR
	   with faktur as ( 
	    select * 
	   from zlecdat.faktur#t
	   where ffirm =FIRMA1 and fww=20 and fdats between DATOD and DATDO   AND FKDNR=200102 
		union all	
		select * 
	   from zlecdat.faktur#t
	   where ffirm =FIRMA2 and fww=20 and fdats between DATOD and DATDO AND FKDNR=204992
	    UNION ALL 
		select * 
	    from zlecdat.faktur#t
	   where ffirm =FIRMA3 and fww=20 and fdats between DATOD and DATDO AND FKDNR=351135  ), 
	   faktd as ( select afirm, aww, ayy, anrfa, alpfa, aartnr, achcmb, atxtp, akor, ailosc, 
	   awrnt, awrntp,A.ACENW, A.ACENWR, A.AWRBT , a.astat3               
	   from faktur f inner join zlecdat.faktdt#t a on                 
       f.ffirm = a.afirm and        
	   f.fww = a.aww and          
	   f.fyy =a.ayy and     
	   f.fnrfa = a.anrfa AND	
	   F.FSTAT3=A.ASTAT3) 
	   select f.FFIRM, f.FWAEHR, f.FDATS,f.FKDNR,b.BNAME, f.FYY, f.FNRFA,f.FRJSTR,f.FKURS, a.ALPFA,
	   a.AARTNR, 
	   T.TBEZ as opis, a.ACHCMB, 
	   sqlf.nazcmb(a.afirm, a.achcmb) as opis_komb, 
	   a.ATXTP,AILOSC, 
	   A.AWRNT,
	   A.AWRNTP,ACENW,ACENWR,AWRBT,KSTAT3,
	   KJAHRH,KJAHR,KKOMNR,KWWZS,KYYZS,KNRZS, KLPZS, KMENGE, n2.NREDAT,
	    n2.NRENR, 
		n2.naufar as typ_kom, 
		r2.rekpr, 
	    n2.NKOMNA, 
	    n2.NNAME,
	    n2.NFIBEZ,
		N2.NSTR, 
		n2.NPLZ,
		n2.NORT,
	   coalesce(KMENGE, AILOSC) as ile2,
	   ((COALESCE(K.KMENGE, A.AILOSC))) as Ile, 
       ((COALESCE(K.KMENGE, A.AILOSC))* round((A.AWRNT/A.ailosc),2 )) as NettoWal, 
       ((COALESCE(K.KMENGE, A.AILOSC))* round((A.AWRBT/A.ailosc),2 ) ) as BruttoWal,
       (F.FKURS*(COALESCE(K.KMENGE, A.AILOSC))* A.ACENWR ) as BruttoPLN, 
	   SQLF.TXT1 ( N.NFIRM , N.NTXTW ) AS UW_NAG_KOM_L1,
	   SQLF.TXT ( N.NFIRM , N.NTXTW, 1 ) AS UW_NAG_KOM_L2, 
	   SQLF.TXT ( R.RFIRM , R.RTXTW, 1 ) AS UW_POZ_KOM_L1, 
	   COALESCE(coalesce((select sum(akgn) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr=r.rartnr and o.achcmb=r.rchcmb AND akgn>0),
		(select sum(akgn) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr=r.rartnr and o.achcmb=0 AND akgn>0) ), 0)	   as waga_wyrob_netto,
		COALESCE(coalesce((select sum(akg) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr=r.rartnr and o.achcmb=r.rchcmb AND akg>0),
		(select sum(akg) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr=r.rartnr and o.achcmb=0 AND akg>0) ), 0)	   as waga_wyrob,
	   COALESCE(coalesce((select sum(akgktn) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr=r.rartnr and o.achcmb=r.rchcmb AND akgktn>0),
		(select sum(akgktn) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr=r.rartnr and o.achcmb=0 AND akgktn>0) ), 10.7)	   as waga_karton,
	   COALESCE(coalesce((select sum(akgfol) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr=r.rartnr and o.achcmb=r.rchcmb AND akgfol>0),
(select sum(akgfol) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr=r.rartnr and o.achcmb=0 AND akgfol>0 ) ), 0.1)	   as waga_folia,
	   coalesce((select sum(akgt-akgktn-akgfol) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr = r.rartnr and o.achcmb=r.rchcmb),
(select sum(akgt-akgktn-akgfol) from zlecdat.opak#t o  where o.afirm=r.rfirm and o.aartnr = r.rartnr and o.achcmb=0))	   as waga_styropian,
	   1 as inf 
	   from faktur f inner join faktd a on  
	   f.ffirm = a.afirm and      
	   f.fww = a.aww and    
       f.fyy = a.ayy and      
	   f.fnrfa = a.anrfa and 
	   f.fstat3 = a.astat3 left join nodat.pfkust b on      
	   f.ffirm = b.bfirm and   
	   f.fkdnr = b.bkdnr left join zlecdat.rekom k on    
	   k.kfirm = a.afirm and 
	   k.kww = a.aww and   
	   k.kyy  = a.ayy and      
	   k.knrfa = a.anrfa and 
	   k.klpfa = a.alpfa and           
       k.kstat3 = a.astat3
---	   left join nodat.pfwyro a2 on       
	---   a.afirm = a2.afirm and            
	 ---  a.aartnr = a2.aartnr 
			left join nodat.teis#T t on            
	   a.afirm = t.tfirm and             
	   a.aartnr = t.tteiln left join kldat2.taup#T r2 on             
	   r2.rfirm=1 and           
	   k.kjahrh = r2.rww and        
	   k.kjahr = r2.ryy and        
	   k.kkomnr = r2.rkomnr and                 
	   k.klpzs = r2.RPOSNR and                   
	   k.kfirm = r2.rfirmp left join kldat2.tauk#T n2 on    
	   r2.rfirm = n2.nfirm and          
	   r2.rww = n2.nww and          
	   r2.ryy = n2.nyy and    
	   r2.rkomnr = n2.nkomnr LEFT JOIN ZLECDAT.ZAMD#T R ON
	   K.KFIRM = R.RFIRM AND
	   K.KWWZS = R.RWW AND
	   K.KYYZS = R.RYY AND
	   K.KNRZS = R.RNRZS AND
	   K.KLPZS = R.RLP LEFT JOIN ZLECDAT.ZAMH N ON
	   R.RFIRM = N.NFIRM AND
	   R.RWW = N.NWW AND
	   R.RYY = N.NYY AND
	   R.RNRZS = N.NNRZS 
---	   LEFT JOIN nodat.TXTPF  TUWN1 ON
	   --- N.NFIRM = TUWN1.TFIRM AND
	   --- N.NTXTW = TUWN1.TTXTW AND
	   --- TUWN1.TLP=1  LEFT JOIN nodat.TXTPF  TUWN2 ON
	   --- N.NFIRM = TUWN2.TFIRM AND
	   --- N.NTXTW = TUWN2.TTXTW AND
	   --- TUWN2.TLP=2  LEFT JOIN nodat.TXTPF TUWP1 ON
	   --- R.RFIRM = TUWP1.TFIRM AND
	   --- R.RTXTW = TUWP1.TTXTW AND
	   --- TUWP1.TLP=1

	   FOR READ ONLY;OPEN C1 ;
	   SET RESULT SETS  CURSOR C1;
	   END  ;
COMMENT ON SPECIFIC procedure POLARYS.grapzarz004B IS 	'Gfm, zakupy z fabryk plus info o komisji ' ; 
GRANT EXECUTE ON procedure POLARYS.grapzarz004B TO PUBLIC  ;
--- CALL POLARYS.grapzarz004B(20, 30, 60, 20120423, 20120424 ) 