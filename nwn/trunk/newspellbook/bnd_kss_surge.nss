/*
07/03/21 by Barmlot

bnd_kss_surge.nss
Knight of the Sacred Vestige's Surge
Vestige's Surge (Reset cooldown on patron vestige's abilities or KSS class features, 5 round cooldown)
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
	
	if(GetIsPatronVestigeBound(oBinder))
		SetLocalInt(oBinder, "KotSSSurge", TRUE);		
}