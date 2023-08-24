/*:://////////////////////////////////////////////
//:: Spell Name Temporal Stasis
//:: Spell FileName PHS_S_TempStasis
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Fortitude negates. Needs touch attack (and has SR checks). If successful, the
    target is made immobile and suspended in animation (paralyzed). It also
    has damage immunity increased for everything to 100, and all immunities
    are added.

    Material Component: A powder composed of diamond, emerald, ruby, and
    sapphire dust with a total value of at least 5,000 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Those who are already plot cannot be affected by the spell.

    Doesn't use any scripting commands - only effects, so can be sure of dispelling
    working right (among other things!)

    needs a 5000 gold componant.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_TEMPORAL_STASIS)) return;

    // Check for 5000 gold valued gem.
    if(!PHS_ComponentItemGemCheck("Temporal Stasis", 5000)) return;

    // Delcare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    // We only use nCasterLevel for <= normal difficulty
    int nCasterLevel = PHS_GetCasterLevel();

    // Declare effects
    effect eStop = EffectCutsceneImmobilize();
    effect eStopDur = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_TEMPORAL_STASIS);
    effect eImmunities = PHS_AllImmunitiesLink();

    // Link stop, immunity and blur (blue glowy effect!)
    effect eLink = EffectLinkEffects(eStop, eStopDur);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eImmunities);

    // Fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_TEMPORAL_STASIS, TRUE);

    // Apply beam visual for touch attack
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_ODD, nTouch);

    // Touch attack melee. Criticals mean squat.
    if(PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE))
    {
        // PvP and plot/immortal check
        if(!GetIsReactionTypeFriendly(oTarget) && PHS_CanCreatureBeDestroyed(oTarget))
        {
            // We don't check turning but DO check spell resistance + immunity.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Fortitude save with spell resistance
                if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SPELL))
                {
                    // Apply effects and visuals.
                    PHS_ApplyPermanentDeath(oTarget, eLink, nCasterLevel, "You have been put in stasis, and cannot recover your status alone");
                }
            }
        }
    }
}
