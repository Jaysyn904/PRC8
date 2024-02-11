//::///////////////////////////////////////////////
//:: Cloudkill: Heartbeat
//:: NW_S0_CloudKillC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
//:: modified by Ornedan Dec 22, 2004 to PnP rules
#include "prc_inc_spells"
#include "prc_add_spell_dc"



void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);


    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage = d4();
    //effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    object oTarget;
    int nHD;
    float fDelay;

    //Enter Metamagic conditions
    if(nMetaMagic & METAMAGIC_MAXIMIZE)
    {
        nDamage = 4;//Damage is at max
    }
    if(nMetaMagic & METAMAGIC_EMPOWER)
    {
        nDamage =  nDamage + (nDamage/2); //Damage/Healing is +50%
    }

   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    object aoeCreator = GetAreaOfEffectCreator();
    int CasterLvl = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level");
    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);


    //Set damage effect
    //Get the first object in the persistant AOE
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        fDelay = PRCGetRandomDelay();
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , aoeCreator) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));

            nHD = GetHitDice(oTarget);

            //Apply VFX impact and damage
            //Creatures with less than 6 HD take full damage automatically
            //Any with more than 6 get to save (Fortitued) for half
            if (nHD < 6)
            {
                AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));
            }
            else
            {
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,aoeCreator)), SAVING_THROW_TYPE_SPELL, OBJECT_SELF))
                {
                    AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));
                }
                else
                {
                	if (GetHasMettle(oTarget, SAVING_THROW_FORT))
			// This script does nothing if it has Mettle, bail
				nDamage = 0;
                    // Halve the damage on succesfull save.
                    AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage / 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));
                }
            }
        }
        //Get the next target in the AOE
        oTarget = GetNextInPersistentObject();
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
