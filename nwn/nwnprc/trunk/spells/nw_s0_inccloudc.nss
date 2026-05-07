//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloudC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Objects within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Updated By: GeorgZ 2003-08-21: Now affects doors and placeables as well

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
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
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    float fDelay;
    //Capture the first target object in the shape.

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
     object aoeCreator = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(aoeCreator))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int CasterLvl = PRCGetCasterLevel(aoeCreator);

    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);
    
    int EleDmg = GetLocalInt(OBJECT_SELF, "IC_Damage");


    //oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
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
                    if(GetIsSkillSuccessful(aoeCreator, SKILL_SPELLCRAFT, 25 + PRCGetSpellLevel(aoeCreator, SPELL_INCENDIARY_CLOUD)))  
                    {  
                        SetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID, TRUE);  
                        // Target is excluded, skip to next  
                        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
                        continue;  
                    }  
                }  
            }  
        }
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
        {
            fDelay = PRCGetRandomDelay(0.5, 2.0);
            //Make SR check, and appropriate saving throw(s).
            if(!PRCDoResistSpell(aoeCreator, oTarget,nPenetr, fDelay))
            {
                SignalEvent(oTarget, EventSpellCastAt(aoeCreator, SPELL_INCENDIARY_CLOUD));
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
                nDamage += SpellDamagePerDice(aoeCreator, 4);
                int nDC = PRCGetSaveDC(oTarget,aoeCreator);
                //Adjust damage for Reflex Save, Evasion and Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC,SAVING_THROW_TYPE_FIRE, aoeCreator);
                // Apply effects to the currently selected target.
                eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
                if(nDamage > 0)
                {
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    PRCBonusDamage(oTarget);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        //oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
