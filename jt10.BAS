10 cls : gotoxy 25,4 : print "JACK TROT(c)..words ex proverbs" : gotoxy 27,5 : print "please wait"
20 dim pr(150),pr$(150,15),t$(600),ti$(200,3),td$(3),gu$(15),r$(600),sw$(600)
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
355 p% = p%-1
360 while t$(t%) <> "zo"
370 t% = t%+ 1 : read t$(t%)
380 wend
390 t% = t%-1
400 return
410 data "b","c","d","e","f","g","h","I","J","k","|","m","n","o","p","q","r","S","t","u","v","w"
420 data "in","on","by","at","he","no","an","is","ho","ma","be","hi","yo"
430 data "jack","il","bo","un","con","do","ex","if","lo","so"
440 data "zo"
450 rem**** show tile
460 vol = 0
470 for ti = 1 to 3
480 td$(ti) = ti$(we, ti)
490 t$((gut%-1)*3+ti) = td$(ti)
500 moveto 30,90+16*(ti-1)
510 graphics drawtext td$(ti)
520 vol = vol+len(td$(ti))
530 next ti
540 vol% = vol/ 3
550 moveto 100,123 : graphics drawtext str$(vol%)
560 gut% = gut%+ 1
570 if gut% > 3*hgt% then gut% = 1
580 return
590 rem***** draw tile box
600 graphics fillrect 21,78,119,127,- 1
610 graphics rect 20,77,120,128
620 moveto 130,100 : graphics drawtext "Tile No" +str$(rug%)
630 return
640 rem **** draw proverb boxes
650 for a = 0 to k(p)-1
660 graphics rect 5+a*480/k(p), 1+ (p-1)*155,5+(a+1)*480/k(p),52+(p-1)*155
670 next a
680 return
690 rem*** select proverb
700 graphics fillrect 5,1+(p-1)*130,485,56+(p-1)*155,-1
710 randomize timer
720 c(p) = rnd(p%-1)+1 : k(p) = pr(cp(p))
730 if cp(1) = cp(2) or k(p) = 0 then goto 710
740 for b = 1 to k(p) : cp$(p,b) = pr$(cp(p),b) : ppb$(p,b) = ' : next b
750 grab%(p) = 0: count(p) = 0
760 return
770 rem*** show player 2 proverb
780 for a = 1 to k(2)
790 moveto 45+(a-1)*480/k(2),156 : graphics drawtext str$(a)
800 moveto 5+(a-1)*480/k(2),142 : graphics drawtext cp$(2,a)
810 next a
820 return
830 rem** tile match
840 q(p) = 0
850 for m = 1 to 3
860 if td$(m) = "" then goto 950
870 for n = 1 to k(p)
880 if ppb$(p,n) = "f" then goto 940
890 if len(td$(m)) = 1 then 920
900 if instr(cp$(p,n), ta$(m)) > O then goto 930
910 gosub 2740: if d = 21 then goto 940: else goto 930
920 if left$(cp$(p,n), 1) <> td$(m) then 940
930 q(p) = 1 : cpos(p) = n: n = k(p) : m = 3
940 next n
950 next m
960 return
970 rem **** timing the choice
980 po = timer: pot(p) = 0
990 gosub 830
1000 if q(p) = 1 then pot(p) = (timer-po) *ke%
1010 return
1020 rem****showinf tile placement
1030 grab%(p) = grab%(p)+vol%: count(p) = count(p)+1 : ppb$(p, cpos(p)) = "fi"
1040 for a = 1 to 3
1050 moveto 7+480*(cpos(p)-1)/k(p), 155*(p-1) +15*a
1060 graphics drawtext td$(a)
1070 next a
1080 if p = 2 and count(2) < k(2) then gosub 1270 : gosub 1450 : return
1090 gosub 1710
1100 if count(p) < k(p) then return
1110 if p = 1 then gosub 1180: gosub 1130: gosub 690 : gosub 640 : return
1115 gosub 4000
1120 gosub 1180: gosub 1130: gosub 690 : gosub 640 : gosub 770 : return
1130 rem ****Score
1140 score(p) = score(p)+ grab%(p)
1150 gotoxy 50,2+(p-1)*2 : print "score for player ";"1 ";"is " ;score(p)
1160 if score(p) > 100 then gotoxy 2,3 : print "congratulations:player ";p;" won" : end
1170 return
1180 rem ****show player i proverb
1190 sound rnd(600) +500, rnd(0.6) +0. 6,rnd(60)+60
1200 sound rnd(600) +500,rnd(0.6) +0.6,rnd(60) + 60
1210 if p = 2 then return
1220 moveto 5,64
1230 for a = 1 to k(1) : hr$ = hr$+cp$(1,a) : next a
1240 graphics drawtext hr$
1250 hr$ = ""
1260 return
1270 rem**** guessing
1280 if p = 2 then guess = 1 : else guess = 2
1290 rem*
1300 for a = blob(guess) to p%
1310 if pr(a) > k(p) then goto 1400
1320 for c = 1 to pr(a)
1330 for b = 1 to 3
1335 if td$(b) = "" then goto 1380
1340 if len(td$(b)) = 1 then goto 1360
1350 if instr(pr$(a,c), td$(b)) = 0 then goto 1380 : else goto 1370
1360 if left$(pr$(a,c), 1) <> td$(b) then goto 1380
1370 b = 3: blob(guess) = a : c = pr (a) : a = p%+2
1380 next b
1390 next c
1400 next a
1410 if a = p%+ 1 then blob(guess) = 1 : goto 1290
1420 blob(guess) = blob(guess) + 1
1430 if blob(guess) > p% then blob(guess) = 1
1440 return
1450 rem** verify guess
1460 cob = 0
1470 for b = 1 to k(p)
1480 if pr$(blob(guess)-1 ,b) = cp$(p,b) then cob = cob+1
1490 next b
1500 gotoxy O,guess* 3
1510 print "player"; guess;" guess: ";
1520 for f = 1 to k(p) : print pr$(blob(guess)-1,f); : next f: print "         "
1530 gosub 1710
1540 if cob = k(p) then gotoxy 0,0 : print "good guess" : gosub 1570 : return
1550 gotoxy 0,0 : print "poor guess" : gosub 1660
1560 return
1570 rem**score after good guess
1580 score(guess) = score(guess)+ grab%(p)
1590 gotoxy 50,2+(guess-1)*2: print "score for player ";"1 ";"is ";score(guess)
1600 if score(guess) > 100 then gotoxy 2,3 : print "congratulations:player ";guess;" won" : end
1610 graphics fillrect 5,(p-1)*130,485,60+ (p-1)*165,-1
1615 if p = 2 then gosub 4000: else 1620
1617 if w$ = "g" then return
1620 gosub 690 : gosub 640
1630 if p = 2 then gosub 770
1640 gosub 1710
1650 return
1660 rem****** score with bad guess
1670 score(p) = score(p)+2
1680 gotoxy 50,2+(p-1)*2 : print "SCORE for PLAYER ";p;" is ";score(p)
1690 if score(p) > 100 then gotoxy 0,0: print "congratulations old bean : player ";p;" won " : end""
1700 return
1710 rem***pause
1720 a$ = ""
1730 for wait = 1 to cor%
1740 a$ = inkey$
1750 if a$ = "c" then wait = 100
1760 if a$ = "e" then gosub 6000 : print "you asked me to finish, so I did" : end
1770 next wait
1780 return
1790 rem****cls***
1800 for a = 0 to 6 step 3
1810 gotoxy 0,a
1820 for b = 1 to 60
1830 print " ";
1840 next b
1850 next a
1860 return
1870 rem**eliminate 00 line
1880 gotoxy 0,0
1890 for a = 1 to 56 : print " ";: next a
1900 return
1910 rem***** player choice
1920 b$ = "": po = 0: pot(2) = 0: po = timer: gotoxy 0,0 : print "ACTION::Tile(y);g;e?"
1930 for c = 1 to ke%
1940 b$ = inkey$
1950 if b$ = "e" then print "you asked me to stop so I have" : end
1960 if b$ = "g" then gosub 2180
1970 if b$ = "y" then pot(2) = timer-po: c = ke%
1980 next C
1990 return
2000 rem***** putting in request for tile
2010 gotoxy 0,0 : print ""
2020 gotoxy 0,0 : input "which proverb box?",box
2030 if box > k(2) or box < 1 then gotoxy 0,0 : print "no box:try again" : goto 2010
2040 if ppb$(2,box) = "f" then p = 2 : gosub 1660: gotoxy 0,0 : print "already used ; you know!!!!!!": return
2050 gosub 2080
2060 if but = 1 then cpos(2) = box: gosub 1020 : return
2070 gotoxy 0,0 : print "wrong box:dunderhead!" : p = 1 : gosub 1660 : return
2080 rem****check validity of box
2090 but = 0
2100 for a = 1 to 3
2102 if td$(a) = "" then goto 2160
2105 if len(td$(a)) = 1 then goto 2140
2110 if instr(cp$(2,box), td$(a)) > 0 then goto 2150
2120 gosub 3000
2130 if d = 21 then goto 2160: else goto 2150
2140 if left$(cp$(2,box), 1) <> td$(a) then 2160
2150 but = 1: a = 3
2160 next a
2170 return
2180 rem*****guesssing
2190 if count(2) < nous/2 then goto 2200: else goto 2210
2200 b$ = "" : gotoxy 0,0 : print "Sorry you have not tried yet": gosub 1710: return
2210 gotoxy 0,0 : print "type guess(abort by space bar/return)"
2220 gotoxy 0,6 : input "guess ";pg$
2230 if pg$ = " " then return
2240 iris = 1 : 1% = 1 : 95 = " "
2250 while iris
2260 gu = instr(pg$, q$)
2270 if gu = 0 then gu$(n%) = pg$ : iris = 0 : goto 2310
2280 gu$(n%) = left$(pg$,gu)
2290 pg$ = right$(pg$,len(pg$)-gu)
2300 n% = n%+1
2310 wend
2320 rem
2330 calk = 0
2340 for db = 1 to n%
2350 if gu$(db) = cp$(1 ,db) then calk = calk+1
2360 next db
2370 gotoxy 0,0
2380 if calk = k(1)-2 then print "close guess,but 2 are wrong" : p = 1 : gosub 1660 : p = 2 : return
2390 if calk < k(1)-2 then print "not a good guess dick head" : p = 1 : gosub 1660 : p = 2 : return
2400 if calk = k(1)-1 then print "close enough buddy"
2410 if calk = k(1) then print "EXCELLENT GUESS"
2420 score(2) = score(2)+ grab%(1)+(k(1)-count(1))*2
2430 gotoxy 50,4 : print "score for player "ip;" is ";score(2)
2440 if score(2) > 100 then gotoxy 25,4 : print "YOU WIN: congratulations" : end
2450 p = 1 : gosub 690 : gosub 640 : return
2460 rem***** timing choice
2470 if pot(1) = 0 and pot(2) = O then return
2480 if pot(1) = 0 then p = 2 : gosub 2000 : return
2490 if pot(2) = 0 then p = 1 : gosub 1020 : return
2500 if pot(1) > pot(2) then p = 2 : gosub 2000: else p = 1 : gosub 1020
2510 return
2520 rem****randomise word array
2530 h% = ht%
2540 for b = 1 to 3
2550 for a = 1 to hgt%
2560 randomize timer
2570 9% = rnd(h%)+1
2580 tis(a,b) = r$(g%)
2590 for d = g% to h%-1
2600 r$(d) = r$(d+1)
2610 next d
2620 h% = h%-1
2630 next a
2640 next b
2650 return
2660 rem****randomise words 2*
2670 for a = 0 to ht%-1
2680 r$(a+1) = sw$(5*a+nous)
2690 next a
2700 return
2710 rem*****word duplicate
2720 for a = 1 to t% : SW$(a) = t$(a) : next a
2730 return
2740 rem**** elaboration of fit****
2750 xi$ = td$(m) : gi$ = cp$(p,n) : if gi$ = "" then d = 0 : return
2760 for d = 1 to len(xi$)
2770 if gi$ = "" then d = 20 : goto 2800
2780 top = instr(giS,mid$(xiS,d, 1)) : if top = 0 then d = 20 : goto 2800
2790 gi$ = right$(gi$,len (gi$)-top)
2800 next d
2810 return
3000 rem****player two tile checker exrended
3010 gr$ = cp$(2,box)
3015 if gr$ = "" then d = 0 : return
3020 for d = 1 to len(td$(a))
3030 if gr$ = "" then d = 20: goto 3060
3049 tap = instr(gr$,mid$(td$(a),d, 1)) : if tap = 0 then d = 20 : goto 3060
3050 gr$ = right$(gr$,len (gr$)-tap)
3060 next d
3070 return
3490 rem******inserting your own proverb****
3510 gotoxy 0,0
3560 input "type proverb (<=12 words) ";pub$: gotoxy 0,3 : print pub$
3570 gosub 5000
3580 graphics fillect 5,131,485,211,-1
3600 for ball = 1 to k(2) : cp$(2,ball) = p$(ball) : ppb$(2,ball) = "" : next ball
3610 gosub 640: gosub 770 : count(2) = 0 : grab%(2) = 0
3630 return
4000 rem***** new proverb insertion?****
4002 gotoxy 0,0 : print "do you want a new proverb, (y/n)"
4010 c$= "" : w$=""
4020 for a = 1 to 150
4030 c$ = inkey$
4040 if c$ = "n" or c$ = "y" then a = 150
4042 if c$ = "y" then w$ = "g" : gosub 3490
4045 next a
4050 return
5000 rem *****adding proverbs****
5010 p% = p%+ 1 : m$ = pub$: flag = 1 : w = 1 : q$ = " " : n = 1
5020 while flag
5030 m = instr(m$, q$)
5040 if m = 0 then p$(n) = m$: flag = 0 : goto 5070
5050 p$(n) = left$(m$,m)
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