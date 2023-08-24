//::///////////////////////////////////////////////
//:: Name      Pyrotechnics on Enter
//:: FileName  sp_pyrotechnicsA.nss
//:://////////////////////////////////////////////
/**@file Pyrotechnics
Transmutation
Level: Brd 2, Sor/Wiz 2 
Components: V, S, M 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Duration: 1d4+1 rounds after creatures leave the smoke cloud; see text 
Saving Throw: Fortitude negates
Spell Resistance: No

Smoke Cloud: A writhing stream of smoke billows out 
from the source, forming a choking cloud. The cloud
spreads 20 feet in all directions and lasts for 1 
round per caster level. All sight, even darkvision,
is ineffective in or through the cloud. All within 
the cloud take -4 penalties to Strength and Dexterity
(Fortitude negates). These effects last for 1d4+1 rounds 
after the cloud dissipates or after the creature leaves 
the area of the cloud. Spell resistance does not apply.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
        object oPC = GetAreaOfEffectCreator();
        object oTarget = GetEnteringObject();
        int nDC = PRCGetSaveDC(oTarget, oPC);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        effect eLink = EffectLinkEffects(EffectBlindness(), EffectAbilityDecrease(ABILITY_STRENGTH, 4));
        eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 4));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BLACKOUT));
        
        //Fort save
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
        {
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, TRUE, SPELL_PYROTECHNICS_SMOKE, nCasterLvl);
        }
}
                
                