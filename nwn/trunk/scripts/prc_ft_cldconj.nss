#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConceal2 = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
    //Set VFX
    effect eVis = EffectVisualEffect(VFX_IMP_POISON_L);    
    // Link
    effect eLink = EffectLinkEffects(EffectSickened(), eConceal2);
    eLink = EffectLinkEffects(eLink, eConceal);

    if (GetIsFriend(oTarget, GetAreaOfEffectCreator())) 
    {
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
    	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
