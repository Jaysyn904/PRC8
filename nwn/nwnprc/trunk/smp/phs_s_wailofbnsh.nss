/*:://////////////////////////////////////////////
//:: Spell Name Wail of the Banshee
//:: Spell FileName PHS_S_WailofBnsh
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    13.33M radius! 8M range, Death, sonic and fortitude negates - death save.
    1 creature/level. Spell resistance = yes.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Massive AOE!

    Anyway, this does death to all allies or enemies, who are not dead,
    who can hear us (not the other way around) so do not have to be in LOS.

    Visual on self, however!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WAIL_OF_THE_BANSHEE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();// Should be OBJECT_SELF's location
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    float fDelay, fDistance;
    int nCnt, nTargetsAffected;

    // Declare effects
    effect eDeath = EffectDeath();
    effect eDeathVis = EffectVisualEffect(VFX_IMP_DEATH);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get nearest to location, up to nCasterLevel of targets, and loop
    nCnt = 1;
    oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    while(GetIsObjectValid(oTarget) && nTargetsAffected < nCasterLevel)
    {
        // Check distance
        fDistance = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget));
        if(fDistance <= 13.33)
        {
            fDelay = fDistance/30;
            // Check reaction and make sure it is not us
            if(!GetIsReactionTypeFriendly(oTarget) && oTarget != oCaster &&
                PHS_GetIsAliveCreature(oTarget))
            {
                // Signal spell cast at
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WAIL_OF_THE_BANSHEE);

                // Check if they can hear us!
                if(GetObjectHeard(oCaster, oTarget) &&
                   PHS_GetCanHear(oTarget))
                {
                    // Check spell resistance and immunity
                    if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                    {
                        // Fortitude death save
                        if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DEATH, oCaster, fDelay))
                        {
                            // Apply death as failed
                            DelayCommand(fDelay, PHS_ApplyInstantAndVFX(oTarget, eDeathVis, eDeath));
                        }
                    }
                }
                // Add one to targets affected (even if they cannot hear it). It
                // only affects any alive things.
                nTargetsAffected++;
            }
            nCnt++;
            oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
        }
        else
        {
            nCnt = nCasterLevel;
        }
    }
}
