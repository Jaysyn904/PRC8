//::///////////////////////////////////////////////
//:: Creeping Doom: Heartbeat
//:: NW_S0_CrpDoomC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature caught in the swarm take an initial
    damage of 1d20, but there after they take
    1d6 per swarm counter on the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
	object aoeCreator	= GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    string sConstant1 = "NW_SPELL_CONSTANT_CREEPING_DOOM1" + ObjectToString(GetAreaOfEffectCreator());
    string sConstant2 = "NW_SPELL_CONSTANT_CREEPING_DOOM2" + ObjectToString(GetAreaOfEffectCreator());
    int nSwarm = GetLocalInt(OBJECT_SELF, sConstant1);
    int nDamCount = GetLocalInt(OBJECT_SELF, sConstant2);
    float fDelay;
    if(nSwarm < 1)
    {
        nSwarm = 1;
    }
   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(aoeCreator))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Get first target in spell area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget) && nDamCount < 1000)
    {
		// Check Extraordinary Spell Aim  
        if(GetIsObjectValid(aoeCreator) && GetHasFeat(FEAT_EXTRAORDINARY_SPELL_AIM, aoeCreator))  
        {  
            string sTargetID = ObjectToString(oTarget);  
            if(!GetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID))  
            {  
                if(GetIsFriend(oTarget, aoeCreator))  
                {  
                    if(GetIsSkillSuccessful(aoeCreator, SKILL_SPELLCRAFT, 25 + PRCGetSpellLevel(aoeCreator, SPELL_CREEPING_DOOM)))  
                    {  
                        SetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID, TRUE);  
                        // Target is excluded, skip to next  
                        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);  
                        continue;  
                    }  
                }  
            }  
        }		
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
        {
            fDelay = PRCGetRandomDelay(1.0, 2.2);

			SignalEvent(oTarget,EventSpellCastAt(aoeCreator, SPELL_CREEPING_DOOM, FALSE));
			//Roll Damage
			nDamage = d6(nSwarm);
			nDamage += SpellDamagePerDice(aoeCreator, nSwarm);
			//Set Damage Effect with the modified damage
			eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_PIERCING);
			//Apply damage and visuals
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			nDamCount = nDamCount + nDamage;

        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
    if(nDamCount >= 1000)
    {
        DestroyObject(OBJECT_SELF, 1.0);
    }
    else
    {
        nSwarm++;
        SetLocalInt(OBJECT_SELF, sConstant1, nSwarm);
        SetLocalInt(OBJECT_SELF, sConstant2, nDamCount);
    }

	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	// Getting rid of the local integer storing the spellschool name

}
