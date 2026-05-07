//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: March 2003: Removed movement speed penalty

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
   // effect eSpeed = EffectMovementSpeedDecrease(50);
    effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = eVis2; //EffectLinkEffects(eSpeed, eVis2);
    float fDelay;
    //Capture the first target object in the shape.
	object aoeCreator = GetAreaOfEffectCreator();
    oTarget = GetEnteringObject();
    
    int nPenetr = SPGetPenetrAOE(aoeCreator);
	
	// Check Extraordinary Spell Aim  
    if(GetHasFeat(FEAT_EXTRAORDINARY_SPELL_AIM, aoeCreator)  
    && GetIsFriend(oTarget, aoeCreator))  
    {  
        string sTargetID = ObjectToString(oTarget);  
        if(!GetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID))  
        {  
            if(GetIsSkillSuccessful(aoeCreator, SKILL_SPELLCRAFT, 25 + PRCGetSpellLevel(aoeCreator, SPELL_INCENDIARY_CLOUD)))  
            {  
                SetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID, TRUE);  
                return; // Target excluded  
            }  
        }  
    }
	
    //Declare the spell shape, size and the location.
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD));
        //Make SR check, and appropriate saving throw(s).
        if(!PRCDoResistSpell(aoeCreator, oTarget,nPenetr, fDelay))
        {
            fDelay = PRCGetRandomDelay(0.5, 2.0);
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
            //Adjust damage for Reflex Save, Evasion and Improved Evasion
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, PRCGetSaveDC(oTarget, aoeCreator, SPELL_INCENDIARY_CLOUD), SAVING_THROW_TYPE_FIRE, aoeCreator);
            // Apply effects to the currently selected target.
            eDam = PRCEffectDamage(oTarget, nDamage, GetLocalInt(OBJECT_SELF, "IC_Damage"));
            if(nDamage > 0)
            {
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                PRCBonusDamage(oTarget);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
       // SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
