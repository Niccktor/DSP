/**************************************************************************
	PROGRAMME DE TEST DU FILTRE A REPONSE IMPULSIONNELLE FINIE
	Fourni par Analog Devices
**************************************************************************/

/**************************************************************************
File Name : RIFTEST.ASM
Version  ADSP-21262

Purpose This program is a shell program for the RIF.ASM code. This program 
initializes buffers and pointers. It also calls the RIF.ASM code.
**************************************************************************/

#include "def21262.h"
#define SAMPLES 0x9 	/*nombre d'�chantillons � filtrer*/
#define TAPS 5 	/* nombre de coefficients*/

.EXTERN rif; /* �tiquette d�finie dans un autre fichier */ 
/*************************************************************************/
.SEGMENT /PM seg_pmda;          /* les donn�es accessibles par le bus PM */
	.VAR coefs[TAPS] = "rifcoeffs.dat";    /* coefficients du RIF stock�s initialement dans un fichier texte */
.ENDSEG;
/*************************************************************************/
.SEGMENT /DM seg_dmda; 	/* les donn�es accessibles par le bus DM */

	/* buffer qui contient les 5 derniers �chantillons d'entr�e n�cessaires au calcul de la r�ponse du filtre */
	.VAR dline[TAPS];        

	/* buffer entr�e simulant un �chelon initialis� � 1 */
	.VAR inbuf[SAMPLES]=1., 1., 1., 1., 1., 1., 1., 1., 1.; 

	/* buffer de sortie initialis� � -99 */
	.VAR outbuf[SAMPLES]=-99.,-99., -99.,-99.,-99.,-99.,-99.,-99.,-99.; 
.ENDSEG;


/*************************************************************************/
/* Ex�cut� au RESET */
.SEGMENT /PM seg_rth;
     initial_setup: 	/* d�but zone vecteur IT : RESET */
		nop; nop; nop; nop;
		NOP;		/* introduit un waitstate  */	               	
		BIT SET MODE1 CBUFEN; /* Active les buffers circulaires */
		JUMP begin; 	/* 1st instr. ex�cut�e apr�s reset */
.ENDSEG;
/*************************************************************************/
.SEGMENT /PM seg_pmco;

   begin: 
	l0=TAPS; 	           /*initialisation pointeur sur buffer dline*/
	b0=dline;
	m0=1;

	l1=0; 		        /*initialisation pointeur sur buffer d'entr�e*/
	b1=inbuf;

	l2=0; 		       /*initialisation pointeur sur buffer de sortie*/
	b2=outbuf;

	l8=TAPS;		 /*initialisation pointeur sur buffer des coefficients*/
	b8=coefs;

	call rif_init (db);               /*initialise le buffer dline � z�ro */
	m8=1;
	r0=TAPS;

	lcntr=SAMPLES, do filtering until lce;                /* le filtrage */
		call rif (db); 	/*�chantillon d'entr�e dans F0, sortie renvoy�e dans F0*/
		r1=TAPS;
		f0=dm(i1,1);
	filtering: dm(i2,1)=f0;             /*stockage du r�sultat dans outbuf*/

	done: jump done;                                 /* programme termin� */

	rif_init:          /* sous programme d'initialisation de dline � z�ro */
	    lcntr=r0, do zero until lce;
		   zero: dm(i0,m0)=0; 	            /*initialise la ligne � retard � 0*/
	rts;
.ENDSEG;
