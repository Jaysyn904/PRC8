//::///////////////////////////////////////////////
//:: Sihlbrane's Grove
//:: Regenerate Moderate Wounds
//:: 00_S0_REGSW
//:://////////////////////////////////////////////
/*
    Regenerate 3 HP per round for 10 rounds +
    caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Yaballa
//:: Created On: 7/9/2003
//:://////////////////////////////////////////////

#include "pg_ss_spelltwk"
#include "x2_inc_spellhook"
//#include "x0_i0_spells"
#include "prc_inc_spells"

void main()
{
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oTarget = PRCGetSpellTargetObject();
    int nRace = MyPRCGetRacialType(oTarget);
    int nMetamagic = PRCGetMetaMagicFeat();
    if((nRace != RACIAL_TYPE_CONSTRUCT) || (nRace != RACIAL_TYPE_UNDEAD))
    {
        PRCRemoveEffectsFromSpell(oTarget, GetSpellId());
        RegenerateWounds(3, oTarget, nMetamagic);
    }
}
