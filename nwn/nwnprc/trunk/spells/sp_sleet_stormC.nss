//::///////////////////////////////////////////////
//:: Name      Sleet Storm Heartbeat
//:: FileName  sp_sleet_stormC.nss
//:://////////////////////////////////////////////
/**@file Sleet Storm

Conjuration (Creation) [Cold]
Level: Drd 3, Sor/Wiz 3 
Components: V, S, M/DF 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Area: Cylinder (40-ft. radius, 20 ft. high) 
Duration: 1 round/level 
Saving Throw: None 
Spell Resistance: No

Driving sleet blocks all sight (even darkvision) 
within it and causes the ground in the area to be
icy. A creature can walk within or through the 
area of sleet at half normal speed with a DC 10 
Balance check. Failure means it can’t move in that
round, while failure by 5 or more means it falls 
(see the Balance skill for details).

The sleet extinguishes torches and small fires.

Arcane Material Component: A pinch of dust and a 
few drops of water.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

int BalanceCheckFailure(object oTarget);

#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);
    int nCasterLvl = PRCGetCasterLevel(GetAreaOfEffectCreator());

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(oTarget))
    {
        if(CheckMasteryOfShapes(GetAreaOfEffectCreator(), oTarget))
        {
            // Target is protected by Mastery of Shaping.
            oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
            continue;
        }

        int nFail = BalanceCheckFailure(oTarget);

        //Can't move
        if(nFail == 1)
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEntangle(), oTarget, 6.0f, TRUE, SPELL_SLEET_STORM, nCasterLvl) ;
        //Fall
        else if(nFail == 2)
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 6.0f, TRUE, SPELL_SLEET_STORM, nCasterLvl) ;

        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
    PRCSetSchool();
}

int BalanceCheckFailure(object oTarget)  
{  
    int nResult = 0;  
    int nRoll = GetSkillRank(SKILL_BALANCE, oTarget) + d20(1);  
    int nTumble = GetSkillRank(SKILL_TUMBLE, oTarget);  
  
    //if 5 or more ranks of Tumble, +2 bonus  
    if(nTumble > 4) nRoll += 2;  
  
    //All fails  
    if(nRoll < 10)  
    {  
        //if failed by 5 or more  
        if((10 - nRoll) < 6) nResult = 2;  
  
        //otherwise it failed by less than 5  
        else nResult = 1;  
    }  
    return nResult;  
}
