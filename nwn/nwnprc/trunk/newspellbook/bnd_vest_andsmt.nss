#include "prc_inc_smite"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ANDRAS)) return;
    object oTarget = PRCGetSpellTargetObject();   
    
    if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD || GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) 
        DoSmite(oBinder, oTarget, SMITE_TYPE_ANDRAS);
}