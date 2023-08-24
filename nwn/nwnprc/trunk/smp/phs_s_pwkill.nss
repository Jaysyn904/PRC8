/*:://////////////////////////////////////////////
//:: Spell Name Power Word Kill
//:: Spell FileName PHS_S_PWKill
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Death, Mind-Affecting]
    Level: Sor/Wiz 9, War 9
    Components: V
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One living creature with 100 hp or less
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: Yes

    You utter a single word of power that instantly kills one creature of your
    choice, whether the creature can hear the word or not. Any creature that
    currently has 101 or more hit points is unaffected by power word kill.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell, including Bioware visual effect.

    Note that we use PHS_ImmunityCheck for the 2 immunities.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_POWER_WORD_KILL)) return;

    //Declare target variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nHitpoints = GetCurrentHitPoints(oTarget);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eDeath = EffectDeath();

    // Apply the VFX impact
    effect eWord =  EffectVisualEffect(VFX_FNF_PWKILL);
    PHS_ApplyLocationVFX(GetLocation(oTarget), eWord);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Make sure thier HP is <= 100
        if(nHitpoints <= 100)
        {
            // Signal Spell Cast at
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_POWER_WORD_KILL);

            // Check spell resistance and immunity
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Immunity to mind spells prevents
                if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                {
                    // Immunity to death prevents.
                    if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_DEATH))
                    {
                        // Apply death effects
                        PHS_ApplyInstantAndVFX(oTarget, eVis, eDeath);
                    }
                }
            }
        }
    }
}
