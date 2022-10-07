/*:://////////////////////////////////////////////
//:: Spell Name Darkness
//:: Spell FileName PHS_S_Darkness
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Darkness]
    Level: Brd 2, Clr 2, Sor/Wiz 2
    Components: V, M/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 10 min./level (D)
    Saving Throw: None
    Spell Resistance: No

    This spell causes a creature to radiate shadowy illumination out to a 6.67-M
    radius. If you target a non-friendly target, then you must make a melee
    touch attack to hit them. All creatures in the area gain concealment (20%
    miss chance). Even creatures that can normally see in such conditions (such
    as with darkvision or low-light vision) have the miss chance in an area
    shrouded in magical darkness.

    Normal lights (torches, candles, lanterns, and so forth) are incapable of
    brightening the area. Higher level light spells can dispel or counter
    darkness.

    Darkness counters or dispels light and Flare. To dispel such spell, target
    an affected creature.

    Arcane Material Component: A bit of bat fur and either a drop of pitch or a
    piece of coal.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Darkness AOE is put onto the creature targeted. If the creature is an non-friend,
    then it requires a touch attack, if a friend then it doesn't.

    Touch range spell.

    AOE mearly applies a 20% consealment bonus. Note that if they have Daylight
    applied to them, then it cannot be consealed as the effects negate each
    other.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DARKNESS)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration - 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_DARKNESS);

    // Check faction rating
    int nTouch = TRUE;
    if(!(GetIsFriend(oTarget) || GetFactionEqual(oTarget)))
    {
        // Not a friend, as such, thus we do a touch attack
        nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget);
    }

    // Do we hit?
    if(nTouch)
    {
        // Apply effects
        PHS_ApplyDuration(oTarget, eAOE, fDuration);
    }
}
