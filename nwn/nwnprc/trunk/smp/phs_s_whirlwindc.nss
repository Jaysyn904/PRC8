/*:://////////////////////////////////////////////
//:: Spell Name Whirlwind: On Heartbeat
//:: Spell FileName PHS_S_WhirlwindC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    AOE On Heartbeat:

    - Acts the same as the on enter, does the same things (with a small random delay)
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
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nReflex, nDam;
    int bApplied = FALSE;
    float fNewDuration, fDelay;

    // Duration is 1 round
    float fDuration = RoundsToSeconds(1);

    // Declare major effects
    effect eNoKnockdown = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    effect eKnockdown = EffectKnockdown();

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget) &&
        // Cannot have effects of this spell already
           !GetHasSpellEffect(PHS_SPELL_WHIRLWIND, oTarget))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WHIRLWIND);

            // Get a small delay
            fDelay = PHS_GetRandomDelay(0.1, 2.0);
            fNewDuration = fDuration - fDelay;

            // Check spell resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
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
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_BLUDGEONING));
                }

                // Second part is a reflex save, 2nd, to stop being knocked down
                if(nReflex == FALSE)
                {
                    // Do second save
                    if(!PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
                    {
                        // Do knockdown for 6 seconds
                        bApplied = TRUE;
                        DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eKnockdown, fNewDuration));
                    }
                }
            }
            // If we didn't apply a temp effect, apply one so this doesn't fire a lot
            if(bApplied == FALSE)
            {
                // Apply duration effect
                DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eNoKnockdown, fNewDuration));
            }
            // Reset flag
            bApplied = FALSE;
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
