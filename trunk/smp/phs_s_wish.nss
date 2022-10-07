/*:://////////////////////////////////////////////
//:: Spell Name Wish
//:: Spell FileName PHS_S_Wish
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Universal
    Level: Sor/Wiz 9
    Components: V, XP
    Casting Time: 1 standard action
    Range: See text
    Target, Effect, or Area: See text
    Duration: See text
    Saving Throw: See text
    Spell Resistance: Yes

    Wish is the mightiest spell a wizard or sorcerer can cast. By simply speaking aloud, you can alter reality to better suit you.

    Even wish, however, has its limits.

    A wish can produce any one of the following effects.

    • Duplicate any wizard or sorcerer spell of 8th level or lower, provided the
      spell is not of a school prohibited to you.
    • Duplicate any other spell of 6th level or lower, provided the spell is not
      of a school prohibited to you.
    • Duplicate any wizard or sorcerer spell of 7th level or lower even if it’s
      of a prohibited school.
    • Duplicate any other spell of 5th level or lower even if it’s of a
      prohibited school.
    • Undo the harmful effects of many other spells, such as geas/quest or
      insanity.
    • Create a nonmagical item of up to 25,000 gp in value.
    • Create a magic item, or add to the powers of an existing magic item.
    • Remove injuries and afflictions. A single wish can aid one creature per
      caster level, and all subjects are cured of the same kind of affliction.
      For example, you could heal all the damage you and your companions have
      taken, or remove all poison effects from everyone in the party, but not do
      both with the same wish. A wish can never restore the experience point loss
      from casting a spell or the level loss from being raised
      from the dead.
    • Revive the dead. A wish can bring a dead creature back to life by
      duplicating a resurrection spell. A wish can revive a dead creature whose
      body has been destroyed, but the task takes two wishes, one to recreate
      the body and another to infuse the body with life again. A wish cannot
      prevent a character who was brought back to life from losing an experience
      level.
    • Transport travelers. A wish can lift one creature per caster level from
      anywhere on any plane and place those creatures anywhere else on any plane
      regardless of local conditions. An unwilling target gets a Will save to
      negate the effect, and spell resistance (if any) applies.

    You may try to use a wish to produce greater effects than these, but doing
    so is dangerous. (The wish may pervert your intent into a literal but
    undesirable fulfillment or only a partial fulfillment.)

    Duplicated spells allow saves and spell resistance as normal (but save DCs
    are for 9th-level spells).

    Material Component: When a wish duplicates a spell with a material component
    that costs more than 10,000 gp, you must provide that component.

    XP Cost: The minimum XP cost for casting wish is 5,000 XP. When a wish
    duplicates a spell that has an XP cost, you must pay 5,000 XP or that cost,
    whichever is more. When a wish creates or improves a magic item, you must
    pay twice the normal XP cost for crafting or improving the item, plus an
    additional 5,000 XP.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Wether it is Miracle, or whatever, this is hard to doone way (make it text
    asking-based) and easy another (conversation) and needs DM support too (harder)
    Rating: 10

    The basis of the Genie functions are there. If there are no DM's, a genie
    is created and used for the "default" uses as stated in the spell description.

    - Wisdom and intelligence, although would be a somewhat good idea to use,
      are not needed. Basically, this will interpret specific demands for things
      from the default description.

    If there is a DM, I think timestop on a particular DM, and notifying them,
    would work fine...that DM can cancle its own effects using DM heal.

    NOTES:

    - All functions to do effects are in PHS_INC_WISH. This replaces the
      PHS_INC_SPELLS line.
    - To get if a school is against what they are using, we will check all thier
      prepared spells, and look for any missing spell schools (of those few
      which are opposition schools), and use that to see what they can cast.
    - No undo misfortune
    - The Djinni will fake cast for some things (teleport others), and SR checks
      will be very basic (Who the hell has resistance to wish anyway?!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_WISH"

const string PHS_WISH_DJINNI = "phs_wishdjinni";

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WISH)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PHS_GetCasterLevel();

    // Check experience
    if(!PHS_ComponentXPCheck(5000, oCaster)) return;

    // Signal spell cast at
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_WISH, FALSE);

    // Create the genie if no DM's are on
    if(PHS_GetIsDMPlaying())
    {
        SpeakString("SMP Placeholder: DM Wish");
    }
    else
    {
        // For targeting, we need PHS_WishSetLOS(), so that the spell knows
        // if a placable ETC is in the wishers LOS, and can be targeted.
        PHS_WishSetLOS();

        // Create the Djinni (Ginie)
        // * Spawn script, Conversation Script does all the things.
        object oDjinni = CreateObject(OBJECT_TYPE_CREATURE, PHS_WISH_DJINNI, GetLocation(oCaster));
        SetLocalObject(oDjinni, "PHS_WISHER", oCaster);
    }
}
