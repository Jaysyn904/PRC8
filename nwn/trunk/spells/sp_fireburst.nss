/////////////////////////////////////////////////////////////////////
//
// Firestorm - Burst of fire centered on the caster doing 1d8/lvl,
// max 5d8
//
/////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"
#include "spinc_burst"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    // Get the number of damage dice.
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDice = nCasterLvl;
    if (nDice > 5) nDice = 5;

    DoBurst (nCasterLvl,8, 0, nDice, VFX_IMP_FLAME_M, VFX_IMP_FLAME_S, 2.0f,
             DAMAGE_TYPE_FIRE, DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE, TRUE);
}
