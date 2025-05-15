//
// 21262/21266 Interrupt Vector Table
//
.extern _main;

.section/pm seg_rth;



__EMUI:         // 0x00: Emulator interrupt (highest priority, read-only, non-maskable)
        nop;
        nop;
        nop;
        nop;
__RSTI:         // 0x04: Reset (read-only, non-maskable)
        nop;    // <-- (this line is not executed)
        jump _main;
        nop;
        nop;
__IICDI:        // 0x08: Illegal Input Condition Detected
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SOVFI:        // 0x0C: Status loop or mode stack overflow or PC stack full
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__TMZHI:        // 0x10: Core timer interrupt (higher priority option)
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__res0:         // 0x14: (reserved)
        jump (pc,0); jump (pc,0); jump (pc,0); jump (pc,0);

__BKPI:         // 0x18: Hardware breakpoint interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__res1:         // 0x1C: (reserved)
        jump (pc,0); jump (pc,0); jump (pc,0); jump (pc,0);

__IRQ2I:        // 0x20: IRQ2 is asserted
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__IRQ1I:        // 0x24: IRQ1 is asserted
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__IRQ0I:        // 0x28: IRQ0 is asserted
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__DAIHI:        // 0x2C: DAI interrupt (higher priority option)
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SPIHI:        // 0x30: SPI transmit or receive (higher priority option)
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__GPTMR0I:      // 0x34: General Purpose timer 0 interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SP1I:         // 0x38: SPORT 1 interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SP3I:         // 0x3C: SPORT 3 interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SP5I:         // 0x40: SPORT 5 interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SP0I:         // 0x44: SPORT 0 interrupt
		jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SP2I:         // 0x48: SPORT 2 interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SP4I:         // 0x4C: SPORT 4 interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__PPI:          // 0x50: Parallel port interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__GPTMR1I:      // 0x54: General Purpose timer 1 interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__res2:         // 0x58: (reserved)
        jump (pc,0); jump (pc,0); jump (pc,0); jump (pc,0);

__DAILI:        // 0x5C: DAI interrupt (lower priority option)
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__res3:         // 0x60: reserved)
        jump (pc,0); jump (pc,0); jump (pc,0); jump (pc,0);

__res4:         // 0x64: (reserved)
        jump (pc,0); jump (pc,0); jump (pc,0); jump (pc,0);

__res5:         // 0x68: (reserved)
        jump (pc,0); jump (pc,0); jump (pc,0); jump (pc,0);

__res6:         // 0x6C: (reserved)
        jump (pc,0); jump (pc,0); jump (pc,0); jump (pc,0);

__GPTMR2I:      // 0x70: General Purpose timer 2 interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SPILI:        // 0x74: SPI transmit or receive (lower priority option)
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__CB7I:         // 0x78: Circular buffer 7 overflow exception
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__CB15I:        // 0x7C: Circular buffer 15 overflow exception
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__TMZLI:        // 0x80: Core timer interrupt (lower priority option)
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__FIXI:         // 0x84: Fixed-point overflow exception
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__FLTOI:        // 0x88: Floating-point overflow exception
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__FLTUI:        // 0x8C: Floating-point underflow exception
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);


__FLTII:        // 0x90: Floating-point invalid exception
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__EMULI:        // 0x94: Emulator low priority interrupt
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SFT0I:        // 0x98: User software interrupt 0
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SFT1I:        // 0x9C: User software interrupt 1
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SFT2I:        // 0xA0: User software interrupt 2
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

__SFT3I:        // 0xA4: User software interrupt 3 (lowest priority)
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);
        jump (pc,0);

