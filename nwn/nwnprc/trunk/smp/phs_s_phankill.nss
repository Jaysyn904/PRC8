/*:://////////////////////////////////////////////
//:: Spell Name Phantasmal Killer
//:: Spell FileName phs_s_phankill
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range. 1 living creature target. Fear/Mind affecting. Will disbelief,
    then fort partial. SR applies. If will save fails, the beast touches the
    target, then, if they fail a fortitude save, it dies, else 3d6 damage.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Helm of telepathy removed, I am afraid.

    Could add it later :-P

    - It is currently FEAR and DEATH type saves...

    - Might change to FEAR and MIND, as the spell describes...
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_PHANTASMAL_KILLER)) return;

    // Declare target variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Damage
    int nDam = PHS_MaximizeOrEmpower(6, 3, nMetaMagic);

    // Declare effects
    effect eDeath = EffectDeath();
    effect eDeathVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eDamVis = EffectVisualEffect(VFX_IMP_SONIC);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal Event
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PHANTASMAL_KILLER);

        // Spell resistance and immunity check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Will save - Disbelief (fear spell)
            // - Fear will be picked up VIA. Mind immunity. Fear saves are more important
            //   to have (EG: Greater Heroism only protects VS fear)
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR) &&
               !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
            {
                // Fortitude save for partial
                if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DEATH))
                {
                    // FAIL: Death
                    PHS_ApplyInstantAndVFX(oTarget, eDeathVis, eDeath);
                }
                else
                {
                    // FAIL: Damage
                    PHS_ApplyDamageVFXToObject(oTarget, eDamVis, nDam);
                }
            }
        }
    }
}
