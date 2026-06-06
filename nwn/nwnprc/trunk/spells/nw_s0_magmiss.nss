    //::///////////////////////////////////////////////
//:: Magic Missile
//:: NW_S0_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 10, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 8, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode())
        return;
        
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nCasterLvl = CasterLvl;
    int nDamage = 0;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCnt;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    int nMissiles = (nCasterLvl + 1)/2;
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;

    CasterLvl +=SPGetPenetr();
    int nClass = GetLevelByClass(CLASS_TYPE_FMM);
    if (GetIsObjectValid(PRCGetSpellCastItem())) nClass = 0; // The FMM boosts don't apply to wands/scrolls/etc.
    if (nClass >= 3)
        CasterLvl += 2;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
        //Limit missiles to five
        if (nMissiles > 5)
            nMissiles = 5;
        
        // Force missile mage adds a bonus missile at 1st and 5th levels
        if (nClass) nMissiles++;
        if (nClass >= 5) nMissiles++;        
        
        //Make SR Check
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
        {
            //Apply a single damage hit for each missile instead of as a single mass
            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                //Roll damage
                int nDam = d4(1) + 1;
                //Enter Metamagic conditions
                if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                      nDam = 5;//Damage is at max
                if ((nMetaMagic & METAMAGIC_EMPOWER))
                      nDam = nDam + nDam/2; //Damage/Healing is +50%

                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;

                //Apply the MIRV and damage effect
                nDam += SpellDamagePerDice(OBJECT_SELF, 1);
                effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_FORCE);
                DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,0.0f,FALSE));
                DelayCommand(fDelay2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
             }
         }
         else
         {
            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            }
         }
     }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
