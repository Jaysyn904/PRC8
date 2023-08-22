#include "prc_inc_sp_tch"

void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nDamage = d6(16);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
    effect eRay;


    int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
    if (nTouchAttack > 0)
    {

        if(!GetIsReactionTypeFriendly(oTarget))
        {
        
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY));
        eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);
        //Apply the VFX impact and effects
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    
            }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);

    }

}
