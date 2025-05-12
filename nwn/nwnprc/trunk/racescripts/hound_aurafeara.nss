//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_AuraFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////


// shaken   -2 attack,weapon dmg,save.
// panicked -2 save + flee away ,50 % drop object holding
#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oPC = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    // –2 penalty on attacks, AC, and saves
    effect eShaken = EffectLinkEffects(EffectShaken(), EffectACDecrease(2));
           eShaken = EffectLinkEffects(eShaken, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);

    int nRHD = GetLevelByClass(CLASS_TYPE_OUTSIDER, oPC);
	
    // DC is charisma based.  +2 Racial Bonus
    int nDC = 12 + (nRHD / 2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nDuration = d6(2);
	
    //if(GetIsEnemy(oTarget, oPC) && GetHitDice(oTarget) <= nHD)
    if(GetIsEnemy(oTarget, oPC))		
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_AURA_FEAR));
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
            //Make a saving throw check
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
