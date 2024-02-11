/*:://////////////////////////////////////////////
//:: Spell Name Changestaff
//:: Spell FileName PHS_S_Changestaf
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 7
    Components: V, S, F
    Casting Time: 1 round
    Range: Touch
    Target: Your touched staff on the ground
    Duration: 1 hour/level (D)
    Saving Throw: None
    Spell Resistance: No

    You change a specially prepared quarterstaff into a Huge treantlike
    creature, about 24 feet tall. When you plant the end of the staff in the
    ground andcast the spell at it, your staff turns into a creature that looks
    and fights just like a treant. The staff-treant defends you and obeys any
    commands as a summoned creature would. However, it is by no means a true
    treant; it cannot converse with actual treants or control trees. If the
    staff-treant is reduced to 0 or fewer hit points, it crumbles to powder
    and the staff is destroyed. Otherwise, the staff returns to its normal
    form when the spell duration expires (or when the spell is dismissed), and
    it can be used as the focus for another casting of the spell. The
    staff-treant is always at full strength when created, despite any wounds it
    may have incurred the last time it appeared.

    Focus: The quarterstaff, which must be specially prepared, probably perchased beforehand.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The AI scripts do the stuff for returning the staff. It is placed on the ground
    when the creature is unsummoned/duration runs out.

    If the creature is killed, it is destroyed as normal in the death script.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Only item!
    object oPossessor = GetItemPossessor(oTarget);
    location lTarget = GetLocation(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get Duration
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Make sure we have targeted a prepared staff
    // - Can be any staff with this local on it
    if(GetLocalInt(oTarget, "PHS_CHANGESTAFF") != TRUE)
    {
        FloatingTextStringOnCreature("Only a specially prepared staff can be used for Changestaff.", oCaster, FALSE);
        return;
    }
    // Make sure it is not in an inventory
    if(GetIsObjectValid(oPossessor))
    {
        FloatingTextStringOnCreature("You must put the staff on the ground to cast Changestaff.", oCaster, FALSE);
        return;
    }

    // We create the object, move the staff into its inventory, and add it as
    // a henchman. You cannot look at any summoned creatures inventory - good!
    object oTreant = CreateObject(OBJECT_TYPE_CREATURE, PHS_CREATURE_RESREF_CHANGESTAFF_TREANT, lTarget);

    // Apply effects
    PHS_ApplyDuration(oTarget, eCessate, fDuration);

    // Set master
    AddHenchman(oCaster, oTreant);

    // Move the staff
    object oStaff = CopyItem(oTarget, oTreant, TRUE);

    // Set the staff so its easier to script.
    SetLocalObject(oTreant, "PHS_CHANGESTAFF_STAFF", oStaff);
}
