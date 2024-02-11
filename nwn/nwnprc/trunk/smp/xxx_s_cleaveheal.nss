/*:://////////////////////////////////////////////
//:: Spell Name Cleave Health
//:: Spell FileName XXX_S_CleaveHeal
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: Fortitude half
    Spell Resistance: Yes
    Source: Various (Aenea DM)

    Upon casting of this spell, a crackling black ray of magic strikes a single
    target. The target immediately suffers enough negative energy damage to drain
    him of 1/2 of his current hit points. A creature with 1 or fewer hit points
    is unaffected.

    If the target succeeds at a Fortitude save, he loses only 1/4 of his current
    hit points.

    Creatures who are not alive, such as Undead, constructs, and elementals are
    unaffected by this spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The level might change, the effects might change (maybe a quarter to start with)
    if the spell becomes overpowered.

    The spell is easy to do though - and is original, well, quite original.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_CLEAVE_HEALTH)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nCurrentHP = GetCurrentHitPoints(oTarget);
    // Ray touch attack
    int nTouch = SMP_SpellTouchAttack(SMP_TOUCH_RAY, oTarget, TRUE);

    // Damage is defined depending on saving throw
    int nDam;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CLEAVE_HEALTH);

    // Do hit/miss ray
    SMP_ApplyTouchBeam(oTarget, VFX_BEAM_BLACK, nTouch);

    // Touch attack
    if(nTouch)
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Spell Resistance
            if(!SMP_SpellResistanceCheck(oCaster, oTarget))
            {
                // Fortitude for quarter damage, else do half damage.
                // * Negative based fortitude save
                if(SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                {
                    // Sucess: Damage is 1/4 HP
                    nDam = nCurrentHP / 4;
                }
                else
                {
                    // Failure: Damage is 1/2 HP
                    nDam = nCurrentHP / 2;
                }
                // Need 1HP or more, so check here.
                if(nDam > 0)
                {
                    // Apply damage and effects
                    SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_NEGATIVE);
                }
            }
        }
    }
}
