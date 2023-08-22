#include "prc_inc_smite"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();   
    
    if(GetOpposition(oMeldshaper, oTarget)) 
        DoSmite(oMeldshaper, oTarget, SMITE_TYPE_SOULBORN);
}