

icnt = LENGTH, do loopend until lce;
    f0 = dm(i0, m1);
    f1 = pm(i8, m9);
    f3 = f0 * f1;
    f4 = dm(i1, m1);
    f3 = f3 + f4;
loopend: dm(i2, m1) = f3;






f0 = dm(i0, m1); f1 = pm(i8, m9)
f3 = f0 * f1;
f2 = dm(i1, m1)
icnt = LENGTH - 1, do loopend until lce;
    f3 = f3 + f2; f0 = dm(i0, m1); f1 = pm(i8, m9);      
    f3 = f0 * f1, f2 = dm(i1, m1); pm(i2, m1) = f3       
loopend:   
f3 = f3 + f2;


y(n) = c0*x(n) + c1*x(n - 1) + c2*x(n - 2) + c3*x(n - 3) + c4*x(n - 4)

f1 = 0;
icnt = 5, do loopend until lce;
    f3 = dm(i0, m0); // x(n)
    f4 = pm(i8, m8); // c0
    f0 = f3 * f4
    f1 = f1 + f0
loopend:
pm(i2, m0) = f1;


rif:
    r12 = r12 xor r12;
    dm(i0, m0) = r0;
    r8 = r8 xor r8;
    lcntr = r1, do macs until lce;
        f0 = dm(i0, m0);
        f4 = pm(i8, m8);
        f12 = f0 * f4;
    macs: f8 = f8 + f12;
f0 = f8;
rts;


rif:
    r12 = r12 xor r12, dm(i0, m0) = r0;
    r8 = r8 xor r8, f0 = dm(i0, m0), f4 = pm(i8, m8);
    lcntr = r1, do macs until lce;
        f12 = f0 * f4, f8 = f8 + f12, f0 = dm(i0, m0), f4 = pm(i8, m8);        
    macs:
    f8 = f8 + f12
    f0 = f8;
rts;





f2 = dm(i1, m1)
f0 = dm(i0, m1); f1 = pm(i8, m9);
f3 = f0 * f1 + f2;
icnt = LENGTH - 1 , do loopend until lce;
    f0 = dm(i0, m1); f1 = pm(i8, m9);      
loopend: f3 = f0 * f1 + f2, pm(i2, m1) = f3 f2 = dm(i1, m1);;   


; Prélecture - setup de la première itération
f0 = dm(i0, m1), f1 = pm(i8, m9);
icnt = LENGTH - 1, do loop until lce;
    f3 = f0 * f1; f0 = dm(i0, m1); f1 = pm(i8, m9);

    f4 = dm(i1, m1);       ; Cycle 3 : lecture complément
    f3 = f3 + f4;          ; Cycle 4 : addition

    dm(i2, m1) = f3;       ; Cycle 5 : écriture résultat

loop:

; Dernière itération (LENGTH-1ème) à finir
f3 = f0 * f1;
f4 = dm(i1, m1);
f3 = f3 + f4;
dm(i2, m1) = f3;

