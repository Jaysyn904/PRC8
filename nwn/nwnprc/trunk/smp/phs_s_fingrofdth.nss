/*:://////////////////////////////////////////////
//:: Spell Name Finger of Death
//:: Spell FileName phs_s_fingrofdth
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    8M range, fort partial, SR applies. 1 living creature as target. [Death]

    You can slay any one living creature within range. The target is entitled to
    a Fortitude saving throw to survive the attack. If the save is successful,
    the creature instead takes 3d6 points of damage +1 point per caster level
    (maximum +25).

    The subject might die from damage even if it succeeds on its saving throw.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Standard death spell. Very similar to NWN's already one, for once :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FINGER_OF_DEATH)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Limit the bonus to damage to 25.
    int nBonus = PHS_LimitInteger(nCasterLevel, 25);
    // Damage is 3d6 + Caster level to 25.
    int nDamage = PHS_MaximizeOrEmpower(6, 3, nMetaMagic, nCasterLevel);

    // Delcare effects
    // Death effects
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eDeath = EffectDeath();
    // Damage effects
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    // Signal Spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FINGER_OF_DEATH);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Spell Resistance + Immunity check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Saving throw + Immunity check
            if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DEATH))
            {
                // Fail and we apply death
                PHS_ApplyInstantAndVFX(oTarget, eVis, eDeath);
            }
            else
            {
                // Even if they pass, we do damage.
                PHS_ApplyDamageVFXToObject(oTarget, eVis2, nDamage, DAMAGE_TYPE_NEGATIVE);
            }
        }
    }
}
