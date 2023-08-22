/*:://////////////////////////////////////////////
//:: Spell Name Slay Living
//:: Spell FileName PHS_S_ SlayLiving
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy [Death]
    Level: Clr 5, Death 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Living creature touched
    Duration: Instantaneous
    Saving Throw: Fortitude partial
    Spell Resistance: Yes

    You can slay any one living creature. You must succeed on a melee touch attack
    to touch the subject, and it can avoid death with a successful Fortitude save.
    If it succeeds, it instead takes 3d6 points of damage +1 point per caster level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Death and whatever. Needs a living target.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SLAY_LIVING)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Damage is 3d6 + Caster level to no limit.
    int nDamage = PHS_MaximizeOrEmpower(6, 3, nMetaMagic, nCasterLevel);

    // Delcare effects
    // Death effects
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eDeath = EffectDeath();
    // Damage effects
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    // Signal Spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SLAY_LIVING);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Spell Resistance + Immunity check + Immunity to death
        if(!PHS_SpellResistanceCheck(oCaster, oTarget) &&
           !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_DEATH))
        {
            // Saving throw check
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
