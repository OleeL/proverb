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
1030 grab%(p) = grab%(p)+vol%: count(p) = count(p)+1 : ppb$(p, cpos(p)) = "fi
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