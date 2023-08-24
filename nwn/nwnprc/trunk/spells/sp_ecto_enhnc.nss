//::///////////////////////////////////////////////
//:: Name      Ectoplasmic Enhancement
//:: FileName  sp_ecto_enhnc.nss
//:://////////////////////////////////////////////
/**@file Ectoplasmic Enhancement 
Necromancy [Evil]
Level: Sor/Wiz 6 
Components: V, S 
Casting Time: 1 full round 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One incorporeal undead/level
Duration: 24 hours 
Saving Throw: None 
Spell Resistance: No

The undead affected by this spell gain a +1 
deflection bonus to Armor Class, +1d8 temporary 
hit points, a +1 enhancement bonus on attack rolls,
and a +2 bonus to turn resistance. Each of these
enhancements increases by +1 for every three caster
levels. So a 12th level caster grants a +5 
deflection bonus to AC, an extra 1d8+4 temporary
hit points, a +5 enhancement bonus on attack rolls,
and a +6 bonus to turn resistance. 

Author:    Tenjac
Created:   5/9/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        //vars
        object oPC = OBJECT_SELF;
        location lLoc = PRCGetSpellTargetLocation();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nBonus = max((nCasterLvl/3), 1);
        int nRace; 
        
        //Spellhook
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);
                
        //loop
        while(GetIsObjectValid(oTarget))
        {
                nRace = MyPRCGetRacialType(oTarget);
                //Check for incorporeal undead
                if(nRace == RACIAL_TYPE_UNDEAD)
                {                        
                        if(GetIsIncorporeal(oTarget))
                        {                       
                                effect eLink = EffectACIncrease(nBonus, AC_DEFLECTION_BONUS);
                                eLink = EffectLinkEffects(eLink, EffectTurnResistanceIncrease(nBonus + 1));
                                eLink = EffectLinkEffects(eLink, EffectTemporaryHitpoints(d8(1) + nBonus - 1));
                                eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonus));
                                eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PARALYZED));
                                
                                //Apply for 1 day
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24));
                        }
                        
                        else
                        {
                                SendMessageToPC(oPC, "Target creature is not incorporeal.");
                        }
                }                
                else
                {
                        SendMessageToPC(oPC, "Target creature is not undead.");
                        return;
                }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);        
        }        
        //SPEvilShift(oPC);
        PRCSetSchool();
}      