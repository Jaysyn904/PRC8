/*:://////////////////////////////////////////////
//:: Spell Name Repulsion
//:: Spell FileName PHS_S_Repulsion
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 7, Protection 7, Sor/Wiz 6
    Components: V, S, F/DF
    Casting Time: 1 standard action
    Range: 3.33M. (15 ft.)
    Area: 3.33-M.-radius (15 ft.) emanation, centered on you
    Duration: 1 round/level (D)
    Saving Throw: Will negates
    Spell Resistance: Yes

    An invisible, mobile field surrounds you and prevents creatures from
    approaching you. You decide how big the field is at the time of casting
    (to the limit your level allows). Any creature within or entering the field
    must attempt a save. If it fails, it becomes unable to move toward you for
    the duration of the spell. Repelled creatures’ actions are not otherwise
    restricted.

    They can fight other creatures and can cast spells and attack you with
    ranged weapons. If you move closer to an affected creature, nothing happens.
    (The creature is not forced back.) The creature is free to make melee
    attacks against you if you come within reach. If a repelled creature moves
    away from you and then tries to turn back toward you, it cannot move any
    closer if it is still within the spell’s area.

    Arcane Focus: A pair of small iron bars attached to two small canine
    statuettes, one black and one white, the whole array worth 50 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    How does this work, we wonder, eh?

    Well, since creatures come in all shapes and sizes, it is pretty hard. The
    game might not make it work right.

    At the moment it is 5M sphere, this means:

    - One sphere at 1M
    - One sphere at 2M
    ...
    - One sphere at 5M

    The 5M sphere has a special On Enter script. The rest all have a script which
    checks locals on the target, and caster, to see if they should push back.

    Note; To make sure that the caster can't push people back, a check for
    GetCurrentAction() is done and ActionMoveToPoint(). Also, instead of it
    collapsing when it is used hostility, it only prevents it working, so if
    they do move, we set it to not work for a few seconds too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_REPULSION)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF.
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Set times cast now
    PHS_IncreaseStoredInteger(oTarget, "PHS_REPULSION_TIMES_CAST");

    // Duration in 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects. All 5 of them.
    effect eMob1 = EffectAreaOfEffect(PHS_AOE_MOB_REPULSION_1);
    effect eMob2 = EffectAreaOfEffect(PHS_AOE_MOB_REPULSION_2);
    effect eMob3 = EffectAreaOfEffect(PHS_AOE_MOB_REPULSION_3);
    effect eMob4 = EffectAreaOfEffect(PHS_AOE_MOB_REPULSION_4);
    effect eMob5 = EffectAreaOfEffect(PHS_AOE_MOB_REPULSION_5);

    // Link them
    effect eLink = EffectLinkEffects(eMob1, eMob2);
    eLink = EffectLinkEffects(eLink, eMob3);
    eLink = EffectLinkEffects(eLink, eMob4);
    eLink = EffectLinkEffects(eLink, eMob5);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_REPULSION, oTarget);

    // Set local integer so that the first ones will not be affected, which
    // is removed after 1.0 seconds.
    string sLocal = PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_REPULSION);
    SetLocalInt(oCaster, sLocal, TRUE);
    DelayCommand(1.0, DeleteLocalInt(oCaster, sLocal));

    // Apply effects
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
