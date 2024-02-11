/*:://////////////////////////////////////////////
//:: Spell Name Mount
//:: Spell FileName PHS_S_Mount
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Summoning)
    Level: Sor/Wiz 1
    Components: V, S, M
    Casting Time: 1 round
    Range: Close (8M)
    Effect: One mount
    Duration: 2 hours/level (D)
    Saving Throw: None
    Spell Resistance: No

    You summon a light horse or a pony (your choice) to serve you as a mount.
    The steed serves willingly and well. The mount comes with a bit and bridle
    and a riding saddle.

    Material Component: A bit of horse hair.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This would only work if we can summon a horse.

    Not going to obviously complete until got a horse!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MOUNT)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get duration - 2 hours/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 2, nMetaMagic);

    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Create the mount
    object oMount = CreateObject(OBJECT_TYPE_CREATURE, "phs_mount", lTarget);

    // Apply effects
    PHS_ApplyDuration(oMount, eCessate, fDuration);
}
