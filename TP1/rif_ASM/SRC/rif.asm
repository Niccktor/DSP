/**************************************************************************
FILTRE A REPONSE IMPULSIONNELLE FINIE (Fourni par Analog Devices)

File Name : RIF.ASM
Version  ADSP-21262

This is a subroutine that implements RIF filter code given coefficents and samples.
**************************************************************************
Equation Implemented
y(n)=Summation from k= 0 to M of H sub k times x(n-k)

Calling Parameters
f0 = input sample x(n)
r1 = number of taps in the filter minus 1
b0 = address of the delay line buffer
m0 = modify value for the delay line buffer
l0 = length of the delay line buffer
b8 = address of the coefficent buffer
m8 = modify value for the coefficent buffer
l8 = length of the coefficent buffer

Return Values
f0 = output sample y(n)

Registers Affected
f0, f4, f8, f12, i0, i8

Cycle Count
6 + (Number of taps -1) + 2 cache misses

# PM Locations
7 instruction words
Number of taps locations for coefficents

# DM Locations
Number of taps of samples in the delay line
**************************************************************************/
 
/************************************************************************
f12 : r�sultat multiplication
f8 : accumulation r�sultat
f0 : �chantillons entrant (xn) et pr�c�dents en cours de calcul
     puis r�sultat du calcul
f4 : coefficients
r1 : nombre de coefficients moins 1
************************************************************************/

.GLOBAL rif;
.EXTERN coefs, dline;
.SEGMENT /PM seg_pmco;

  rif: 
	r12=r12 xor r12;
	dm(i0,m0)=f0;		/* r12 =0 et stockage �chantillon entrant dans dline*/
	r8=r8 xor r8;
	lcntr=r1, do macs until lce;	/* boucle it�rant nb_coeff fois*/
	f0=dm(i0,m0);  /* r8=0 et chargement donn�e et coeff  issus de dline et coef*/
	f4=pm(i8,m8);
	f12=f0*f4;                                           
 	macs: f8=f8+f12;     /*multiplie, accumule et charge donn�e et coeff. it�ration suivante*/
	f0=f8;     /*stockage r�sultat dans f0*/                                                                                                                 
	rts;
  rif.END: 
    
.ENDSEG;
