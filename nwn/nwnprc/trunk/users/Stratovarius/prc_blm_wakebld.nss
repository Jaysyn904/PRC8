#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nDamage = d10(10);
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);


    int nTouchAttack = PRCDoMeleeTouchAttack(oTarget);;
    if (nTouchAttack > 0)
    {
	// This ability does not work on critical immunes.
        if(!GetIsReactionTypeFriendly(oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
        {
               	//Fire cast spell at event for the specified target
        	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        	//Apply the VFX impact and effects
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
    }

}
