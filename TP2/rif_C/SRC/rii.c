
#include <stdio.h>
#include <stdlib.h>

/* Prototype de la fonction rii.c */
/**********************************/
extern void rii(float b, float a, float in[], int N, float out[]);

float inbuf[] = 
{
	#include "high.dat"
};



float outbuf[sizeof(inbuf)]; /* sizeof: Calcule le nombre d'échantillons */
unsigned SAMPLES = sizeof(inbuf); 

float inbuf2[] = 
{
	#include "carre_100b.dat"
};

float outbuf2[sizeof(inbuf2)]; /* sizeof: Calcule le nombre d'échantillons */
unsigned SAMPLES2 = sizeof(inbuf2); 


float inbuf3[] = 
{
	#include "carre_100b.dat"
};

float outbuf3[sizeof(inbuf3)]; /* sizeof: Calcule le nombre d'échantillons */
unsigned SAMPLES3 = sizeof(inbuf3); 

float buf[] = {
	#include "high.dat"
};
void main()
{
	float coeff_x = 0.125; /* coeff de xn */
	float coeff_s = 0.875; /* coeff de sn-1 */
	int i;
	
	rii(coeff_x, coeff_s, &inbuf[0], SAMPLES, &outbuf[0]);
	
	rii(coeff_x, coeff_s, &inbuf2[0], SAMPLES2, &outbuf2[0]);


    int SAMPLES4 = sizeof(buf)/sizeof(buf[0]);
	filtre_rii(coeff_x, coeff_s, buf, SAMPLES4);


	exit(0);
}

/************************************************
Filtre recursif d'ordre 1 (sn = b*xn + a*sn-1)
Arguments : rii (b,a,in,N,out)
========	
	a,b : coeffs du filtre
	in : tableau des echantillons
	N : Nbre d'echantillons
	out : tableau des echantillons filtres
************************************************/
void rii(float b, float a, float in[], int N, float out[])
{
	int i;
	float sn_1=0.;

	for (i=0; i<N; i++)
		out[i] = sn_1 = b*in[i] + a*sn_1;
}

void filtre_rii(float b, float a, float buf[], int N)
{
    int i;
    float s = 0.0f;

    for (i = 0; i < N; i++) {
        s       = b*buf[i] + a*s;
        buf[i]  = s;
    }

  
    s = 0.0f;
    for (i = N - 1; i >= 0; i--) {
        s       = b*buf[i] + a*s;
        buf[i]  = s;
    }
}