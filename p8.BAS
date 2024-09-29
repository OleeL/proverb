5060 m$ = right$(m$,len(m$)-m)
5065 n = n+1
5070 wend
5075 print "no of words in proverb is";n
5080 open "proverblist" for append as #1
5090 print #1,n
5095 for b = 1 to n
5097 print #1, p$(b)
5098 next b
5099 close #1
5100 pr(p%) = n: k(2) = n
5110 return
6000 rem***** show proverbs
6005 cls
6010 gotoxy 0,0
6020 for a = 1 to p%
6030 for b = 1 to pr(p%)
6040 print pr$(a,b);
6050 next b
6060 next a
6070 return