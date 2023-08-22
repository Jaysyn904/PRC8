//::///////////////////////////////////////////////
//:: Name      Pyrotechnics on Exit
//:: FileName  sp_pyrotechnicsB.nss
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

void main()
{
        object oTarget = GetExitingObject();
        effect eTest = GetFirstEffect(oTarget);
        float fDelay = RoundsToSeconds(d4(1) + 1);
        
        while (GetIsEffectValid(eTest))
        {
                if(GetEffectCreator(eTest) == GetAreaOfEffectCreator())
                {
                        if(GetEffectSpellId(eTest) == SPELL_PYROTECHNICS_SMOKE)
                        {
                                DelayCommand(fDelay, RemoveEffect(oTarget, eTest));
                        }
                }
                eTest = GetNextEffect(oTarget);
        }
}
                                
                        
                        
                        
        