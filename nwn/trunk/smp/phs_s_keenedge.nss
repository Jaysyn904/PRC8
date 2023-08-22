/*:://////////////////////////////////////////////
//:: Spell Name Keen Edge
//:: Spell FileName PHS_S_KeenEdge
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Targets: One weapon
    Duration: 10 min./level
    Saving Throw: Will negates (harmless, object)
    Spell Resistance: Yes (harmless, object)

    This spell makes a weapon magically keen, improving its ability to deal
    telling blows. This transmutation doubles the threat range of the weapon. A
    threat range of 20 becomes 19-20, a threat range of 19-20 becomes 17-20, and
    a threat range of 18-20 becomes 15-20. The spell can be cast only on
    piercing or slashing weapons.

    Multiple effects that increase a weapon’s threat range (such as the keen
    edge spell and natural keeness) don’t stack. You can’t cast this spell on a
    natural weapon, such as a claw.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This will do as it says - apply, tempoarily, the item property Keen Edge, to
    any of the slashing or piercing weapons.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_KEEN_EDGE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be an item!
    object oPossessor = GetItemPossessor(oTarget);
    int nAmmoType = GetBaseItemType(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    itemproperty IP_Keen = ItemPropertyKeen();

    // Duration is 10 minutes a level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    if(GetIsObjectValid(oPossessor))
    {
        // Signal event
        PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_KEEN_EDGE, FALSE);
    }

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    // Must be a piercing OR slashing weapon (or both!)
    if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM &&
       PHS_IP_GetIsPiercingOrSlashingWeapon(oTarget))
    {
        // Apply visual effect
        if(GetIsObjectValid(oPossessor))
        {
            PHS_ApplyLocationVFX(GetLocation(oPossessor), eVis);
        }
        else
        {
            PHS_ApplyLocationVFX(GetLocation(oTarget), eVis);
        }
        // Apply item property for duration
        IPSafeAddItemProperty(oTarget, IP_Keen, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else
    {
        FloatingTextStringOnCreature("Invalid item targeted", oCaster, FALSE);
    }
}
