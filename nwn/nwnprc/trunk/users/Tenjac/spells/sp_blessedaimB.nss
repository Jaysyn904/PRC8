//::///////////////////////////////////////////////
//:: Name      Blessed Aim On Exit
//:: FileName  sp_blessedaimB.nss
//:://////////////////////////////////////////////
/**@file 

Author:    Tenjac
Created:   1/27/21
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
        object oCaster = GetAreaOfEffectCreator();
        object oTarget = GetExitingObject();  
        
        effect eToDispel = GetFirstEffect(oTarget);
        
        while(GetIsEffectValid(eToDispel))
        {
        	if(GetEffectSpellId(eToDispel) == SPELL_BLESSED_AIM)

                        {
                                RemoveEffect(oTarget, eToDispel);
                        }
                        
                        eToDispel = GetNextEffect(oTarget);
                }
        }
}