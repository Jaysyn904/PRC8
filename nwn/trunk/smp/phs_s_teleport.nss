/*:://////////////////////////////////////////////
//:: Spell Name Teleport
//:: Spell FileName PHS_S_Teleport
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Teleportation)
    Level: Sor/Wiz 5, Travel 5
    Components: V
    Casting Time: 1 standard action
    Range: Personal and touch
    Target: You and allied creatures within a 5M-radius sphere; see text
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    This spell instantly transports you to a designated destination. Interplanar
    travel is not possible. You can bring along objects as long as their weight
    doesn’t exceed your maximum load. You may also bring one additional willing
    Medium or smaller creature (carrying gear or objects up to its maximum load)
    or its equivalent (see below) per three caster levels. A Large creature
    counts as two Medium creatures, a Huge creature counts as two Large
    creatures, and so forth. All creatures to be transported must be within 5M
    of you at the time of casting, and must be in your party to suceed. As with
    all spells where the range is personal and the target is you, you need not
    make a saving throw, nor is spell resistance applicable to you.

    You must have some clear idea of the location and layout of the destination.
    The clearer your mental image, the more likely the teleportation works.
    Areas of strong physical or magical energy may make teleportation more
    hazardous or even impossible.

    To see how well the teleportation works, roll d% and consult the Teleport
    table. Refer to the following information for definitions of the terms on
    the table.

    Familiarity: “Very familiar” is a place where you have been very often and
    where you feel at home. “Studied carefully” is a place you know well, either
    because you can currently see it, you’ve been there often, or you have used
    other means (such as scrying) to study the place for at least one hour.
    “Seen casually” is a place that you have seen more than once but with which
    you are not very familiar. “Viewed once” is a place that you have seen once,
    possibly using magic.

    “False destination” is a place that does not truly exist or if you are
    teleporting to an otherwise familiar location that no longer exists as such
    or has been so completely altered as to no longer be familiar to you. When
    traveling to a false destination, roll 1d20+80 to obtain results on the
    table, rather than rolling d%, since there is no real destination for you
    to hope to arrive at or even be off target from.

    On Target: You appear where you want to be.

    Off Target: You appear safely a random distance away from the destination
    in a random direction. Distance off target can be anywhere in the target
    area. The direction off target is determined randomly.

    Similar Area: You wind up in an area that’s visually or thematically similar
    to the target area. Generally, you appear in the closest similar place
    within range. If no such area exists within the spell’s range, the spell
    simply fails instead.

    Mishap: You and anyone else teleporting with you have gotten “scrambled.”
    You each take 1d10 points of damage, and you reroll on the chart to see
    where you wind up. For these rerolls, roll 1d20+80. Each time “Mishap” comes
    up, the characters take more damage and must reroll.

    Familiarity                 On Target  Off Target  Similar Area  Mishap
    Very familiar               01-97      98-99       100           -
    Studied carefully           01-94      95-97       98-99         100
    Seen casually               01-88      89-94       95-98         99-100
    Viewed once                 01-76      77-88       89-96         97-100
    False destination (1d20+80) -          -           81-92         93-100
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Trying to make it as accurate as possible to the spell, and should maybe
    work as intended to (with mishaps and whatever).

    Need to have a local integer on an area for it to ever be considered
    "Very familiar", and you must still study it as below.

    You have to study an area for it to be "studied carefully" which is done
    in a cutscene, so the caster can only cancle it. Note: Any hostile creatures
    who come during the time auto-cancle it, of course! :-)

    These are set on the caster item under the tags of the area. Locations
    must be set up each time they enter the area, but might not require any
    studying.

    There can be up to 5 locations "pre-stored" on the caster item to teleport
    too.

    Areas can also be named maybe? Maybe that is how to get a false destination...

    Seen once can be included as, perhaps, using On Enter events...

    God, this might turn out to be complicated! Very much so!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// After the people to teleport have been got (and stored in PHS_TELEPORT_ARRAY)
// then the familiarity is put in, and it will roll to see what result is put
// out (and doing damage, as it will loop on a mishap).
int GetRandomResult(int nFamiliarity, object oCaster);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_TELEPORT)) return;

    // Delcare Major Variables
    object oCaster = OBJECT_SELF;
    location lSelf = GetLocation(OBJECT_SELF);
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellID = GetSpellId();
    // Get the spell target location
    location lTarget = GetLocalLocation(OBJECT_SELF, "TELEPORT_STORED_LOCATION");

    // Define location and effect to use.
    effect eGo = EffectVisualEffect(VFX_FNF_TELEPORT_IN);
    effect eAppear = EffectVisualEffect(VFX_FNF_TELEPORT_OUT);

    // Can we teleport there?
    if(!PHS_CannotTeleport(oCaster, lTarget)) return;

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_TELEPORT, FALSE);

    // Apply AOE go visual
    PHS_ApplyLocationVFX(lSelf, eGo);

    // Move the caster to that location
    ClearAllActions();
    DelayCommand(0.1, ActionJumpToLocation(lTarget));
    DelayCommand(0.2, PHS_ApplyLocationVFX(lTarget, eAppear));
}
