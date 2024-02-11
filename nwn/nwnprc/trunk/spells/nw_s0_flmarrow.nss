//::///////////////////////////////////////////////
//:: Flame Arrow
//:: NW_S0_FlmArrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a stream of fiery arrows at the selected
    target that do 4d6 damage per arrow.  1 Arrow
    per 4 levels is created.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 20, 2001
//:: Updated By: Georg Zoeller, Aug 18 2003: Uncapped
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

#include "prc_inc_sp_tch"
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);
    int nSaveType = ChangedSaveType(EleDmg);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDist = GetDistanceBetween(oCaster, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);

    int nDamage;
    int nCnt;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    //Limit missiles to five
    int nMissiles = nCasterLvl / 4;
    if(nMissiles == 0)
        nMissiles = 1;
    /* Uncapped because PHB doesn't list any cap and we now got epic levels
    else if (nMissiles > 5)
        nMissiles = 5;*/

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FLAME_ARROW));
        //Apply a single damage hit for each missile instead of as a single mass
        //Make SR Check
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
        {
            int iAttackRoll = 0;
            for(nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                // causes them each to make a ranged touch attack
                iAttackRoll = PRCDoRangedTouchAttack(oTarget);
                if(iAttackRoll > 0)
                {
                    //Roll damage
                    nDamage = d6(4);
                    //Enter Metamagic conditions
                    if(nMetaMagic & METAMAGIC_MAXIMIZE)
                        nDamage = 24;//Damage is at max
                    if(nMetaMagic & METAMAGIC_EMPOWER)
                        nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
					nDamage += SpellDamagePerDice(oCaster, 4);
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType);

                    // only add sneak attack damage and bonus damage to first projectile
                    if(nCnt == 1)
                    {
                        nDamage += SpellSneakAttackDamage(oCaster, oTarget);
                        PRCBonusDamage(oTarget);
                    }

                    //Set damage effect
                    effect eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
                    //Apply the MIRV and damage effect
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
                }
            }
        }
        else
            // * May 2003: Make it so the arrow always appears, even if resisted
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
    }
    PRCSetSchool();
}