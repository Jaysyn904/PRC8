/*:://////////////////////////////////////////////
//:: Spell Name Whirlwind: On Enter
//:: Spell FileName PHS_S_WhirlwindA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    AOE On enter:

    - Acts the same as the heartbeat, if I only used the heartbeat, it might not
      affect things it "ran over" at all!
      (note: safety catch, if they still have the Knockdown from it, or a
       special visual for same amount of seconds, the next heartbeat or any On
       Enter's won't affect them)

    - Does 3d6 damage, reflex save half, and if they fail thier first reflex save,
      there is a second else knockdown for 6 seconds.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nReflex, nDam;
    int bApplied = FALSE;

    // Cannot have effects of this spell already
    if(GetHasSpellEffect(PHS_SPELL_WHIRLWIND, oTarget)) return;

    // Duration is 1 round
    float fDuration = RoundsToSeconds(1);

    // Declare major effects
    effect eNoKnockdown = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    effect eKnockdown = EffectKnockdown();

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Fire cast spell at event for the specified target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WHIRLWIND);

        // Check spell resistance
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Reflex save 1
            nReflex = PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster);

            // Get damage
            nDam = PHS_MaximizeOrEmpower(6, 3, nMetaMagic);

            // Change the damage done
            nDam = PHS_ReflexAdjustDamage(nReflex, nDam, oTarget);

            // Do damage, if any
            if(nDam > 0)
            {
                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_BLUDGEONING);
            }

            // Second part is a reflex save, 2nd, to stop being knocked down
            if(nReflex == FALSE)
            {
                // Do second save
                if(!PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
                {
                    // Do knockdown for 6 seconds
                    bApplied = TRUE;
                    PHS_ApplyDuration(oTarget, eKnockdown, fDuration);
                }
            }
        }
        // If we didn't apply a temp effect, apply one so this doesn't fire a lot
        if(bApplied == FALSE)
        {
            // Apply duration effect
            PHS_ApplyDuration(oTarget, eNoKnockdown, fDuration);
        }
    }
}
