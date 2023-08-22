#include "prc_inc_smite"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();   
    
    if(GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC) 
        DoSmite(oMeldshaper, oTarget, SMITE_TYPE_CHAOS);
}