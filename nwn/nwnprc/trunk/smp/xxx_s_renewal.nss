/*:://////////////////////////////////////////////
//:: Spell Name Renewal
//:: Spell FileName XXX_S_Renewal
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 3
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Target: Willing living creature touched
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: Yes (Harmless)
    Source: Various (Sproik)

    The willing subject regains lost hit points as if it had rested for a night,
    at 1 hit point per level of the target (though this healing does not restore
    temporary ability damage and provide other benefits of resting).

    Material Component: A small pillow.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As it seems, this is taken directly from the spell Polymorph :-D

    Therefore, this is fine, even as it is a sorceror/wizard spell.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!SMP_SpellHookCheck(SMP_SPELL_RENEWAL)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();
    int nHeal;

    // Check if even alive.
    if(SMP_GetIsAliveCreature(oTarget, "*You must target a living creature to heal*"))
    {
        // Get total healing to be done. 1 HP per target HD.
        nHeal = GetHitDice(oTarget);

        // Declare what to heal
        effect eHeal = EffectHeal(nHeal);
        effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);

        // Do the healing and visual
        SMP_ApplyInstantAndVFX(oTarget, eVis, eHeal);
    }
}
