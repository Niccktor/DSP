/**********************************************/
/*      Programme IRQ1 pour SHARC  EZKIT LITE */
/*											  */
/**********************************************/

/* ADSP-21262 System Register bit definitions */

#include <cdef21262.h>
#include <def21262.h>
#include <21262.h>
#include <signal.h>
#include <macros.h>

/**********************************/
/*	IRQ1 - Interrupt runtime	  */
/**********************************/
void my_irq1( int sig_num )
{
    sig_num=sig_num;

    // A remplir pour commander les LEDs

    return;
}

/******************************************************/
/*	Programme Principal                               */
/******************************************************/
void main ( void )
{
    // Enable interrupt nesting.
    asm( "#include <def21262.h>" );
    asm( "bit set mode1 NESTM;"  );

    // Si IRQ1 ==> my_irq1 est exécutée
    interrupt( SIG_IRQ1, my_irq1);
	
	// Valider l'IT IRQ1 et initialiser les LEDs
    .................................................................	
    
    for(;;) // boucle infini.
    {
    	idle(); // attente d'interruption
    };
}
/**********************************************************/
void AfficheLEDs(int led_value){
//lights as described at the top of the file
    *pPPCTL=0;

    *pIIPP=(int) &led_value;
    *pIMPP=1;
    *pICPP=1;
    *pEMPP=1;
    *pECPP=1;
    *pEIPP=0x1400000;

    *pPPCTL=PPTRAN|PPBHC|PPDUR20|PPDEN|PPEN;
}