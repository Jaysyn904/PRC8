//::///////////////////////////////////////////////
//:: Deep Slmber
//:: sp_deepslumber
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Goes through the area and sleeps the lowest 2d4
    HD of creatures first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 7 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    object oLowest;
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eSleep =  EffectSleep();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);

    effect eLink = EffectLinkEffects(eSleep, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

     // * Moved the linking for the ZZZZs into the later code
     // * so that they won't appear if creature immune

    int bContinueLoop;
    int nHD = 10 + d10();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = 9;// maximun hd creature affected
    int nLow;
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    

    int nDuration = CasterLvl;
    nDuration = 3 + PRCGetScaledDuration(nDuration, oTarget);
    int nPenetr = CasterLvl + SPGetPenetr();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);
    //Enter Metamagic conditions
    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
    {
        nHD = 20;//Damage is at max
    }
    if ((nMetaMagic & METAMAGIC_EMPOWER))
    {
        nHD = nHD + (nHD/2); //Damage/Healing is +50%
    }
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    nDuration += 2;
    //Get the first target in the spell area
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation());
    //If no valid targets exists ignore the loop
    if (GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.
    while ((nHD > 0) && (bContinueLoop))
    {
        nLow = nMax;
        bContinueLoop = FALSE;
        //Get the first creature in the spell area
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            //Make faction check to ignore allies
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
                && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT 
                && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
            {
                //Get the local variable off the target and determined if the spell has already checked them.
                bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!bAlreadyAffected)
                {
                     //Get the current HD of the target creature
                     nCurrentHD = GetHitDice(oTarget);
                     //Check to see if the HD are lower than the current Lowest HD stored and that the
                     //HD of the monster are lower than the number of HD left to use up.
                     if(nCurrentHD < nLow 
                        && nCurrentHD <= nHD 
                        && (nCurrentHD < 11 || GetPRCSwitch(PRC_SLEEP_NO_HD_CAP)))
                     {
                         nLow = nCurrentHD;
                         oLowest = oTarget;
                         bContinueLoop = TRUE;
                     }
                }
            }
            //Get the next target in the shape
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, PRCGetSpellTargetLocation());
        }
        //Check to see if oLowest returned a valid object
        if(oLowest != OBJECT_INVALID)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLEEP));
            //Make SR check
            if (!PRCDoResistSpell(OBJECT_SELF, oLowest,nPenetr))
            {
                int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                //Make Fort save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oLowest, (nDC), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest);
                    if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE)
                    {
                        effect eLink2 = EffectLinkEffects(eLink, eVis);
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oLowest, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                    }
                    else
                    // * even though I am immune apply just the sleep effect for the immunity message
                    {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oLowest, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                    }

                }
            }
        }
        //Set a local int to make sure the creature is not used twice in the pass.  Destroy that variable in
        //.3 seconds to remove it from the creature
        SetLocalInt(oLowest, sSpellLocal, TRUE);
        DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
        DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
        //Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
    

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
