/*:://////////////////////////////////////////////
//:: Spell Name Cloudkill
//:: Spell FileName SMP_S_Cloudkill
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Sor/Wiz 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Cloud spreads in 6.7-M. radius
    Duration: 1 min./level
    Saving Throw: Fortitude partial; see text
    Spell Resistance: No

    This spell generates a bank of fog, similar to a fog cloud, except that its
    vapors are yellowish green and poisonous. These vapors automatically kill any
    living creature with 3 or fewer HD (no save). A living creature with 4 to
    6 HD is slain unless it succeeds on a Fortitude save (in which case it takes
    1d4 points of Constitution damage on your turn each round while in the cloud).

    A living creature with 6 or more HD takes 1d4 points of Constitution damage
    on your turn each round while in the cloud (a successful Fortitude save
    halves this damage). Holding one’s breath doesn’t help, but creatures immune
    to poison are unaffected by the spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As changed spell description. Only requires a heartbeat check.

    There is NO moving.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    // Duration in rounds
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Impact VFX  (Same as 258)
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
    effect eAOE = EffectAreaOfEffect(SMP_AOE_PER_CLOUDKILL);

    // Apply effects
    SMP_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
