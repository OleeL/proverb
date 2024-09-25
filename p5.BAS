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