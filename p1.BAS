/* 
MAKE - PROVERB LIST OF APROXIMATELY 60 PROVERBS OR MORE - SAY 4-8 characters long
GO PROVERAS OR
*/

10 cls : gotoxy 25,4 : print "JACK TROT(c)..words ex proverbs" : gotoxy 27,5 : print"please wait"
20 dim pr(150), pr$(150,15), t$(600), ti$(200,3), td$ (3), gu$ (15),r$ (600),sw$(600)
30 dim K(2), c(2), cp$(2,15), ppb$(2,15),score(2), q(2),bag%(2), count(2), cpos(2), pot(2), grab%(2),blob(2), p$(20)
40 t% = 0 : p% = 0 : a% = 0 : cor% = 100 : gut% = 1 : ke% = 200 : rug% = 1
50 gosub 260 : gosub 2710 : ht% = t%/5 : hgt% = t%/15
60 cls
70 graphics window 500,220
80 for p = 1 to 2 : gosub 690 : gosub 640 : next p: gosub 770
90 rem*****
100 for nous = 1 to 5
110 gosub 2660 : gosub 2520
120 for we = 1 to hgt%
130 gosub 590: gosub 450
140 if count(1) = 1 then graphics fillrect 5,56,300,73,-1
150 if we/2-int(we/2) = 0 then gosub 1790: else gosub 1870
160 p = 1 : gosub 970 : p = 2: gosub 1910
170 gosub 2460
180 cor% = cor%-1 : ke% = ke%-1
190 if co% = 2 then cor% = 100/nous
200 if ke% = 10 then ke% = 200/nous
210 rug% = rug%+ 1
220 next we
230 next nous
240 gob% = gob%+ 1
250 gosub 2710: goto 90
260 rem*******proverb list and words
270 open "proverblist" for input as #1
280 while not eof
290 p% = p%+1 : input #1,pr(p%)
300 for a = 1 to pr (p%)
310 t% = t%+ 1 : input #1,s$ : pr$(p%,a) = s$
320 if right$(s$,1) = " " then t$(t%) = left$(s$,len(s$)-1) : else t$(t%) = s$
330 next a
340 wend
350 close #1
355 р% = р%-1
360 while t$(t%) <> "zo"
370 t% = t%+ 1 : read t$(t%)
380 wend
390 t% = t%-1
400 return
410 data "b", "c", "d","e", "f","g", "h", "I","J","k","|", "m", "n","o","p", "q", r", "S", "t", "u", "v","w"
420 data "in", "on","by", "at", "he", "no", "an", "is", "ho", "ma","be", "hi", "yo"