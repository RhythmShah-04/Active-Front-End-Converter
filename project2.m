Pdc = 10e3;
Vll = 400;
f=50;
w=2*pi*f;
Vbat = 900;
m=0.848;
Vdcref =400*sqrt(2)*2/(m*sqrt(3));
Rbat = (Vdcref/Pdc)*(Vbat-Vdcref);
Ka = Vdcref/2;
Vq = 1.5*sqrt(2)*Vll/sqrt(3);
L1 = 5e-2;
R1 = 0.001;
C1 = 1e-3;
P1 = 10e3;
fsw1 = 7e3;
tauf1 =1/2/3.14/100;

%%%%Current controller
fbwi = fsw1/10;
kpi1 = 2*3.14*fbwi*L1/Ka;
kii1 = 2*3.14*fbwi*R1/Ka;
taui1 = R1/Ka/kii1;

%%%%Voltage Controller
k1 = Vq/Vdcref;
taul1 = tauf1 + taui1;
PM1 = pi*53/180;
a1 = tan(PM1) + sqrt((tan(PM1))^2 + 1);
kpw1 = 2*C1/k1/a1/taul1;
kiw1 = kpw1/a1^2/taul1;
