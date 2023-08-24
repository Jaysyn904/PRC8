//::///////////////////////////////////////////////
//:: Color Spray
//:: NW_S0_ColSpray.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of sparkling lights flashes out in a cone
    from the casters hands affecting all those within
    the Area of Effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"  
#include "prc_add_spell_dc"




void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);

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
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nHD;
    int nDuration;
    float fDelay;
    object oTarget;
    effect eSleep = EffectSleep();
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink1 = EffectLinkEffects(eSleep, eMind);

    effect eLink2 = EffectLinkEffects(eStun, eMind);
    eLink2 = EffectLinkEffects(eLink2, eDur);

    effect eLink3 = EffectLinkEffects(eBlind, eMind);

    effect eVis1 = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eVis2 = EffectVisualEffect(VFX_IMP_STUN);
    effect eVis3 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nPenetr = CasterLvl + SPGetPenetr();
    

    //Get first object in the spell cone
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 10.0, PRCGetSpellTargetLocation(), TRUE);
    //Cycle through the target until the current object is invalid
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
        && !PRCGetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget)
        && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COLOR_SPRAY));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/30;
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr, fDelay))
            {
                int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                      nDuration = 3 + d4();
                      //Enter Metamagic conditions
                      if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                      {
                         nDuration = 7;//Damage is at max
                      }
                      if ((nMetaMagic & METAMAGIC_EMPOWER))
                      {
                         nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
                      }
                      if ((nMetaMagic & METAMAGIC_EXTEND))
                      {
                         nDuration = nDuration *2;  //Duration is +100%
                      }

                    nHD = GetHitDice(oTarget);
                    if(nHD <= 2)
                    {
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
                         DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));
                    }
                    else if(nHD > 2 && nHD < 5)
                    {
                         nDuration = nDuration - 1;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
                         DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink3, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));                }
                    else
                    {
                         nDuration = nDuration - 2;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                         DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 10.0, PRCGetSpellTargetLocation(), TRUE);
    }
    
 

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

