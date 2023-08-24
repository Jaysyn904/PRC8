/*:://////////////////////////////////////////////
//:: Spell Name Liveoak
//:: Spell FileName PHS_S_Liveoak
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Casting Time: 10 minutes
    Range: Touch
    Target: Tree touched
    Duration: One day/level (D)
    Saving Throw: None
    Spell Resistance: No

    This spell turns an oak tree into a protector or guardian. The spell can be
    cast on only a single tree at a time; while liveoak is in effect, you can’t
    cast it again on another tree.

    Liveoak must be cast on a healthy, Huge oak. A triggering phrase of up to one
    word per caster level is placed on the targeted oak. The liveoak spell
    triggers the tree into animating as a treant.

    If liveoak is dispelled, the tree takes root immediately, wherever it happens
    to be. If released by you, the tree tries to return to its original location
    before taking root.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Might wnat to change the duration + casting times.

    It uses a special tagged placeable - should also have a new appearance too.

    DLA treant should be suitable :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_LIVEOAK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Only placeable!
    location lTarget = GetLocation(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sResRef = "phs_liveoaktreant";

    // Get Duration in days
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 24, nMetaMagic);

    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_LIVEOAK, FALSE);

    // Make sure we have targeted a tree, or at least, one placeable
    // with the right integer on it.
    if(GetLocalInt(oTarget, "PHS_LIVEOAK") != TRUE)
    {
        FloatingTextStringOnCreature("Only an oaktree or similar can be targeted by this spell.", oCaster, FALSE);
        return;
    }

    // We create the object, move the staff into its inventory, and add it as
    // a henchman. You cannot look at any summoned creatures inventory - good!
    object oTreant = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lTarget);

    // Apply effects
    PHS_ApplyDuration(oTarget, eCessate, fDuration);

    // Set master
    AddHenchman(oCaster, oTreant);
}
