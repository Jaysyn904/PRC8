/*:://////////////////////////////////////////////
//:: Spell Name Floating Disk
//:: Spell FileName PHS_S_FloatDisk
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Close (8M) Effect: 3-ft.-diameter disk of force
    Duration: 1 hour/level

    You create a slightly concave, circular plane of force that follows you about
    and carries loads for you. The disk is 3 feet in diameter and 1 inch deep at
    its center. It can hold the equivilant of 100lbs of weight per caster level
    The disk floats approximately 3 feet above the ground at all times and
    remains level. It floats along horizontally within spell range and will
    accompany you at a rate of no more than walking speed each round. If not
    otherwise directed, it maintains a constant interval of 5 feet between itself
    and you. The disk winks out of existence when the spell duration expires.
    The disk also winks out if you move beyond range. When the disk winks out,
    whatever it was supporting falls to the surface beneath it.

    Material Component: A drop of mercury.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It has its hown HB file, to check the stuff, for the creature. More then
    once can be summoned, of course.

    Also note that anything extra dropped will be just be removed.

    As it is not added to the PC's own party, the creature deosn't need
    strength increases (its strength is set to 50).

    It can be attacked, and has DC 2/+1 and 10HP.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_FLOATING_DISK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare effects - it can only be directly "dispelled".
    effect eDiskDur = EffectVisualEffect(PHS_VFX_DUR_FLOATING_DISK);
    effect eDiskDam = EffectDamageReduction(2, DAMAGE_POWER_PLUS_ONE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDiskDur, eDiskDam);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Create the floating disk
    object oDisk = CreateObject(OBJECT_TYPE_CREATURE, "phs_floatdisk", lTarget);

    // Check if valid.
    if(GetIsObjectValid(oDisk))
    {
        // Set master
        SetLocalObject(oDisk, "PHS_MASTER", oCaster);
        // Set weight limit - 100/level. Note: 1000/level here, because of
        // GetWeight.
        SetLocalInt(oDisk, "PHS_WEIGHT_LIMIT", nCasterLevel * 1000);
        // Apply effects to the creature
        PHS_ApplyDuration(oDisk, eLink, fDuration);
    }
}
