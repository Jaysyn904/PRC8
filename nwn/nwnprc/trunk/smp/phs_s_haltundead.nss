/*:://////////////////////////////////////////////
//:: Spell Name Halt Undead
//:: Spell FileName phs_s_haltundead
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range. Nearest 3 undead creatures up to 5M from target location.
    Will negates, SR applies. 1 round/level duration.
    This spell renders as many as three undead creatures paralyzed. The effect
    is broken if the halted creatures are attacked or take damage.
    Non-intelligent undead get no save.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Only works on undead.

    The nearest 3 undead to the target location at hit.

    - Non-intelligent are 3 intelligence creatures.

    NOTE:

    Requires AI edit, so that OnDAmaged, onAttacked, OnSpellCAstAt picks up
    that we have been attacked, and therefore remove this spells effects.

    - NO Pc's are affected by this.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HALT_UNDEAD)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCountUndead = 0;
    // Can only affect up to 3 undead
    int nMaxUndead = 3;

    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_COM_HIT_DIVINE);
    effect ePara = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effect
    effect eLink = EffectLinkEffects(ePara, eDur);
    eLink = EffectLinkEffects(eDur2, eLink);
    eLink = EffectLinkEffects(eCessate, eLink);

    // Get nearest targets to the location cast at
    int iCnt = 1;
    oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, iCnt);
    // Loop targets
    while(GetIsObjectValid(oTarget) && nCountUndead < nMaxUndead &&
          GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= RADIUS_SIZE_LARGE)
    {
        // Check if they are undead and in our LOS
        if(!GetIsPC(oTarget) && LineOfSightObject(oCaster, oTarget) &&
            GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            // add one to undead attempted to be held
            nCountUndead++;
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HALT_UNDEAD);

            // Spell resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Will save only if they are > 3 Intelligence
                if(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) <= 3)
                {
                    // Apply effects
                    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
                else if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                {
                    // Applly effects
                    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
            }
        }
        iCnt++;
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, iCnt);
    }
}
