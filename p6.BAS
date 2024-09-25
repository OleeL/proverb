2220 gotoxy 0,6 : input "guess ";pg$
2230 if pg$ = " " then return
2240 iris = 1 : 1% = 1 : 95 = " "
2250 while iris
2260 gu = instrpg$, q$)
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
2410 if calk = k(1) then print "EXCELLENT GUESS
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
2600 r$ (d) = r$(d+1)
2610 next d
2620 h% = h%-1
2630 next a
2640 next b
2650 return
2660 rem****randomise words 2*