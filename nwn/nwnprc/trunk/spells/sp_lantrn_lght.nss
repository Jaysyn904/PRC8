//::///////////////////////////////////////////////
//:: Name      Lantern Light
//:: FileName  sp_lantrn_lght.nss
//:://////////////////////////////////////////////
/**@file Lantern Light
Evocation [Good, Light]
Level: Cleric 1, paladin 1, sorcerer/wizard 1, vassal
of Bahamut 1
Components: S, Abstinence
Casting Time: 1 standard action
Range: Close (25ft + 5ft/2 leves)
Effect: Ray
Duration: 1 round/level 
Saving Throw: None
Spell Resistance: Yes 

Rays of holy light flash from your eyes.  You can fire
1 ray per 2 caster levels, but no more than 1 ray per
round.  You must succeed on a ranged touch attack to
hit a target,  The target takes 1d6 points of damage
from each ray.  

Abstinance: You must obstain from sexual intercourse
for 24 hours before casting this spell.

Author:    Tenjac
Created:   7/12/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
        int nMetaMagic = PRCGetMetaMagicFeat();
        
        //INSERT SPELL CODE HERE
        int iAttackRoll = 0;    //placeholder
        
        iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
        if (iAttackRoll > 0)
        {               
                //Touch attack code goes here
                int nDam = d6(1);
                
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                {
                        nDam = 6;
                }
                
                if(nMetaMagic & METAMAGIC_EMPOWER)
                {
                        nDam += (nDam/2);
                }
                nDam += SpellDamagePerDice(oCaster, 1);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
        }
        return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void DoSpell2(object oTarget, int nRays, object oPC)
{
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nCnt;
        
        // Fire those rays
        for (nCnt = 1; nCnt <= nRays; nCnt++)
        {
            int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
            if (iAttackRoll > 0)
            {               
                int nDam = d6(1);
                
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDam = 6;                
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDam += (nDam/2);
                nDam += SpellDamagePerDice(oPC, 1);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
            }
        }
}

void main()
{
        object oCaster = OBJECT_SELF;
        int nCasterLevel = PRCGetCasterLevel(oCaster);
        PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
        if (!X2PreSpellCastCode()) return;
        object oTarget = PRCGetSpellTargetObject();
        int nRays = (nCasterLevel/2);
        int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
        if(!nEvent) //normal cast
        {
                if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
                {   //holding the charge, casting spell on self
                	SetLocalSpellVariables(oCaster, nRays);   //change 1 to number of charges
                	return;
                }
                
                DoSpell2(oTarget, nRays, oCaster);
                if(DEBUG) DoDebug("sp_lantrn_lght: DoSpell2 Fired.");
        }
        else
        {
                if(nEvent & PRC_SPELL_EVENT_ATTACK)
                {
                        if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                        DecrementSpellCharges(oCaster);
                        
                        if(DEBUG) DoDebug("sp_lantrn_lght: DoSpell Fired.");
                }
        }
        PRCSetSchool();
}