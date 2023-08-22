/*:://////////////////////////////////////////////
//:: Spell Name Shield Other - On Exit (Caster's AOE)
//:: Spell FileName PHS_S_ShieldOthB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changed somewhat:

    - Only divides up direct magical damage
    - No monster spells affected

    No phisical damage is split either. Its still quite powerful (and, there is
    always the AC bonuses!)

--->Needs a new AOE for the caster, and a VFX for the target. The AOE is actually
    totally invisible, and is just 8M diameter. If the person with the shield
    other effects moves out of the spells range, ie, out of the AOE, it gets
    instantly removed.

    Only one shield other can ever be applied to any target. It'll remove the
    effects from the target, and the creator of the targets spell effects too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare Major Variables
    object oExiter = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();

    // If they have the effects of this spell from us, we remove both ours
    // and thiers.
    if(PHS_FirstCasterOfSpellEffect(PHS_SPELL_SHIELD_OTHER, oExiter) == oCreator)
    {
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SHIELD_OF_FAITH, oExiter);
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SHIELD_OF_FAITH, oCreator);
        return;
    }
}
