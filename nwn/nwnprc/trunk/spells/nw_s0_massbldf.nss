//::///////////////////////////////////////////////
//:: Mass Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: Update Pass By: Preston W, On: Aug 2, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

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
    
    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    effect eBlind =  EffectBlindness();
    effect eDeaf = EffectDeaf();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link the blindness and deafness effects
    effect eLink = EffectLinkEffects(eBlind, eDeaf);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eXpl = EffectVisualEffect(VFX_FNF_BLINDDEAF);
    //Check for metamagic extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
         nDuration = nDuration * 2;
    }
    
    int nPenetr = CasterLvl + SPGetPenetr();
    
    //Play area impact VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eXpl, PRCGetSpellTargetLocation());
    //Get the first target in the spell area
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, PRCGetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && PRCGetIsAliveCreature(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_BLINDNESS_AND_DEAFNESS));
            //Make SR check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
            {
                int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                //Make Fort save
                if (!/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (nDC)))
                {
                    //Apply the linked effects and the VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
        //Get next object in spell area
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, PRCGetSpellTargetLocation());
    }
    


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
