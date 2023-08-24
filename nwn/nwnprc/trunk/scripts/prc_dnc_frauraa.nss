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
    object oTarget = GetEnteringObject();

    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur3 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

    int nDC = 10 + (GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, GetAreaOfEffectCreator())/2) + GetAbilityModifier(ABILITY_CHARISMA,GetAreaOfEffectCreator());
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()) && GetHitDice(oTarget)<=GetHitDice(GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR))
        {
              //Apply the VFX impact and effects
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, RoundsToSeconds(GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, GetAreaOfEffectCreator())));
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
