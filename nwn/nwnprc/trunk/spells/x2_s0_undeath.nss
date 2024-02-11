//::///////////////////////////////////////////////
//:: Undeath to Death
//:: x2_s0_undeath.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Necromancy
Level:        Clr 6, Sor/Wiz 6
Components:   V, S, M/DF
Area:         Several undead creatures within
              a 40-ft.-radius burst
Saving Throw: Will negates

This spell functions like circle of death, except
that it destroys undead creatures as noted above.

Material Component
The powder of a crushed diamond worth at least 500 gp.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On:  August 13,2003
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"
#include "prc_add_spell_dc"


//const int SRROR_CODE_5_FIX = 1;

void DoUndeadToDeath(object oCreature, object oCaster, int nPenetr)
{
    SignalEvent(oCreature, EventSpellCastAt(oCaster, SPELL_UNDEATH_TO_DEATH));

    SetLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD", TRUE);

    int nSaveDC = PRCGetSaveDC(oCreature, oCaster);
    if(!PRCMySavingThrow(SAVING_THROW_WILL, oCreature, nSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
    {
        float fDelay = PRCGetRandomDelay(0.2f,0.4f);
        if(!PRCDoResistSpell(oCaster, oCreature, nPenetr, fDelay))
        {
            effect eDeath = PRCEffectDamage(oCreature, GetCurrentHitPoints(oCreature), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay+0.5f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oCreature));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCreature));
        }
        else
        {
            DelayCommand(1.0f, DeleteLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD"));
        }
   }
   else
   {
       DelayCommand(1.0f, DeleteLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD"));
   }
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    // calculation
    object oCaster = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nLevel = nCasterLvl > 20 ? 20 : nCasterLvl;

    // calculate number of hitdice affected
    int nHDLeft = d4(nLevel);
    //Enter Metamagic conditions
    if(nMetaMagic & METAMAGIC_MAXIMIZE)
        nHDLeft = 4 * nLevel;//Damage is at max
    if(nMetaMagic & METAMAGIC_EMPOWER)
        nHDLeft += (nHDLeft/2); //Damage/Healing is +50%

    // Impact VFX
    location lLoc = PRCGetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY),lLoc);
    //TLVFXPillar(VFX_FNF_LOS_HOLY_20, lLoc, 3, 0.0f);

    // build list with affected creatures
    int nLow = 9999;
    object oLow;
    int nCurHD;
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 20.0f, lLoc);
    while(GetIsObjectValid(oTarget) && nHDLeft > 0)
    {
        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            nCurHD = GetHitDice(oTarget);
            if (nCurHD <= nHDLeft)
            {
                if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
                {
                    // ignore creatures already affected
                    if(GetLocalInt(oTarget,"X2_EBLIGHT_I_AM_DEAD") == 0 && !GetPlotFlag(oTarget) && !GetIsDead(oTarget))
                    {
                        // store the creature with the lowest HD
                        if(GetHitDice(oTarget) <= nLow)
                        {
                            nLow = GetHitDice(oTarget);
                            oLow = oTarget;
                        }
                    }
                }
            }
        }
        // Get next target
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, 20.0f ,lLoc);

        // End of cycle, time to kill the lowest creature
        if(!GetIsObjectValid(oTarget))
        {
            // we have a valid lowest creature we can affect with the remaining HD
            if (GetIsObjectValid(oLow) && nHDLeft >= nLow)
            {
                DoUndeadToDeath(oLow, oCaster, nPenetr);
                // decrement remaining HD
                nHDLeft -= nLow;
                // restart the loop
                oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 20.0f, lLoc);
            }
            // reset counters
            oLow = OBJECT_INVALID;
            nLow = 9999;
        }
    }
    PRCSetSchool();
}