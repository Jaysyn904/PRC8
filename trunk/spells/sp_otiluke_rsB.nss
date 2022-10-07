//::///////////////////////////////////////////////
//:: Name      Otiluke's Resilient Sphere On Exit
//:: FileName  sp_otiluke_rsB.nss
//:://////////////////////////////////////////////
/**@file Otiluke's Resilient Sphere
Evocation [Force]
Level: Sor/Wiz 4
Components: V, S, M
Range: Short
Effect: Sphere, centered around a creature
Duration:       1 min./level (D)
Saving Throw:   Reflex negates
Spell Resistance:       Yes

A globe of shimmering force encloses a creature within
the diameter of the sphere. The sphere contains its 
subject for the spell’s duration. The sphere is not
subject to damage of any sort except from a rod of
cancellation, a rod of negation, a disintegrate spell,
or a targeted dispel magic spell. These effects destroy
the sphere without harm to the subject. Nothing can
pass through the sphere, inside or out, though the 
subject can breathe normally.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
        object oCaster = GetAreaOfEffectCreator();
        object oTarget = GetExitingObject();
        
        if(GetLocalInt(oTarget, "PRC_OTILUKES_RS_TARGET"))
        {
                //Delete it
                DeleteLocalInt(oTarget, "PRC_OTILUKES_RS_TARGET");
                
                if(!GetLocalInt(oTarget, "PRC_OTILUKES_RS_ALREADYPLOT"))
                {
                        SetPlotFlag(oTarget, 0);
                }
                
                effect eToDispel = GetFirstEffect(oTarget);
               
               while(GetIsEffectValid(eToDispel))
                {
                        if(GetEffectSpellId(eToDispel) == SPELL_OTILUKES_RESILIENT_SPHERE)
                        {
                                RemoveEffect(oTarget, eToDispel);
                        }
                        
                        eToDispel = GetNextEffect(oTarget);
                }
        }
}