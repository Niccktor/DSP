//-----------------------------------------
//   main.asm
//-----------------------------------------
//
//   21262 EZ-KIT Test
//
//-----------------------------------------

#include <def21262.h>

.section /pm seg_pmco;
.extern _initDAI;
.extern _initSPORT;
.extern _init1835viaSPI;

//====================================================================================
_main:

    call _initDAI;

    call _init1835viaSPI;
    
    call _initSPORT;


	//----------------------------------------------
	// Enable interrupts (globally)
	BIT SET MODE1 IRPTEN;

	//----------------------------------------------
	// Unmask the SPORT0 ISR
	LIRPTL = SP0IMSK;
	
	//----------------------------------------------
	// Loop forever.  Work is driven by interrupts
	jump (pc,0);

_main.end:

.global _main;

