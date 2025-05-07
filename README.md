# TP ASM filtre RIF

Erreur dans les sources:

Fichier riftest.asm
    
    .SEGMENT /PM segt_pmda;          /* les données accessibles par le bus PM */
    .SEGMENT /PM seg_pmda;          /* les données accessibles par le bus PM */

    .SEGMENT /DM segt_dmda; 	/* les données accessibles par le bus DM */
    .SEGMENT /DM seg_dmda; 	/* les données accessibles par le bus DM */
Fichier rif.asm

    .SEGMENT /PM segt_pmco;
    .SEGMENT /PM seg_pmco;
Pour désactier les buffer circulaire, il suffit de modifier une ligne de code:

    BIT SET MODE1 CBUFEN; /* Active les buffers circulaires */
    BIT CLR MODE1 CBUFEN; /* Désactive les buffers circulaires */
