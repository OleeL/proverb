10 CLS : GOTOXY 25,4 : PRINT "JACK TROT(c)..words ex proverbs" : GOTOXY 27,5 : PRINT "please wait"
20 DIM pr(150),pr$(150,15),t$(600),ti$(200,3),td$(3),gu$(15),r$(600),sw$(600)
30 DIM K(2),c(2),cp$(2,15),ppb$(2,15),score(2),q(2),bag%(2),COUNT(2),cpos(2),pot(2),grab%(2),blob(2),p$(20)
40 t% = 0 : p% = 0 : a% = 0 : cor% = 100 : gut% = 1 : ke% = 200 : rug% = 1
50 GOSUB 260 : GOSUB 2710 : ht% = t%/5 : hgt% = t%/15
60 CLS
70 GRAPHICS WINDOW 500,220
80 FOR p = 1 TO 2 : GOSUB 690 : GOSUB 640 : NEXT p : GOSUB 770
90 REM*****
100 FOR nous = 1 TO 5
110 GOSUB 2660 : GOSUB 2520
120 FOR we = 1 TO hgt%
130 GOSUB 590 : GOSUB 450
140 IF COUNT(1) = 1 THEN GRAPHICS fillrect 5,56,300,73,-1
150 IF we/2-INT(we/2) = 0 THEN GOSUB 1790 : ELSE GOSUB 1870
160 p = 1 : GOSUB 970 : p = 2: GOSUB 1910
170 GOSUB 2460
180 cor% = cor%-1 : ke% = ke%-1
190 IF co% = 2 THEN cor% = 100/nous
200 IF ke% = 10 THEN ke% = 200/nous
210 rug% = rug%+1
220 NEXT we
230 NEXT nous
240 gob% = gob%+1
250 GOSUB 2710 : GOTO 90
260 REM*******proverb list AND words
270 open "proverblist" FOR INPUT as #1
280 WHILE NOT EOF
290 p% = p%+1 : INPUT #1,pr(p%)
300 FOR a = 1 TO pr(p%)
310 t% = t%+ 1 : INPUT #1,s$ : pr$(p%,a) = s$
320 IF RIGHT$(s$,1) = " " THEN t$(t%) = LEFT$(s$,LEN(s$)-1) : ELSE t$(t%) = s$
330 NEXT a
340 WEND
350 CLOSE #1
355 p% = p%-1
360 WHILE t$(t%) <> "zo"
370 t% = t%+ 1 : READ t$(t%)
380 WEND
390 t% = t%-1
400 RETURN
410 DATA "b","c","d","e","f","g","h","I","J","k","|","m","n","o","p","q","r","S","t","u","v","w"
420 DATA "in","on","by","at","he","no","an","is","ho","ma","be","hi","yo"
430 DATA "jack","il","bo","un","con","do","ex","IF","lo","so"
440 DATA "zo"
450 REM**** show tile
460 vol = 0
470 FOR ti = 1 TO 3
480 td$(ti) = ti$(we, ti)
490 t$((gut%-1)*3+ti) = td$(ti)
500 MOVETO 30,90+16*(ti-1)
510 GRAPHICS DRAWTEXT td$(ti)
520 vol = vol+LEN(td$(ti))
530 NEXT ti
540 vol% = vol/ 3
550 MOVETO 100,123 : GRAPHICS DRAWTEXT STR$(vol%)
560 gut% = gut%+ 1
570 IF gut% > 3*hgt% THEN gut% = 1
580 RETURN
590 REM***** draw tile box
600 GRAPHICS fillrect 21,78,119,127,- 1
610 GRAPHICS rect 20,77,120,128
620 MOVETO 130,100 : GRAPHICS DRAWTEXT "Tile No"+STR$(rug%)
630 RETURN
640 REM **** draw proverb boxes
650 FOR a = 0 TO k(p)-1
660 GRAPHICS rect 5+a*480/k(p),1+(p-1)*155,5+(a+1)*480/k(p),52+(p-1)*155
670 NEXT a
680 RETURN
690 REM*** select proverb
700 GRAPHICS fillrect 5,1+(p-1)*130,485,56+(p-1)*155,-1
710 randomize timer
720 c(p) = RND(p%-1)+1 : k(p) = pr(cp(p))
730 IF cp(1) = cp(2) OR k(p) = 0 THEN GOTO 710
740 FOR b = 1 TO k(p) : cp$(p,b) = pr$(cp(p),b) : ppb$(p,b) = "" : NEXT b
750 grab%(p) = 0: COUNT(p) = 0
760 RETURN
770 REM*** show player 2 proverb
780 FOR a = 1 TO k(2)
790 MOVETO 45+(a-1)*480/k(2),156 : GRAPHICS DRAWTEXT STR$(a)
800 MOVETO 5+(a-1)*480/k(2),142 : GRAPHICS DRAWTEXT CP$(2,a)
810 NEXT a
820 RETURN
830 REM** tile match
840 q(p) = 0
850 FOR m = 1 TO 3
860 IF td$(m) = "" THEN GOTO 950
870 FOR n = 1 TO k(p)
880 IF ppb$(p,n) = "f" THEN GOTO 940
890 IF LEN(td$(m)) = 1 THEN 920
900 IF INSTR(cp$(p,n), ta$(m)) > O THEN GOTO 930
910 GOSUB 2740: IF d = 21 THEN GOTO 940: ELSE GOTO 930
920 IF LEFT$(cp$(p,n), 1) <> td$(m) THEN 940
930 q(p) = 1 : cpos(p) = n: n = k(p) : m = 3
940 NEXT n
950 NEXT m
960 RETURN
970 REM **** timing the choice
980 po = timer: pot(p) = 0
990 GOSUB 830
1000 IF q(p) = 1 THEN pot(p) = (timer-po)*ke%
1010 RETURN
1020 REM****showinf tile placement
1030 grab%(p) = grab%(p)+vol%: COUNT(p) = COUNT(p)+1 : ppb$(p, cpos(p)) = "fi"
1040 FOR a = 1 TO 3
1050 MOVETO 7+480*(cpos(p)-1)/k(p), 155*(p-1) +15*a
1060 GRAPHICS DRAWTEXT td$(a)
1070 NEXT a
1080 IF p = 2 AND COUNT(2) < k(2) THEN GOSUB 1270 : GOSUB 1450 : RETURN
1090 GOSUB 1710
1100 IF COUNT(p) < k(p) THEN RETURN
1110 IF p = 1 THEN GOSUB 1180: GOSUB 1130: GOSUB 690 : GOSUB 640 : RETURN
1115 GOSUB 4000
1120 GOSUB 1180: GOSUB 1130: GOSUB 690 : GOSUB 640 : GOSUB 770 : RETURN
1130 REM ****Score
1140 score(p) = score(p)+ grab%(p)
1150 GOTOXY 50,2+(p-1)*2 : PRINT "score for player ";"1 ";"is " ;score(p)
1160 IF score(p) > 100 THEN GOTOXY 2,3 : PRINT "congratulations:player ";p;" won" : END
1170 RETURN
1180 REM ****show player i proverb
1190 SOUND RND(600) +500, RND(0.6) +0. 6,RND(60)+60
1200 SOUND RND(600) +500,RND(0.6) +0.6,RND(60) + 60
1210 IF p = 2 THEN RETURN
1220 MOVETO 5,64
1230 FOR a = 1 TO k(1) : hr$ = hr$+cp$(1,a) : NEXT a
1240 GRAPHICS DRAWTEXT hr$
1250 hr$ = ""
1260 RETURN
1270 REM**** guessing
1280 IF p = 2 THEN guess = 1 : ELSE guess = 2
1290 REM*
1300 FOR a = blob(guess) TO p%
1310 IF pr(a) > k(p) THEN GOTO 1400
1320 FOR c = 1 TO pr(a)
1330 FOR b = 1 TO 3
1335 IF td$(b) = "" THEN GOTO 1380
1340 IF LEN(td$(b)) = 1 THEN GOTO 1360
1350 IF INSTR(pr$(a,c), td$(b)) = 0 THEN GOTO 1380 : ELSE GOTO 1370
1360 IF LEFT$(pr$(a,c), 1) <> td$(b) THEN GOTO 1380
1370 b = 3: blob(guess) = a : c = pr(a) : a = p%+2
1380 NEXT b
1390 NEXT c
1400 NEXT a
1410 IF a = p%+ 1 THEN blob(guess) = 1 : GOTO 1290
1420 blob(guess) = blob(guess) + 1
1430 IF blob(guess) > p% THEN blob(guess) = 1
1440 RETURN
1450 REM** verIFy guess
1460 cob = 0
1470 FOR b = 1 TO k(p)
1480 IF pr$(blob(guess)-1 ,b) = cp$(p,b) THEN cob = cob+1
1490 NEXT b
1500 GOTOXY O,guess* 3
1510 PRINT "player"; guess;" guess: ";
1520 FOR f = 1 TO k(p) : PRINT pr$(blob(guess)-1,f); : NEXT f: PRINT "         "
1530 GOSUB 1710
1540 IF cob = k(p) THEN GOTOXY 0,0 : PRINT "good guess" : GOSUB 1570 : RETURN
1550 GOTOXY 0,0 : PRINT "poor guess" : GOSUB 1660
1560 RETURN
1570 REM**score after good guess
1580 score(guess) = score(guess)+ grab%(p)
1590 GOTOXY 50,2+(guess-1)*2: PRINT "score FOR player ";"1 ";"is ";score(guess)
1600 IF score(guess) > 100 THEN GOTOXY 2,3 : PRINT "congratulations:player ";guess;" won" : END
1610 GRAPHICS fillrect 5,(p-1)*130,485,60+(p-1)*165,-1
1615 IF p = 2 THEN GOSUB 4000: ELSE 1620
1617 IF w$ = "g" THEN RETURN
1620 GOSUB 690 : GOSUB 640
1630 IF p = 2 THEN GOSUB 770
1640 GOSUB 1710
1650 RETURN
1660 REM****** score with bad guess
1670 score(p) = score(p)+2
1680 GOTOXY 50,2+(p-1)*2 : PRINT "SCORE FOR PLAYER ";p;" is ";score(p)
1690 IF score(p) > 100 THEN GOTOXY 0,0: PRINT "congratulations old bean : player ";p;" won " : END""
1700 RETURN
1710 REM***pause
1720 a$ = ""
1730 FOR wait = 1 TO cor%
1740 a$ = INKEY$
1750 IF a$ = "c" THEN wait = 100
1760 IF a$ = "e" THEN GOSUB 6000 : PRINT "you asked me TO finish, so I did" : END
1770 NEXT wait
1780 RETURN
1790 REM****CLS***
1800 FOR a = 0 TO 6 STEP 3
1810 GOTOXY 0,a
1820 FOR b = 1 TO 60
1830 PRINT " ";
1840 NEXT b
1850 NEXT a
1860 RETURN
1870 REM**eliminate 00 line
1880 GOTOXY 0,0
1890 FOR a = 1 TO 56 : PRINT " ";: NEXT a
1900 RETURN
1910 REM***** player choice
1920 b$ = "": po = 0: pot(2) = 0: po = timer: GOTOXY 0,0 : PRINT "ACTION::Tile(y);g;e?"
1930 FOR c = 1 TO ke%
1940 b$ = INKEY$
1950 IF b$ = "e" THEN PRINT "you asked me TO stop so I have" : END
1960 IF b$ = "g" THEN GOSUB 2180
1970 IF b$ = "y" THEN pot(2) = timer-po: c = ke%
1980 NEXT C
1990 RETURN
2000 REM***** putting in request FOR tile
2010 GOTOXY 0,0 : PRINT ""
2020 GOTOXY 0,0 : INPUT "which proverb box?",box
2030 IF box > k(2) OR box < 1 THEN GOTOXY 0,0 : PRINT "no box:try again" : GOTO 2010
2040 IF ppb$(2,box) = "f" THEN p = 2 : GOSUB 1660: GOTOXY 0,0 : PRINT "already used ; you know!!!!!!": RETURN
2050 GOSUB 2080
2060 IF but = 1 THEN cpos(2) = box: GOSUB 1020 : RETURN
2070 GOTOXY 0,0 : PRINT "wrong box:dunderhead!" : p = 1 : GOSUB 1660 : RETURN
2080 REM****check validity of box
2090 but = 0
2100 FOR a = 1 TO 3
2102 IF td$(a) = "" THEN GOTO 2160
2105 IF LEN(td$(a)) = 1 THEN GOTO 2140
2110 IF INSTR(cp$(2,box), td$(a)) > 0 THEN GOTO 2150
2120 GOSUB 3000
2130 IF d = 21 THEN GOTO 2160: ELSE GOTO 2150
2140 IF LEFT$(cp$(2,box), 1) <> td$(a) THEN 2160
2150 but = 1: a = 3
2160 NEXT a
2170 RETURN
2180 REM*****guesssing
2190 IF COUNT(2) < nous/2 THEN GOTO 2200: ELSE GOTO 2210
2200 b$ = "" : GOTOXY 0,0 : PRINT "Sorry you have not tried yet": GOSUB 1710: RETURN
2210 GOTOXY 0,0 : PRINT "type guess(abort by space bar/RETURN)"
2220 GOTOXY 0,6 : INPUT "guess ";pg$
2230 IF pg$ = " " THEN RETURN
2240 iris = 1 : 1% = 1 : 95 = " "
2250 WHILE iris
2260 gu = INSTR(pg$, q$)
2270 IF gu = 0 THEN gu$(n%) = pg$ : iris = 0 : GOTO 2310
2280 gu$(n%) = LEFT$(pg$,gu)
2290 pg$ = RIGHT$(pg$,LEN(pg$)-gu)
2300 n% = n%+1
2310 WEND
2320 REM
2330 calk = 0
2340 FOR db = 1 TO n%
2350 IF gu$(db) = cp$(1 ,db) THEN calk = calk+1
2360 NEXT db
2370 GOTOXY 0,0
2380 IF calk = k(1)-2 THEN PRINT "close guess,but 2 are wrong" : p = 1 : GOSUB 1660 : p = 2 : RETURN
2390 IF calk < k(1)-2 THEN PRINT "not a good guess dick head" : p = 1 : GOSUB 1660 : p = 2 : RETURN
2400 IF calk = k(1)-1 THEN PRINT "close enough buddy"
2410 IF calk = k(1) THEN PRINT "EXCELLENT GUESS"
2420 score(2) = score(2)+ grab%(1)+(k(1)-COUNT(1))*2
2430 GOTOXY 50,4 : PRINT "score FOR player "ip;" is ";score(2)
2440 IF score(2) > 100 THEN GOTOXY 25,4 : PRINT "YOU WIN: congratulations" : END
2450 p = 1 : GOSUB 690 : GOSUB 640 : RETURN
2460 REM***** timing choice
2470 IF pot(1) = 0 AND pot(2) = O THEN RETURN
2480 IF pot(1) = 0 THEN p = 2 : GOSUB 2000 : RETURN
2490 IF pot(2) = 0 THEN p = 1 : GOSUB 1020 : RETURN
2500 IF pot(1) > pot(2) THEN p = 2 : GOSUB 2000: ELSE p = 1 : GOSUB 1020
2510 RETURN
2520 REM****randomise word array
2530 h% = ht%
2540 FOR b = 1 TO 3
2550 FOR a = 1 TO hgt%
2560 randomize timer
2570 9% = RND(h%)+1
2580 tis(a,b) = r$(g%)
2590 FOR d = g% TO h%-1
2600 r$(d) = r$(d+1)
2610 NEXT d
2620 h% = h%-1
2630 NEXT a
2640 NEXT b
2650 RETURN
2660 REM****randomise words 2*
2670 FOR a = 0 TO ht%-1
2680 r$(a+1) = sw$(5*a+nous)
2690 NEXT a
2700 RETURN
2710 REM*****word duplicate
2720 FOR a = 1 TO t% : sw$(a) = t$(a) : NEXT a
2730 RETURN
2740 REM**** elaboration of fit****
2750 xi$ = td$(m) : gi$ = cp$(p,n) : IF gi$ = "" THEN d = 0 : RETURN
2760 FOR d = 1 TO LEN(xi$)
2770 IF gi$ = "" THEN d = 20 : GOTO 2800
2780 top = INSTR(gi$, MID$(xi$, d, 1)) : IF top = 0 THEN d = 20 : GOTO 2800
2790 gi$ = RIGHT$(gi$, LEN(gi$) - top)
2800 NEXT d
2810 RETURN
3000 REM****player two tile checker exrended
3010 gr$ = cp$(2,box)
3015 IF gr$ = "" THEN d = 0 : RETURN
3020 FOR d = 1 TO LEN(td$(a))
3030 IF gr$ = "" THEN d = 20: GOTO 3060
3049 tap = INSTR(gr$,MID$(td$(a),d, 1)) : IF tap = 0 THEN d = 20 : GOTO 3060
3050 gr$ = RIGHT$(gr$, LEN(gr$)-tap)
3060 NEXT d
3070 RETURN
3490 REM******inserting your own proverb****
3510 GOTOXY 0,0
3560 INPUT "type proverb (<=12 words) ";pub$: GOTOXY 0,3 : PRINT pub$
3570 GOSUB 5000
3580 GRAPHICS fillect 5,131,485,211,-1
3600 FOR ball = 1 TO k(2) : cp$(2,ball) = p$(ball) : ppb$(2,ball) = "" : NEXT ball
3610 GOSUB 640: GOSUB 770 : COUNT(2) = 0 : grab%(2) = 0
3630 RETURN
4000 REM***** new proverb insertion?****
4002 GOTOXY 0,0 : PRINT "do you want a new proverb, (y/n)"
4010 c$= "" : w$=""
4020 FOR a = 1 TO 150
4030 c$ = INKEY$
4040 IF c$ = "n" OR c$ = "y" THEN a = 150
4042 IF c$ = "y" THEN w$ = "g" : GOSUB 3490
4045 NEXT a
4050 RETURN
5000 REM *****adding proverbs****
5010 p% = p%+ 1 : m$ = pub$: flag = 1 : w = 1 : q$ = " " : n = 1
5020 WHILE flag
5030 m = INSTR(m$, q$)
5040 IF m = 0 THEN p$(n) = m$: flag = 0 : GOTO 5070
5050 p$(n) = LEFT$(m$,m)
5060 m$ = right$(m$,len(m$)-m)
5065 n = n+1
5070 WEND
5075 PRINT "no of words in proverb is";n
5080 OPEN "proverblist" FOR append as #1
5090 PRINT #1,n
5095 FOR b = 1 TO n
5097 PRINT #1, p$(b)
5098 NEXT b
5099 CLOSE #1
5100 pr(p%) = n : k(2) = n
5110 RETURN
6000 REM***** show proverbs
6005 CLS
6010 GOTOXY 0,0
6020 FOR a = 1 TO p%
6030 FOR b = 1 TO pr(p%)
6040 PRINT pr$(a,b);
6050 NEXT b
6060 NEXT a
6070 RETURN