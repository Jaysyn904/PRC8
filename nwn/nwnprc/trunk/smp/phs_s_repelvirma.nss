/*:://////////////////////////////////////////////
//:: Spell Name Repel Vermin: On Enter
//:: Spell FileName PHS_S_RepelVirmA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As in Antilife Shell, this will repel vermin.

    They do get a will save (but take damage) and the rules for forcing it
    still apply.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    int nMetaMagic = PHS_GetAOEMetaMagic();

    // Stop if they are not an alive thing, or is plot, or is a DM
    if(GetIsDM(oTarget) || GetPlotFlag(oTarget) || oTarget == oCaster) return;

    // If we are starting still, do not hedge back
    if(GetLocalInt(oCaster, PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_REPEL_VIRMIN))) return;

    // Races:
    //    vermin only
    // But not:
    //    constructs, elementals, outsiders, or undead
    if(GetRacialType(oTarget) != RACIAL_TYPE_VERMIN) return;

    // Check if we are moving, and therefore cannot force it agsint soemthing
    // that would be affected!
    vector vVector = GetPosition(oCaster);
    object oArea = GetArea(oCaster);
    DelayCommand(0.1, PHS_MobileAOECheck(oCaster, PHS_SPELL_REPEL_VIRMIN, vVector, oArea));

    // The target is allowed a Spell resistance and immunity check to force
    // thier way through the barrier
    if(PHS_SpellResistanceCheck(oCaster, oTarget)) return;

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Do they get through? (will save to take 2d6 damage)
    if(PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
    {
        // Allow access and damage
        int nDam = PHS_MaximizeOrEmpower(6, 2, nMetaMagic);
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
        PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam);
        return;
    }

    // Distance we need to move them back is going to be 4M away, so out of the
    // AOE.

    // Therefore, this is 4 - Current Distance.
    float fDistance =  4.0 - GetDistanceBetween(oCaster, oTarget);

    // Debug stuff, obviously we'll need to move them at least 1 meter away.
    if(fDistance < 1.0)
    {
        fDistance = 1.0;
    }

    // Move the enterer back from the caster.
    PHS_PerformMoveBack(oCaster, oTarget, fDistance, GetCommandable(oTarget));
}
