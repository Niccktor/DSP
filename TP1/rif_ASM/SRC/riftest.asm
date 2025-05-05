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
#define SAMPLES 0x9 	/*nombre d'échantillons à filtrer*/
#define TAPS 5 	/* nombre de coefficients*/

.EXTERN rif; /* étiquette définie dans un autre fichier */ 
/*************************************************************************/
.SEGMENT /PM seg_pmda;          /* les données accessibles par le bus PM */
	.VAR coefs[TAPS] = "rifcoeffs.dat";    /* coefficients du RIF stockés initialement dans un fichier texte */
.ENDSEG;
/*************************************************************************/
.SEGMENT /DM seg_dmda; 	/* les données accessibles par le bus DM */

	/* buffer qui contient les 5 derniers échantillons d'entrée nécessaires au calcul de la réponse du filtre */
	.VAR dline[TAPS];        

	/* buffer entrée simulant un échelon initialisé à 1 */
	.VAR inbuf[SAMPLES]=1., 1., 1., 1., 1., 1., 1., 1., 1.; 

	/* buffer de sortie initialisé à -99 */
	.VAR outbuf[SAMPLES]=-99.,-99., -99.,-99.,-99.,-99.,-99.,-99.,-99.; 
.ENDSEG;


/*************************************************************************/
/* Exécuté au RESET */
.SEGMENT /PM seg_rth;
     initial_setup: 	/* début zone vecteur IT : RESET */
		nop; nop; nop; nop;
		NOP;		/* introduit un waitstate  */	               	
		BIT SET MODE1 CBUFEN; /* Active les buffers circulaires */
		JUMP begin; 	/* 1st instr. exécutée après reset */
.ENDSEG;
/*************************************************************************/
.SEGMENT /PM seg_pmco;

   begin: 
	l0=TAPS; 	           /*initialisation pointeur sur buffer dline*/
	b0=dline;
	m0=1;

	l1=0; 		        /*initialisation pointeur sur buffer d'entrée*/
	b1=inbuf;

	l2=0; 		       /*initialisation pointeur sur buffer de sortie*/
	b2=outbuf;

	l8=TAPS;		 /*initialisation pointeur sur buffer des coefficients*/
	b8=coefs;

	call rif_init (db);               /*initialise le buffer dline à zéro */
	m8=1;
	r0=TAPS;

	lcntr=SAMPLES, do filtering until lce;                /* le filtrage */
		call rif (db); 	/*échantillon d'entrée dans F0, sortie renvoyée dans F0*/
		r1=TAPS;
		f0=dm(i1,1);
	filtering: dm(i2,1)=f0;             /*stockage du résultat dans outbuf*/

	done: jump done;                                 /* programme terminé */

	rif_init:          /* sous programme d'initialisation de dline à zéro */
	    lcntr=r0, do zero until lce;
		   zero: dm(i0,m0)=0; 	            /*initialise la ligne à retard à 0*/
	rts;
.ENDSEG;
