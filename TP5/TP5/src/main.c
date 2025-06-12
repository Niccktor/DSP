///////////////////////////////////////////////////////////////////////////////////////
//NAME:     main.c (Block-based Talkthrough)
//PURPOSE:  Talkthrough framework for sending and receiving samples to the AD1835.
//
//USAGE:    This file contains the main routine calls functions to set up the talkthrough
//          routine.
//
////////////////////////////////////////////////////////////////////////////////////////

#include <SRU.h>
#include <def21262.h>

#define PPORT          0x2020
#define SIG_DAIH 0x25  // Numéro d’interruption haute priorité DAI

volatile int* pDAI_IRPTL_PRI = (int*)DAI_IRPTL_PRI;
volatile int* pDAI_IRPTL_RE  = (int*)DAI_IRPTL_RE;
volatile int* pDAI_IRPTL_H   = (int*)DAI_IRPTL_H;
volatile int* pPPORT         = (int*)PPORT;

extern void InitDAI(void);
extern void Init1835viaSPI(void);
extern void InitSPORT(void);
void IRQP1_isr(int sig_num);


extern int rx_buf[2], tx_buf[2];



// SPORT0 and SPORT1 Interrupt Service Routines      
//--------------------------------------------------------------------------------------------
/* ISR counters, for debug purposes to see how many times SPORT DMA interrupts are serviced */
void ReceptionISR(int sig_int)
{
	tx_buf[0]=rx_buf[0];
	tx_buf[1]=rx_buf[1];
}

void main(void)
{
    // Enable interrupt nesting.
    asm( "#include <def21262.h>" );
    asm( "bit set mode1 IRPTEN;"  ); // Enable interrupts (globally)
    asm( "LIRPTL = SP0IMSK;"  ); 	// Unmask the SPORT0 ISR


    // Need to initialize DAI because the sport signals
    // need to be routed
    InitDAI();
    // This function will configure the codec on the kit
    Init1835viaSPI();

    // Finally setup the sport to receive / transmit the data
    InitSPORT();
    
    

	*pDAI_IRPTL_PRI = SRU_EXTMISCB1_INT; // Priorité
	*pDAI_IRPTL_RE  = SRU_EXTMISCB1_INT; // Interruption sur front montant

	// Routage DAI_P1 ? MISCB1
	SRU(LOW, DAI_PB01_I);       // Bonnes pratiques
	SRU(DAI_PB01_O, MISCB1_I);  // Connexion physique
	SRU(LOW, PBEN01_I);         // Entrée
	interrupt(SIG_DAIH, IRQP1_isr);

     // Be in infinite loop and do nothing until done.
    for(;;)
    {
    }    
}

// Fonction de traitement de l'interruption IRQP1
void IRQP1_isr(int sig_num)
{
    static int count = 0;
    int IT_register = *pDAI_IRPTL_H;

    if ((IT_register & SRU_EXTMISCB1_INT) != 0)
    {
        *pDAI_IRPTL_H = SRU_EXTMISCB1_INT;  // Clear pending interrupt
        *pPPORT = count++;                  // Affichage LED (port parallèle)
    }
}
