//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
//:: NW_S0_WallFireA.nss
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

//:: modified by mr_bumpkin  Dec 4, 2003
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
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nPenetr = SPGetPenetrAOE(oCaster);

    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
	
	// Check Extraordinary Spell Aim  
    if(GetHasFeat(FEAT_EXTRAORDINARY_SPELL_AIM, oCaster)  
    && GetIsFriend(oTarget, oCaster))  
    {  
        string sTargetID = ObjectToString(oTarget);  
        if(!GetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID))  
        {  
            if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 25 + PRCGetSpellLevel(oCaster, SPELL_WALL_OF_FIRE)))  
            {  
                SetLocalInt(OBJECT_SELF, "ExtraordinarySpellAim_" + sTargetID, TRUE);  
                return; // Target excluded  
            }  
        }  
    }  
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));
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
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (PRCGetSaveDC(oTarget, oCaster)), SAVING_THROW_TYPE_FIRE);
            if(nDamage > 0)
            {
                // Apply effects to the currently selected target.
                eDam = PRCEffectDamage(oTarget, nDamage, GetLocalInt(OBJECT_SELF, "Wall_Fire_Damage"));
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                PRCBonusDamage(oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
