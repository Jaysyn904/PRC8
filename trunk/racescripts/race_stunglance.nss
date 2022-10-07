//::///////////////////////////////////////////////
//:: Stunning Glance
//:: race_stunglance
//:://////////////////////////////////////////////
//:: Fort save or the target is stunned for 2d4 round
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 21, 2008
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oNymph = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();        //not using prc version here

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        if(GetDistanceBetween(oNymph, oTarget) > FeetToMeters(30.0))
            return;

        effect eVis = EffectVisualEffect(VFX_IMP_STUN);
        effect eLink = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

        int nDuration = d4(2);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oNymph, SPELL_NYMPH_STUNNING_GLANCE));

        // DC is charisma based
        int nDC = 10 + (GetHitDice(oNymph) / 2) + GetAbilityModifier(ABILITY_CHARISMA, oNymph);

        //Make Fort Save to negate effect
        if (!/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
            //Apply VFX Impact and stun effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}