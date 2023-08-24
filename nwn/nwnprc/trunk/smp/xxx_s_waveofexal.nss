/*:://////////////////////////////////////////////
//:: Spell Name Wave Of Exaltation
//:: Spell FileName XXX_S_WaveOfExal
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Also known as: Elhiria’s Wave Of Exaltation
    Level: Brd 2, Sor/Wiz 2
    Components: V, S
    Casting Time: 1 standard action
    Range: 6.67M (20ft.)
    Area: Caster and 1 creature/level, in a 6.67M. burst (20ft.) centered on
                the caster
    Duration: 1 minute/level (D)
    Saving Throw: Fortitude Negates (Harmless)
    Spell Resistance: Yes (Harmless)
    Source: Various (VolkorTheRed)

    A wave starts at the point of origin of the spell and spreads out te envelop
    all affected allied creatures in a mantle of positive feelings and resolvement.

    The transmuted creatures’ skin becomes harder to penetrate by enemy weapons.
    The creatures  receive DR 1/Epic and get an +1 morale bonus on all saving
    throws.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says - DR 1/Epic, and +1 bonus on saving throws.

    Changed to +1 on saves, Saving Grace still has some potency then.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_WAVE_OF_EXALTATION)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    object oTargetDiamond;
    // 1 creature/level.
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCnt;

    // Note: This does increase by 1 if caster is affected
    int nDoneCreatures = 0;

    // 1 round/level duration
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eDR = EffectDamageReduction(1, DAMAGE_POWER_PLUS_TWENTY);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);

    // Link effects
    effect eLink = EffectLinkEffects(eDR, eDur);
    eLink = EffectLinkEffects(eLink, eSave);

    // Loop all targets without effect nearby. Start with the caster!
    oTarget = oCaster;
    // Loop for 6.67M or 20ft
    while(GetIsObjectValid(oTarget) && nDoneCreatures < nCasterLevel &&
          GetDistanceToObject(oTarget) <= RADIUS_SIZE_FEET_20)
    {
        // Make sure they are in our LOS, are a friend too.
        if((LineOfSightObject(oCaster, oTarget) &&
           (GetIsFriend(oTarget) || GetFactionEqual(oTarget))) ||
           (oTarget == oCaster))
        {
            // Add one to nDoneCreatures
            nDoneCreatures++;

            // Signal spell cast at event
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_WAVE_OF_EXALTATION, FALSE);

            // Remove previous castings
            SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_WAVE_OF_EXALTATION, oTarget);

            // Apply effects
            SMP_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
        }
        // Get next nearest target
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oCaster, nCnt);
    }
}
