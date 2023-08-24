/*:://////////////////////////////////////////////
//:: Spell Name Identify
//:: Spell FileName PHS_S_Identify
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 1, Magic 2, Sor/Wiz 1
    Components: V, S, M/DF
    Casting Time: 1 hour
    Range: Touch
    Targets: One touched object
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    The spell determines all magic properties of a single magic item, including
    how to activate those functions (if appropriate), and how many charges are
    left (if any).

    Identify does not function when used on an artifact.

    Arcane Material Component: A pearl of at least 100 gp value, crushed and
    stirred into wine with an owl feather; the infusion must be drunk prior to
    spellcasting.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Identifies the target object, if not done so already.

    Gem is used, a real gem of the name Pearl, worth 100 gold or more.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_IDENTIFY)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    // Check for Arcane 100gp of pearls
    if(!PHS_ComponentItemGemCheck("Identify", 100, "Pearl")) return;

    // Check target - must be an item
    if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM &&
      !GetIdentified(oTarget))
    {
        SetIdentified(oTarget, TRUE);
        SendMessageToPC(oCaster, "You have identified the properties of the item, " + GetName(oTarget));
    }
    else
    {
        // Not something valid to identify!
        return;
    }

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_IDENTIFY, FALSE);

    // Apply effects
    PHS_ApplyVFX(oTarget, eVis);
}
