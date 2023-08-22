//::///////////////////////////////////////////////
//:: Name      Unheavened
//:: FileName  sp_unheavened.nss
//:://////////////////////////////////////////////
/**@fileUnheavened
Abjuration [Evil]
Level: Sor/Wiz 2
Components: V, S, Drug
Casting Time: 1 action
Range: Touch
Target: One creature
Duration: 10 minutes/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

The caster grants one creature a +4 profane bonus on
saving throws made against any spell or spell-like
effect from a good outsider. This protection
manifests as a black and red nimbus of energy
visible around the subject. All celestial beings can
identify an unheavened nimbus on sight.

Drug Component: Vodare.

Author:    Tenjac
Created:   5/18/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //spellhook
    if(!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oPC);
    float fDur = (600.0f * nCasterLevel);

    //check for Vodare
    if(GetHasSpellEffect(SPELL_VODARE, oPC))
    {
        //Make sure the spell effect hangs around for the duration
        //to be checked by prc_add_spell_dc.nss

        //effect eVis = EffectVisualEffect(VFX_DUR_UNHEAVENED);
        effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur);
    }

    //SPEvilShift(oPC);
}
