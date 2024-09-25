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