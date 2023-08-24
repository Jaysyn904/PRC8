//::///////////////////////////////////////////////
//:: War Cry
//:: NW_S0_WarCry
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The bard lets out a terrible shout that gives
    him a +2 bonus to attack and damage and causes
    fear in all enemies that hear the cry
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

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
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    

    int nLevel = CasterLvl;
    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(2, DAMAGE_TYPE_SLASHING);
    effect eFear = EffectFrightened();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect eVisFear = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eLOS;
    if(GetGender(OBJECT_SELF) == GENDER_FEMALE)
    {
        eLOS = EffectVisualEffect(290);
    }
    else
    {
        eLOS = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
    }

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eDur2);

    effect eLink2 = EffectLinkEffects(eVisFear, eFear);
    eLink = EffectLinkEffects(eLink, eDur);

    //Meta Magic
    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
    {
       nLevel *= 2;
    }
    
    int nPenetr = CasterLvl + SPGetPenetr();
    
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLOS, OBJECT_SELF);
    //Determine enemies in the radius around the bard
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
           int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY));
           //Make SR and Will saves
           if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr)  && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (nDC), SAVING_THROW_TYPE_FEAR))
            {
                DelayCommand(0.01,SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(4),TRUE,-1,CasterLvl));
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    //Apply bonus and VFX effects to bard.
    PRCRemoveSpellEffects(PRCGetSpellId(),OBJECT_SELF,OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    DelayCommand(0.01,SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nLevel),TRUE,-1,CasterLvl));
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY, FALSE));

 
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
