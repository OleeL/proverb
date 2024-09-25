430 data "jack", "il", "bo", "un"," con", "do", " ex", "if", "lo", " so"
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
790 moveto 45+(a-1)*480/k(2),156 : graphics drawtext str$ (a)
800 moveto 5+(a-1)*480/k(2),142 : graphics drawtext cp$ (2,a)
810 next a
820 return
830 rem** tile match
840 q(p) = 0
850 for m = 1 to 3
860 if td$(m) = "" then goto 950
870 for n = 1 to k(p)
880 if ppb$(p,n) = "f" then goto 940
890 if len(td$(m)) = 1 then 920