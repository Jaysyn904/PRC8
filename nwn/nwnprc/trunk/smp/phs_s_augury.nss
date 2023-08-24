/*:://////////////////////////////////////////////
//:: Spell Name Augury
//:: Spell FileName PHS_S_Augury
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Clr 2
    Components: V, S, M, F
    Casting Time: 1 minute
    Range: Personal
    Target: You
    Duration: Instantaneous
    DM Spell

    An augury can tell you whether a particular action will bring good or bad
    results for you in the immediate future.

    The base chance for receiving a meaningful reply is 70% + 1% per caster level,
    to a maximum of 90%; this roll is made secretly. A question may be so
    straightforward that a successful result is automatic, or so vague as to have
    no chance of success. If the augury succeeds, you get one of four results:

    • Weal (if the action will probably bring good results).
    • Woe (for bad results).
    • Weal and woe (for both).
    • Nothing (for actions that don’t have especially good or bad results).

    If the spell fails, you get the “nothing” result. A cleric who gets the
    “nothing” result has no way to tell whether it was the consequence of a
    failed or successful augury.

    The augury can see into the future only about half an hour, so anything that
    might happen after that does not affect the result. Thus, the result might
    not take into account the long-term consequences of a contemplated action.
    All auguries cast by the same person about the same topic use the same dice
    result as the first casting.

    This is a DM spell, and only a DM can determine if a result will be one of
    the 4 above. Make sure a DM knows what you asked. Everything but the result
    is automatic.

    Material Component: Incense worth at least 25 gp.

    Focus: A set of marked sticks, bones, or similar tokens of at least 25 gp
    value.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Automatic stuff, apart from the result.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Check for material componant
    if(!PHS_ComponentExactItemRemove(PHS_ITEM_INCENSE_25, "Incense worth 25GP", "Augury")) return;

    // Check for spell focus
    if(!PHS_ComponentFocusItem(PHS_ITEM_MARKED_STICKS_25, "Marked sticks or similar worth 25GP", "Augury")) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF.
    int nCasterLevel = PHS_GetCasterLevel();
    // - 70% + 1% per caster level, to a maximum of 90%;
    int nPercent = 70 + PHS_LimitInteger(nCasterLevel, 20);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

    // Alery DM's
    PHS_AlertDMsOfSpell("Augury", PHS_GetSpellSaveDC(), nCasterLevel);

    // d100 % roll - needs to be under nPercent (71 to 90)
    if(d100() <= nPercent)
    {
        // PASS
        // Send message of pass
        SendMessageToAllDMs("Augury: Result: PASS. Allow Meaningfull Reply");
    }
    else
    {
        // Send message of fail
        SendMessageToAllDMs("Augury: Result: FAIL. No meaningfull reply");
    }

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_AUGURY, FALSE);

    // Apply effects
    PHS_ApplyVFX(oTarget, eVis);

    // Also play animation - pray
    PlayAnimation(ANIMATION_LOOPING_MEDITATE);
}
