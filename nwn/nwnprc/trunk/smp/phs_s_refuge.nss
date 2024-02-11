/*:://////////////////////////////////////////////
//:: Spell Name Refuge
//:: Spell FileName PHS_S_Refuge
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Teleportation)
    Level: Clr 7, Sor/Wiz 9
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Target: Object touched
    Duration: Permanent until discharged
    Saving Throw: None
    Spell Resistance: No

    You create powerful magic in some specially prepared object. This object
    contains the power to instantly transport its possessor across any distance
    within the same plane to you. Once the item is transmuted, only party
    members can activate it (and must be in your party at the time of breaking
    the item). When transmuted, breaking the item will cause it to be activated.
    When this is done, the individual and all objects it is wearing and carrying
    (to a maximum of the character’s heavy load) are instantly transported to
    your abode. No other creatures are affected (aside from familiars).

    You can alter the spell when casting it so that it transports you to within
    3 meters of the possessor of the item when it is broken. You will have a
    general idea of the location and situation of the item possessor at the time
    the refuge spell is discharged, but once you decide to alter the spell in
    this fashion, you have no choice whether or not to be transported. Again,
    only current party members may activate it.

    Material Component: The specially prepared object, whose construction
    requires gems worth 1,500 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can be cast on any item.

    Once the item has the spell, it has the caster's name set on it. Only PCs
    can cast this spell.

    Once used, the item power set (permamently) on the thing that is, it will
    transport the PC to the caster, or, Vice Versa.

    Cannot be dispelled, for easyness sakes, and needs a material component.

    It was also "to the casters Abode", but heck, that'd be so much more complicated
    and unfun.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_REFUGE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be a specific item
    object oPossessor = GetItemPossessor(oTarget);
    // * Only PC's can cast this. The name defines the PC.
    string sName = GetPCPlayerName(oCaster) + GetName(oCaster);
    // If TRUE, the caster is teleported to the target, so
    // it defaults to FALSE, which means the person using it (the target) is
    // teleported to the caster.
    // * It is kinda a "Move the caster to the target?" question for the name reference.
    int bMoveCaster = GetLocalInt(oCaster, "PHS_SPELL_REFUGE_MOVE_CASTER");

    // Check if it is a Pc casting it.
    if(oPossessor != oCaster)
    {
        // Doesn't work
        FloatingTextStringOnCreature("*Only a Player Character can cast this spell*", oCaster, FALSE);
        return;
    }

    // Check the item tag
    if(GetTag(oTarget) != PHS_ITEM_SPECIAL_REFUGE)
    {
        // Doesn't work
        FloatingTextStringOnCreature("*You may only transmute a specially prepared object*", oCaster, FALSE);
        return;
    }

    // Check if oPossessor is valid, and the caster
    if(oPossessor != oCaster)
    {
        // Doesn't work
        FloatingTextStringOnCreature("*You cannot cast this on an item not in your inventory*", oCaster, FALSE);
        return;
    }

    // Make sure they are not immune to spells (IE: Not plot)
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    itemproperty IP_Spell = ItemPropertyCastSpell(PHS_IP_CONST_CASTSPELL_REFUGE, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_REFUGE, FALSE);

    // Cannot have this property already
    if(IPGetItemHasProperty(oTarget, IP_Spell, DURATION_TYPE_PERMANENT, TRUE))
    {
        // Doesn't work
        FloatingTextStringOnCreature("*This item already has a refuge spell transmuted upon it*", oCaster, FALSE);
        return;
    }

    // Sucess notification
    if(bMoveCaster == FALSE)
    {
        // Moves the target to the caster
        FloatingTextStringOnCreature("*You transmute the item so that a player can teleport himself to you*", oCaster, FALSE);
    }
    else
    {
        // Moves the caster to the target
        FloatingTextStringOnCreature("*You transmute the item so that a player can force you to teleport to him*", oCaster, FALSE);
    }

    // The person to teleport to/from.
    SetLocalString(oTarget, "PHS_REFUGE_CASTER_NAME", sName);
    // If this is TRUE, we move the caster to the user, not the user to the caster
    SetLocalInt(oTarget, "PHS_REFUGE_MOVE_CASTER", bMoveCaster);
    // We can add the item property
    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Spell, oTarget);
}
