/*:://////////////////////////////////////////////
//:: Spell Name Light
//:: Spell FileName PHS_S_Light
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Touch
    Target: Object touched
    Duration: 10 min./level (D)
    Saving Throw: None
    Spell Resistance: No

    This spell causes an object to glow like a torch, shedding bright light in a
    20-M radius. The effect is immobile, but it can be cast on a movable object
    such as an item. Light taken into an area of magical darkness does not
    function.

    A light spell (one with the light descriptor) counters and dispels a darkness
    spell (one with the darkness descriptor) of an equal or lower level.

    Arcane Material Component: A firefly or a piece of phosphorescent moss.

//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can only be cast on items, and adds a tempoary property to them for 10min/level,
    and a duration effect to the owner so dispels can pick it up.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "prc_x2_itemprop"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_LIGHT)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nType = GetObjectType(oTarget);

    // Get duration in 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare item property
    itemproperty IP_Light = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_YELLOW);
    // Declare duration VFX
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    // eLight is used if oTarget is not an item
    effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20);

    // Make sure the target is an item for the item properties.
    if(nType == OBJECT_TYPE_ITEM)
    {
        if(GetItemPossessor(oTarget) != oCaster)
        {
            FloatingTextStringOnCreature("You can only cast light on an item in your personal inventory.", oCaster, FALSE);
            return;
        }
        // Make sure the item doesn't have the property already!
        if(!GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT))
        {
            // Add the property for fDuration
            IPSafeAddItemProperty(oTarget, IP_Light, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);
            // Add a duration effect to the caster
            PHS_ApplyDuration(oTarget, eDur, fDuration);
        }
    }
    // Else, light effect if immobile object
    else if(nType == OBJECT_TYPE_DOOR ||
            nType == OBJECT_TYPE_PLACEABLE)
    {
        // Remove previous castings
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_LIGHT, oTarget);

        // Add a duration effect to the target
        PHS_ApplyDuration(oTarget, eLight, fDuration);
    }
}
