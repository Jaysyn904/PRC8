//::///////////////////////////////////////////////
//:: Blade Barrier: On Enter
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
    object oTarget = GetEnteringObject();
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
     object aoeCreator = GetAreaOfEffectCreator();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nLevel = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level");
    int CasterLvl = nLevel;

    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);
 
    //Make level check
    if (nLevel > 20)
    {
        nLevel = 20;
    }
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
    {
        //Fire spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(aoeCreator, SPELL_BLADE_BARRIER));
        //Roll Damage
        int nDamage = d6(nLevel);
        //Enter Metamagic conditions
        if ((nMetaMagic & METAMAGIC_MAXIMIZE))
        {
            nDamage = nLevel * 6;//Damage is at max
        }
        if ((nMetaMagic & METAMAGIC_EMPOWER))
        {
            nDamage = nDamage + (nDamage/2);
        }
        nDamage += SpellDamagePerDice(aoeCreator, nLevel);
        //Make SR Check
        if (!PRCDoResistSpell(aoeCreator, oTarget,nPenetr) )
        {
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


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

