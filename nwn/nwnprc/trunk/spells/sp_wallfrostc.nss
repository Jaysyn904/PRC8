//::///////////////////////////////////////////////
//:: Wall of Frost: Heartbeat
//:: SP_WallFrostC.nss
//:: 
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 cold damage
    per round.
*/
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage;
    effect eDam;
	object oCaster = GetAreaOfEffectCreator();
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    //Capture the first target object in the shape.

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int CasterLvl = PRCGetCasterLevel(oCaster);
    
    int nPenetr = SPGetPenetrAOE(oCaster,CasterLvl);
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_COLD);

    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
		// Check Extraordinary Spell Aim  
        if(GetIsObjectValid(oCaster) && GetHasFeat(FEAT_EXTRAORDINARY_SPELL_AIM, oCaster))  
        {  
            string sTargetID = ObjectToString(oTarget);  
            if(!GetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID))  
            {  
                if(GetIsFriend(oTarget, oCaster))  
                {  
                    if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 25 + PRCGetSpellLevel(oCaster, GetSpellId())))  
                    {  
                        SetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID, TRUE);  
                        // Target is excluded, skip to next  
                        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);  
                        continue;  
                    }  
                }  
            }  
        }  
		
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Make SR check, and appropriate saving throw(s).
            if(!PRCDoResistSpell(oCaster, oTarget,nPenetr))
            {
                //Roll damage.
                nDamage = d6(4);
                //Enter Metamagic conditions
                if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                {
                   nDamage = 24;//Damage is at max
                }
                if ((nMetaMagic & METAMAGIC_EMPOWER))
                {
                     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                
                nDamage += SpellDamagePerDice(oCaster, 4);
                
                int nDC = PRCGetSaveDC(oTarget, oCaster);

                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (nDC), SAVING_THROW_TYPE_COLD);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    PRCBonusDamage(oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0,FALSE);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
