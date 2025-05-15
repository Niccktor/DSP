/////////////////////////////////////////////////////////////
//                                                         //
//     SPORT1 and SPORT3 Interrupt Service Routines        //
//                                                         //
/////////////////////////////////////////////////////////////

#include <def21262.h>

.section /pm seg_pmco;

_talkThroughISR:
	r10=dm(RXSP0A);		// read new left sample from ADC
	
	dm(TXSP2A)=r10;			// write to DAC3
	dm(TXSP2B)=r10;			// write to DAC4
	
	rti;

_talkThroughISR.end:
//--------------------------------------------

