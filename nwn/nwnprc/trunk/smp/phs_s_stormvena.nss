/*:://////////////////////////////////////////////
//:: Spell Name Storm of Vengance - On Enter
//:: Spell FileName PHS_S_StormVenA
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    On Enter: saving throw or deafened for 1d4x10 minutes.
    No ranged attacks in the cloud.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above, really!

    Concentration checks are made here in 2 second delay command heartbeats,
    which are checked for the integer each time in the heartbeat.

    If concentration is broken, the AOE is destroyed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE creator
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();

    // Declare effects
    effect eDeaf = EffectDeaf();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDeaf, eCessate);
    effect eMissRanged = EffectMissChance(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eConsRanged = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);

    // eMissLink needs to be supernatural.
    effect eMissLink = EffectLinkEffects(eMissRanged, eConsRanged);
    eMissLink = SupernaturalEffect(eMissLink);

    // Always apply the consealment against ranged attacks and ranged attack
    // failure.
    PHS_ApplyPermanent(oTarget, eMissLink);

    // Get random duration
    float fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);
    // It is 10x1d4
    fDuration *= 10;

    // PvP check and can the entering object hear the sound to start with?
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) && PHS_GetCanHear(oTarget))
    {
        // Signal event
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STORM_OF_VENGEANCE);

        // Spell reistance and immunity check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Saving throw against the effect
            if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
            {
                // Apply effects for the duration
                DelayCommand(0.1, PHS_ApplyDuration(oTarget, eLink, fDuration));
            }
        }
    }
}
