//::///////////////////////////////////////////////
//:: Name      Utterdark OnEnter
//:: FileName  sp_utterdarkA.nss
//:://////////////////////////////////////////////
/**@file Utterdark
Conjuration (Creation) [Evil] 
Level: Darkness 8, Demonic 8, Sor/Wiz 9
Components: V, S, M/DF 
Casting Time: 1 hour 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 100-ft./level radius spread, centered on caster
Duration: 1 hour/level 
Saving Throw: None 
Spell Resistance: No

Utterdark spreads from the caster, creating an area
of cold, cloying magical darkness. This darkness is
similar to that created by the deeper darkness spell,
but no magical light counters or dispels it. 
Furthermore, evil aligned creatures can see in this 
darkness as if it were simply a dimly lighted area.

Arcane Material Component: A black stick, 6 inches 
long, with humanoid blood smeared upon it.

Author:    Tenjac
Created:   5/21/06

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        PRCSetSchool(SPELL_SCHOOL_CONJURATION);
        
        object oTarget = GetEnteringObject();
        object oPC = GetAreaOfEffectCreator();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDuration = (nCasterLvl * 600.0f);
        
        effect eLink = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
               eLink = EffectLinkEffects(eLink, EffectUltravision());
        effect eDark = EffectDarkness();
                
                                
        //if valid                     and not caster
        if(GetIsObjectValid(oTarget) && oTarget != oPC)
        {
                if(GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL)
                {
                        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDark, oTarget);
                }
                
                else
                {
                        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                }       
        }
        PRCSetSchool();
}
                        
                        