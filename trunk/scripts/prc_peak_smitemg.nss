#include "prc_inc_smite"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();   
    
    if(GetLevelByTypeArcane(oTarget)) 
        DoSmite(oPC, oTarget, SMITE_TYPE_CULTIST);
}