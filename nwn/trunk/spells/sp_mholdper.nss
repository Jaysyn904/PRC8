#include "prc_inc_spells"

#include "prc_add_spell_dc"
int BiowareHoldPerson (int nPenetr, int nCasterLvl, int nMeta, object oTarget, float fDelay);

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;
    
    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
    
    // Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();

    // Get the effective caster level.
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nPenetr = nCasterLvl+SPGetPenetr();

    // Apply a fancy effect for such a high level spell.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), lTarget);
    
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDelay;
    
    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    int nTargets = 0;
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);
        
        // Run the Bioware hold person script on the target, if the target is a valid target for the script increment
        // our target count and check to see if we've used up all our targets, if we have then exit out of the loop.
        if (BiowareHoldPerson (nPenetr,nCasterLvl, nMetaMagic, oTarget, fDelay)) nTargets++;
        if (nTargets >= nCasterLvl) break;
        
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    
    PRCSetSchool();
}



//::///////////////////////////////////////////////
//:: This function is a cut and past of the bioware hold person logic, with the 
//:: changes of having it's effect delayed by fDelay and returning whether the target
//:: was a valid target or not.
//:://////////////////////////////////////////////

int BiowareHoldPerson (int nPenetr, int nCasterLvl, int nMeta, object oTarget, float fDelay)
{
    int nValidTarget = 0;
    
    //Declare major variables
//    int nDuration = nCasterLvl;
//    nDuration = PRCGetScaledDuration(nDuration, oTarget);
    float fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(PRCGetScaledDuration(nCasterLvl, oTarget)));
    effect eParal = EffectParalyze();
    effect eVis = EffectVisualEffect(82);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    
    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur3);

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        PRCSignalSpellEvent(oTarget);
        
        //Make sure the target is a humanoid
        if (GetIsPlayableRacialType(oTarget) ||
            MyPRCGetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
            MyPRCGetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
            MyPRCGetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
            MyPRCGetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN)
        {
            nValidTarget = 1;
            
            //Make SR Check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
            {
                //Make Will save
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF)))
                {
                    //Make metamagic extend check
//                    if (nMeta & METAMAGIC_EXTEND)
//                    {
//                        nDuration = nDuration * 2;
//                    }
                    //Apply paralyze effect and VFX impact
//                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCasterLvl));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,nCasterLvl));
                }
            }
        }
    }
    
    return nValidTarget;
}
