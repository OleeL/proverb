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
3030 if gr$ = " then d = 20: goto 3060
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
4002 gotoxy 0,0 : print "do you want a new proverb, (y/n)
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