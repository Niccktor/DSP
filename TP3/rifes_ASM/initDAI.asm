
#include <def21262.h>
// The following definition allows the SRU macro to check for errors. Once the routings have
// been verified, this definition can be removed to save some program memory space.
// The preprocessor will issue a warning stating this when using the SRU macro without this
// definition
#define SRUDEBUG  // Check SRU Routings for errors.
#include <SRU.h>


.section /pm seg_pmco;
.global _initDAI;


/*-----------------------------------------------------------------------------

                  *** EZ-KIT ANALOG-IN ROUTING OVERVIEW ***

   XTAL
   OSC  >---+             ..............................................
   12.288   |             :SHARC
            |
   ADC      |      DAI_P06:  o-DAI_PB06_O------ (MCLK routed to the ADC via SRU)
   MCLK <---+------------>#--o-
   IN                     :  o PBEN06_I=LOW
                          :
   ADC             DAI_P17:  o-DAI_PB17_O------ (MCLK routed to the DACs via SRU)
   MCLK >---------------->#--o-
   IN                     :  o PBEN17_I=LOW
                          :
   ADC             DAI_P07:  o-DAI_PB07_O--------*---------->o-SPORT0_CLK_I
   BCLK >---------------->#--o-                  |  +------->o-SPORT0_FS_I
   OUT                    :  o-PBEN07_I=LOW      |  |     +->o-SPORT0_DA_I
                          :                      |  |     |
   ADC             DAI_P04:  o-DAI_PB04_O-----------*     |
   FS   >---------------->#--o-                  |  |     |
   OUT                    :  o-PBEN04_I=LOW      |  |     |
                          :                      |  |     |
   ADC             DAI_P05:  o-DAI_PB04_O-----------------+
   DATA >---------------->#--o-                  |  |
   OUT                    :  o PBEN05_I=LOW      |  |
                          :                      |  |
   DAC1            DAI_P13:  o-                  |  |
   BCLK <----------------<#--o-DAI_PB12_I<-------*--------+
   IN                     :  o-PBEN13_I=HIGH     |  |     |
                          :                      |  |     |
   DAC1            DAI_P14:  o-                  |  |     +->o-SPORT1_CLK_I
   FS   <----------------<#--o-DAI_PB14_I<----------*------->o-SPORT1_FS_I
   IN                     :  o PBEN14_I=HIGH     |  |  +-----o-SPORT1_DA_O
                          :                      |  |  |  +--o-SPORT1_DB_O
   DAC1            DAI_P12:  o                   |  |  |  |
   DATA <----------------<#--o-DAI_PB12_I<-------------+  |
   IN                     :  o PBEN12_I=HIGH     |  |     |
                          :                      |  |     |
   DAC2            DAI_P11:  o-                  |  |     |
   DATA <----------------<#--o-DAI_PB11_I<----------------+
   IN                     :  o PBEN11_I=HIGH     |  |
                          :                      +---------->o-SPORT2_CLK_I
   DAC3            DAI_P10:  o-                     +------->o-SPORT2_FS_I
   DATA <----------------<#--o-DAI_PB10_I<-------------------o-SPORT2_DA_O
   IN                     :  o PBEN10_I=HIGH              +--o-SPORT2_DB_O
                          :                               |
   DAC4            DAI_P09:  o-                           |
   DATA <----------------<#--o-DAI_PB09_I<----------------+
   IN                     :  o PBEN09_I=HIGH
                          :
                          ..............................................

-----------------------------------------------------------------------------*/



_initDAI:

    // Disable the pull-up resistors on all 20 pins
    r0 = 0x000FFFFF;
    dm(DAI_PIN_PULLUP) = r0;



//-----------------------------------------------------------------------------
//
//  MCLK: The output of the 12.288 MHz xtal is either directly connected to the
//          codec, but also connected to DAI_P06, or just to DAI_P17. This is
//             determined by switches 7.1 and 7.2 For this example we route the
//             MCLK into DAI_P17 and supply the clock to the ADC via DAI_P06
//             by routing the signal through the SRU.

//  Tie the pin buffer input LOW.
    SRU(LOW,DAI_PB17_I);

//  Tie the pin buffer enable input LOW
    SRU(LOW,PBEN17_I);



//-----------------------------------------------------------------------------
//
//  Connect the ADC: The codec drives a BCLK output to DAI pin 7, a LRCLK
//          (a.k.a. frame sync) to DAI pin 8 and data to DAI pin 5.
//
//          Connect the ADC to SPORT0, using data input A
//
//          All three lines are always inputs to the SHARC so tie the pin
//          buffer inputs and pin buffer enable inputs all low.


//------------------------------------------------------------------------
//  Connect the ADC to SPORT0, using data input A

    //  Clock in on pin 7
    SRU(DAI_PB07_O,SPORT0_CLK_I);

    //  Frame sync in on pin 8
    SRU(DAI_PB08_O,SPORT0_FS_I);

    //  Data in on pin 5
    SRU(DAI_PB05_O,SPORT0_DA_I);

//------------------------------------------------------------------------
//  Tie the pin buffer inputs LOW for DAI pins 5, 6 7 and 8.  Even though
//    these pins are inputs to the SHARC, tying unused pin buffer inputs
//    LOW is "good coding style" to eliminate the possibility of
//    termination artifacts internal to the IC.  Note that signal
//    integrity is degraded only with a few specific SRU combinations.
//    In practice, this occurs VERY rarely, and these connections are
//    typically unnecessary.


    SRU(LOW,DAI_PB05_I);
    SRU(LOW,DAI_PB07_I);
    SRU(LOW,DAI_PB08_I);

//------------------------------------------------------------------------
//  Tie the pin buffer enable inputs LOW for DAI pins 5, 6, 7 and 8 so
//    that they are always input pins.

    SRU(LOW,PBEN05_I);
    SRU(LOW,PBEN07_I);
    SRU(LOW,PBEN08_I);

//-----------------------------------------------------------------------------
//
//  Connect the DACs: The codec accepts a BCLK input from DAI pin 13 and
//          a LRCLK (a.k.a. frame sync) from DAI pin 14 and has four
//          serial data outputs to DAI pins 12, 11, 10 and 9
//
//          Connect DAC1 to SPORT1, using data output A
//          Connect DAC2 to SPORT1, using data output B
//          Connect DAC3 to SPORT2, using data output A
//          Connect DAC4 to SPORT2, using data output B
//
//          Connect the clock and frame sync inputs to SPORT1 and SPORT2
//          should come from the ADC on DAI pins 7 and 8, respectively
//
//          Connect the ADC BCLK and LRCLK back out to the DAC on DAI
//          pins 13 and 14, respectively.
//
//          All six DAC connections are always outputs from the SHARC
//          so tie the pin buffer enable inputs all high.
//

//------------------------------------------------------------------------
//  Connect the pin buffers to the SPORT data lines and ADC BCLK & LRCLK

    SRU(SPORT2_DB_O,DAI_PB09_I);
    SRU(SPORT2_DA_O,DAI_PB10_I);
    SRU(SPORT1_DB_O,DAI_PB11_I);
    SRU(SPORT1_DA_O,DAI_PB12_I);

//------------------------------------------------------------------------
//  Connect the clock and frame sync input from the ADC directly
//    to the output pins driving the DACs.

    SRU(DAI_PB07_O,DAI_PB13_I);
    SRU(DAI_PB08_O,DAI_PB14_I);
    SRU(DAI_PB17_O,DAI_PB06_I);

//------------------------------------------------------------------------
//  Connect the SPORT clocks and frame syncs to the clock and
//    frame sync from the SPDIF receiver

    SRU(DAI_PB07_O,SPORT1_CLK_I);
    SRU(DAI_PB07_O,SPORT2_CLK_I);
    SRU(DAI_PB08_O,SPORT1_FS_I);
    SRU(DAI_PB08_O,SPORT2_FS_I);

//------------------------------------------------------------------------
//  Tie the pin buffer enable inputs HIGH to make DAI pins 9-14 outputs.
    SRU(HIGH,PBEN06_I);
    SRU(HIGH,PBEN09_I);
    SRU(HIGH,PBEN10_I);
    SRU(HIGH,PBEN11_I);
    SRU(HIGH,PBEN12_I);
    SRU(HIGH,PBEN13_I);
    SRU(HIGH,PBEN14_I);

    rts;

_initDAI.end:





