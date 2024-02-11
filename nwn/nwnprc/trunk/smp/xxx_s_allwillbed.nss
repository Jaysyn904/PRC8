/*:://////////////////////////////////////////////
//:: Spell Name All Will Be Dust
//:: Spell FileName XXX_S_AllWillBeD
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 8
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target: One object or corporeal creature
    Duration: Concentration, up to 3 rounds
    Saving Throw: Fortitude partial
    Spell Resistance: Yes
    Source: Various (weenie)

    This spell inflicts the damage of eons upon a target, wearing it down in a
    couple of rounds. First, the target is hasted for three rounds, with no save.
    Additionally, it suffers increasing amounts of damage: it takes 8d8 damage
    on the first round, 10d8 on the second, and 12d8 on the third. Each round it
    can save for half damage. If this damage would kill the target, bringing an
    NPC or object to 0 hit points, it is disintegrated (as the disintegrate
    spell), leaving behind only a trace of fine dust.

    The damage only happens, as with the haste, as long as the caster leave the
    spell to complete concentration - noting normal concentration rules for
    casting spells applies.

    The damage inflicted is of no particular type or energy - it is a purely the
    "wear and tear" that would eventually be inflicted by the passage of time,
    only the spell speeds this process up into three rounds; during that time,
    the target shows signs of aging and visibly decomposes. If they do not die,
    the visible decomposition is not permament and life returns to their body
    after a few seconds.

    Note that the target's normal lifespan is of no importance, the spell is
    equally effective on mortals, immortals, constructs, undead, or objects.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As it says.

    To do the effects, and stuff, we fire up secondary spells, not normally
    castable, and which take 3 seconds to cast, and 3 more to conjure.

    Will need testing!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Check what spell was cast. Was it 1 (Original) 2 or 3?
    int nSpellId = GetSpellId();

    // Define a few other things
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    // The value which needs to be present for round 2 and 3. Reset on round 1
    string sLocalVar = "SMP_AWBD" + ObjectToString(oCaster);
    int nTargetValue = GetLocalInt(oTarget, sLocalVar);

    // Delete the local too, just in case
    DeleteLocalInt(oTarget, sLocalVar);

    // Declare damage and effects
    int nDam;
    effect eVis = EffectVisualEffect(SMP_VFX_IMP_ALL_WILL_BE_DUST);
    effect eHaste = SMP_CreateHasteEffect();
    effect eHasteVis = EffectVisualEffect(VFX_IMP_HASTE);

    // Things that depend on which "Dust" it is.
    int nSpellSaveDC, nMetaMagic;

    if(nSpellId == SMP_SPELL_ALL_WILL_BE_DUST_ROUND2)
    {
        // Need to have the correct integer on the target
        if(nTargetValue == 2)
        {
            // Do haste
            SMP_ApplyDurationAndVFX(oTarget, eHasteVis, eHaste, 6.0);

            // Get save DC and metamagic
            nSpellSaveDC = GetLocalInt(oCaster, "SMP_SPELL_CAST_SPELL_SAVEDC" + IntToString(SMP_SPELL_ALL_WILL_BE_DUST));
            nMetaMagic = GetLocalInt(oCaster, "SMP_SPELL_CAST_SPELL_METAMAGIC" + IntToString(SMP_SPELL_ALL_WILL_BE_DUST));

            // Damage - 10d8
            nDam = SMP_MaximizeOrEmpower(8, 10, nMetaMagic);
            // Fortitude save for half
            nDam = SMP_GetAdjustedDamage(SAVING_THROW_FORT, nDam, oTarget, nSpellSaveDC);

            // Do damage
            if(nDam > 0)
            {
                // Do disintegrate damage
                SMP_DisintegrateDamage(oTarget, eVis, nDam);
            }

            // Do next round damage/concentration
            // Set local, then action
            // Integer == What it should be NEXT time this script is called.
            SetLocalInt(oTarget, sLocalVar, 3);

            // Do the casting action
            ClearAllActions();
            ActionCastSpellAtObject(SMP_SPELL_ALL_WILL_BE_DUST_ROUND3, oTarget, METAMAGIC_NONE, TRUE);
        }
    }
    else if(nSpellId == SMP_SPELL_ALL_WILL_BE_DUST_ROUND3)
    {
        // Need to have the correct integer on the target
        if(nTargetValue == 2)
        {
            // Do haste
            SMP_ApplyDurationAndVFX(oTarget, eHasteVis, eHaste, 6.0);

            // Get save DC and metamagic
            nSpellSaveDC = GetLocalInt(oCaster, "SMP_SPELL_CAST_SPELL_SAVEDC" + IntToString(SMP_SPELL_ALL_WILL_BE_DUST));
            nMetaMagic = GetLocalInt(oCaster, "SMP_SPELL_CAST_SPELL_METAMAGIC" + IntToString(SMP_SPELL_ALL_WILL_BE_DUST));

            // Damage - 12d8
            nDam = SMP_MaximizeOrEmpower(8, 12, nMetaMagic);
            // Fortitude save for half
            nDam = SMP_GetAdjustedDamage(SAVING_THROW_FORT, nDam, oTarget, nSpellSaveDC);

            // Do damage
            if(nDam > 0)
            {
                // Do disintegrate damage
                SMP_DisintegrateDamage(oTarget, eVis, nDam);
            }
        }
    }
    else //if(nSpellId == SMP_SPELL_ALL_WILL_BE_DUST)// Original/New by default.
    {
        // Spell hook check
        if(!SMP_SpellHookCheck(SMP_SPELL_ALL_WILL_BE_DUST)) return;

        // Do everything as if it was a normal impact spell.

        // IE: First, resisting the spell
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Get save DC and metamagic
            nSpellSaveDC = SMP_GetSpellSaveDC();
            nMetaMagic = SMP_GetMetaMagicFeat();

            // Do haste
            SMP_ApplyDurationAndVFX(oTarget, eHasteVis, eHaste, 6.0);

            // Damage - 8d8
            nDam = SMP_MaximizeOrEmpower(8, 10, nMetaMagic);
            // Fortitude save for half
            nDam = SMP_GetAdjustedDamage(SAVING_THROW_FORT, nDam, oTarget, nSpellSaveDC);

            // Do damage
            if(nDam > 0)
            {
                // Do disintegrate damage
                SMP_DisintegrateDamage(oTarget, eVis, nDam);
            }

            // Do next round damage/concentration
            // Set local, then action
            // Integer == What it should be NEXT time this script is called.
            SetLocalInt(oTarget, sLocalVar, 2);

            // Do the casting action
            ClearAllActions();
            ActionCastSpellAtObject(SMP_SPELL_ALL_WILL_BE_DUST_ROUND2, oTarget, METAMAGIC_NONE, TRUE);
        }
    }
}
