
///////////////////////////////////////////////////////////////////////////////////////
//NAME:     main.c (Block-based Talkthrough)
//PURPOSE:  Talkthrough framework for sending and receiving samples to the AD1835.
//
//USAGE:    This file contains the main routine calls functions to set up the talkthrough
//          routine.
//
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
#include <cdef21262.h>
#include <def21262.h>


extern void InitDAI(void);
extern void Init1835viaSPI(void);
extern void InitSPORT(void);

int rx_buf[2], tx_buf[2];

// SPORT0 and SPORT1 Interrupt Service Routines      
//--------------------------------------------------------------------------------------------
/* ISR counters, for debug purposes to see how many times SPORT DMA interrupts are serviced */
void ReceptionISR(int sig_int)
{
	tx_buf[0] = rx_buf[0]; 
	tx_buf[1] = rx_buf[1]; 
}

void main(void)
{
    // Enable interrupt nesting.
    asm( "#include <def21262.h>" );
    asm( "bit set mode1 IRPTEN;"  ); // Enable interrupts (globally)
    asm( "LIRPTL = SP0IMSK;"  ); 	// Unmask the SPORT0 ISR


    // Need to initialize DAI because the sport signals need to be routed
    InitDAI();
    // This function will configure the codec on the kit
    Init1835viaSPI();

    // Finally setup the sport to receive / transmit the data
    InitSPORT();
    
    
     // Be in infinite loop and do nothing until done.
    for(;;)
    {
    }    
}
