//::///////////////////////////////////////////////
//:: Ice Dagger
//:: X2_S0_IceDagg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a dagger shapped piece of ice that
// flies toward the target and deals 1d4 points of
// cold damage per level (maximum od 5d4)
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25 , 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nDice = min(nCasterLvl, 5);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_COLD);
    int nSaveType = ChangedSaveType(EleDmg);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ICE_DAGGER));
        //Get the distance between the explosion and the target to calculate delay
        float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

        int iAttackRoll = PRCDoRangedTouchAttack(oTarget);
        if(iAttackRoll > 0)
        {
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Roll damage for each target
                int nDamage = d4(nDice);
                //Resolve metamagic
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDamage = 4 * nDice;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDamage += nDamage / 2;
				nDamage += SpellDamagePerDice(oCaster, nDice);
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (PRCGetSaveDC(oTarget, oCaster)), nSaveType);

                if(nDamage)
                {
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

                    ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, EleDmg);
                    PRCBonusDamage(oTarget);
                }
            }
        }
    }
    PRCSetSchool();
}