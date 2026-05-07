//::///////////////////////////////////////////////
//:: Blade Barrier: Heartbeat
//:: NW_S0_BladeBarA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oTarget;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
	object aoeCreator = GetAreaOfEffectCreator();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level");
    int nLevel = CasterLvl;
    //Make level check
    if (nLevel > 20)
    {
        nLevel = 20;
    }

    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);
    

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // Add damage to placeables/doors now that the command support bit fields
    //--------------------------------------------------------------------------
    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);

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

    while(GetIsObjectValid(oTarget))
    {
		// Check Extraordinary Spell Aim  
        if(GetIsObjectValid(aoeCreator) && GetHasFeat(FEAT_EXTRAORDINARY_SPELL_AIM, aoeCreator))  
        {  
            string sTargetID = ObjectToString(oTarget);  
            if(!GetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID))  
            {  
                if(GetIsFriend(oTarget, aoeCreator))  
                {  
                    if(GetIsSkillSuccessful(aoeCreator, SKILL_SPELLCRAFT, 25 + PRCGetSpellLevel(aoeCreator, SPELL_BLADE_BARRIER)))  
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
            //Fire spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(aoeCreator, SPELL_BLADE_BARRIER));
            //Make SR Check
            if (!PRCDoResistSpell(aoeCreator, oTarget, CasterLvl) )
            {
                int nDC = PRCGetSaveDC(oTarget, aoeCreator);
                //Roll Damage
                int nDamage = d6(nLevel);
                //Enter Metamagic conditions
                if((nMetaMagic & METAMAGIC_MAXIMIZE))
                {
                    nDamage = nLevel * 6;//Damage is at max
                }
                if ((nMetaMagic & METAMAGIC_EMPOWER))
                {
                    nDamage = nDamage + (nDamage/2);
                }
                nDamage += SpellDamagePerDice(aoeCreator, nLevel);
                // 1.69 change
                //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, PRCGetSaveDC(oTarget,aoeCreator),SAVING_THROW_TYPE_SPELL);
                //Set damage effect
                eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_SLASHING);
                //Apply damage and VFX 
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
     }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}

