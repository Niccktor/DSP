#include <def21262.h>
#include "ad1835.h"


//===============================================================

.section/dm seg_dmda;
.global _init1835viaSPI;
.var spi_semaphore;
.var config_tx_buf[]=          // Buffer of configuration data
			WR | DACCTRL1 | DACI2S | DAC24BIT | DACFS48,
			WR | DACCTRL2, // e.g.: | DACMUTE_R1 | DACMUTE_L2, 
			WR | DACVOL_L1 | DACVOL_MAX,
			WR | DACVOL_R1 | DACVOL_MAX,
			WR | DACVOL_L2 | DACVOL_MAX,
			WR | DACVOL_R2 | DACVOL_MAX,
			WR | DACVOL_L3 | DACVOL_MAX,
			WR | DACVOL_R3 | DACVOL_MAX,
			WR | DACVOL_L4 | DACVOL_MAX,
			WR | DACVOL_R4 | DACVOL_MAX,
			WR | ADCCTRL1 | ADCFS48,
			WR | ADCCTRL2 | ADCI2S | ADC24BIT,
			WR | ADCCTRL3 | IMCLKx2 | PEAKRDEN; 		

//===============================================================

.section/pm seg_pmco;

_init1835viaSPI:
	
	//--------------------------
	// Clear regs to start
	r0 = 0;
	dm(SPIFLG)=r0;

	
	//---------------------------------------------------------
	// Writing TXFLSH and RXFLSH bits in SPICTL clear the SPI
	// transmit and receive FIFOs, respectively.
	r0 = dm(SPICTL);
	r1 = (TXFLSH | RXFLSH );
	r0 = r0 OR r1;
	dm(SPICTL)=r0;
	
	
	//----------------------------
	// Set the baud rate to 1 MHz
	r0 = 100;
	dm(SPIBAUD) = r0;
	
	
	//--------------------------------------------
	// Set the SPIFLG register to FLAG3 (0xF708)
	r0 = 0xF708;
	dm(SPIFLG) = r0;
	
	
	//------------------------------------------------------
	// Now set the SPI control register 
	r0 = (SPIEN |   // enable the port
		  SPIMS |      // set SHARC as SPI master
		  MSBF |    // send MSB first
		  WL16 |    // word length = 16 bits
		  TIMOD1);  // Initialize SPI port to begin
	                  // transmitting when DMA is enabled 
	dm(SPICTL) = r0;
	
	
	//-------------------------------------------
	// Set up DAG registers to transmit via SPI
	i4 = config_tx_buf;
	m4 = 1;

		
	//------------------------------
	// Set up loop to transmit data 
	lcntr = LENGTH(config_tx_buf), do word_sent until lce;
	
	    // Send a word
	    r0=dm(i4,m4);
	    dm(TXSPI)=r0;
	    
	    // Wait until "SPI transfer complete" status bit 
	    //   in SPISTAT (SPIF) indicates that we can send more
		do checkIfTXisDone until TF;
		
		    ustat3 = dm(SPISTAT);
		    BIT TST ustat3 SPIF;
		    
		checkIfTXisDone:
	    nop;
	    
	    // Wait an extra 100 cycles to meet the timing 
	    //   requirements of the AD1835A
		lcntr = 100, do pauseFor1835 until lce;
		pauseFor1835:
	    nop;
	    
	    	    
	word_sent:
	nop;
	
/*
	//-----------------------------------------
	// Flush SPI buffers after initialization
	//   You may want to do this before sending
	//   other SPI commands to guarantee that
	//   you have not accidentally left data in
	//   the transmit or receive FIFOs.
	r0 = dm(SPICTL);
	r1 = (TXFLSH | RXFLSH );
	r0 = r0 OR r1;
	dm(SPICTL)=r0;
*/
		  
	rts;

	
_init1835viaSPI.end:  












	// should never get here...
	jump (pc,0);
