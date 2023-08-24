/*:://////////////////////////////////////////////
//:: Spell Name Rope Trick
//:: Spell FileName PHS_S_RopeTrick
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 2
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Target: One touched piece of rope 5M (15ft.) long
    Duration: 1 hour/level (D)
    Saving Throw: None
    Spell Resistance: No

    When this spell is cast upon a piece of rope 5M (15ft.) long, one end of the
    rope rises into the air until the whole rope hangs perpendicular to the
    ground, as if affixed at the upper end. The upper end is, in fact, fastened
    to an extradimensional space that is outside the multiverse of
    extradimensional spaces (“planes”). Creatures in the extradimensional space
    are hidden, beyond the reach of spells (including divinations). The space
    holds as many as eight creatures (of any size). Creatures in the space can
    pull the rope up into the space, making the rope “disappear.” In that case,
    the rope counts as one of the eight creatures that can fit in the space.

    Spells cannot be cast across the extradimensional interface, nor can area
    effects cross it. Those in the extradimensional space can see out of the
    space if they so wish, although there were a window centered on the rope.
    The window is present on the Material Plane, but it’s invisible, and even
    creatures that can see the window can’t see through it. Anything inside the
    extradimensional space drops out when the spell ends. The rope can be
    climbed by only one person at a time.

    Note: It is hazardous to create an extradimensional space within an existing
    extradimensional space or to take an extradimensional space into an existing
    one.

    Material Component: Powdered corn extract and a twisted loop of parchment.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    New area(s) used for this "trick".

    The people can look out of the area briefly (using a cutscene style thing)
    and pull up the rope too.

    The rope is a placable.

    The place just holds things, up to 8 "things", and will not take any more.

    Anyone can go up.

    Note: The actual people inside the area are counted via. the area's On Enter
    (using a count of objects, as to not specifically just add/remove one), and
    the On Exit (same script). If at any time more then X creatures are in,
    then the last one to enter (and so on backwards) are removed.

    It is also checked when they click the rope, but NPC's are, well, harder.

    Main script: Creates the rope at the location. Cannot be created in a rope
    area already!
    Enter (A) script: Checks, as above, and boots entering things.
    Exit (B) script: As above, and boots things that have entered if too many.
    Heartbeat (C) script: Will check the duration of the spell (the caster is
            checked for the spells effects, if no caster or no effect, area goes)
    Rope Used (D) script: Placable On Used event, will converse with a person.
    Window Used (E) script: Window/Entrance inside the rope trick area, can see
            out (Cutscene) and move down/retract the rope or put it back.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ROPE_TRICK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Of course needs some rope to be targeted,
    if(GetTag(oTarget) != PHS_ITEM_ROPE ||
       GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
    {
        // Report failure
        FloatingTextStringOnCreature("*You must target some rope for Rope Trick to function*", oCaster, FALSE);
        return;
    }
    // on the ground!
    if(GetIsObjectValid(GetItemPossessor(oTarget)))
    {
        // Report failure
        FloatingTextStringOnCreature("*You cannot target rope inside your inventory, it must be on the ground*", oCaster, FALSE);
        return;
    }

    // Duration - 1 hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare cessate duration effect
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);

    // This will create the placable
    string sResRef = "phs_ropetrickrope";

    // Destroy the original targeted item
    DestroyObject(oTarget);

    // Create it
    object oRope = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lTarget);

    // We set the caster on the rope
    SetLocalObject(oRope, "PHS_ROPE_CREATOR", oCaster);
    // Set times cast on the rope
    int nTimesCast = PHS_IncreaseStoredInteger(oCaster, "PHS_ROPE_TRICK_TIMES_CAST");
    SetLocalInt(oRope, "PHS_ROPE_TIMESCAST", nTimesCast);

    // Apply effect to caster for duration
    PHS_ApplyDuration(oCaster, eCessate, fDuration);
}
