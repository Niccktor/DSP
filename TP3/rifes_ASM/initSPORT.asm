//
//  initSport.asm
//

#include <def21262.h>


.global _initSPORT;

.section/pm seg_pmco;

_initSPORT:


	//============================================================
	//
	// Make sure that the multichannel mode registers are cleared
	//
	//============================================================
	
	r0 = 0;
	dm(SPMCTL01) = r0;
	dm(SPMCTL23) = r0;

	//============================================================
	//
	// Configure SPORT 0 for input from ADC
	//
	//    BHD = Buffer hang disable
	//    OPMODE = I2S mode
	//    SLEN24 = 24 bit of data in each 32-bit word
	//    SPEN_A = Enable data channel A
	//
	//------------------------------------------------------------

	
	r0 = BHD | OPMODE | SLEN24 | SPEN_A;   // r0 = 0xE0800971;
	dm(SPCTL0) = r0;  


	//============================================================
	//
	// Configure SPORTs 1 & 2 for output to DACs 1-4
	//
	//    SPTRAN = Transmit on serial port
	//    BHD = Buffer hang disable
	//    OPMODE = I2S mode
	//    SLEN24 = 24 bit of data in each 32-bit word
	//    SPEN_A = Enable data channel A
	//    SPEN_A = Enable data channel B
	//
	//------------------------------------------------------------

	r0 = SPTRAN | BHD | OPMODE | SLEN24 | SPEN_A | SPEN_B;
	dm(SPCTL1) = r0; 
	dm(SPCTL2) = r0;           // r0 = 0x27800971;

	rts;

_initSPORT.end:
