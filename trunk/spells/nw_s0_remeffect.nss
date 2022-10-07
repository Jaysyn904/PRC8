/*
    nw_s0_remeffect

    Takes the place of
        Remove Disease
        Neutralize Poison
        Remove Paralysis
        Remove Curse
        Remove Blindness / Deafness

        Lesser Restoration
        Restoration
        Greater Restoration

        Panacea

    By: Preston Watamaniuk
    Created: Jan 8, 2002
    Modified: Jun 16, 2006

    Flaming_Sword: Added Restoration spells, cleaned up
    added panacea, attack roll before SR check
*/
const int SAVING_THROW_NONE = 4;

#include "inc_dispel"
#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

int GetIsSupernaturalCurse(effect eEff)
{
    return GetTag(GetEffectCreator(eEff)) == "q6e_ShaorisFellTemple";
}

// * generic area of effect constructor
void PRCGenericAreaOfEffect(
        object oCaster, location lTargetLoc,
        int nShape, float fRadiusSize, int nSpellID,
        effect eImpact, effect eLink, effect eVis,
        int nDurationType=DURATION_TYPE_INSTANT, float fDuration = 0.0,
        int nTargetType=SPELL_TARGET_ALLALLIES, int bHarmful = FALSE,
        int nRemoveEffectSpell=FALSE, int nRemoveEffect1=0, int nRemoveEffect2=0, int nRemoveEffect3=0,
        int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE,
        int bPersistentObject=FALSE, int bResistCheck=FALSE, int nSavingThrowType=SAVING_THROW_NONE,
        int nSavingThrowSubType=SAVING_THROW_TYPE_ALL
        )
{
    //Apply Impact
    if (GetEffectType(eImpact) != 0)
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTargetLoc);
    }

    object oTarget = OBJECT_INVALID;
    float fDelay = 0.0;

    int nPenetr = PRCGetCasterLevel(oCaster);


    //Get the first target in the radius around the caster
    if (bPersistentObject == TRUE)
        oTarget = GetFirstInPersistentObject();
    else
        oTarget = GetFirstObjectInShape(nShape, fRadiusSize, lTargetLoc, bLineOfSight, nObjectFilter);

    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, nTargetType, oCaster) == TRUE)
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, bHarmful));
            int nResistSpellSuccess = FALSE;
            // * actually perform the resist check
            if (bResistCheck == TRUE)
            {
                nResistSpellSuccess = PRCDoResistSpell(oCaster, oTarget,nPenetr);
            }
          if(!nResistSpellSuccess)
          {
                int nDC = PRCGetSaveDC(oTarget, oCaster);
                int nSavingThrowSuccess = FALSE;
                // * actually roll saving throw if told to
                if (nSavingThrowType != SAVING_THROW_NONE)
                {
                  nSavingThrowSuccess = PRCMySavingThrow(nSavingThrowType, oTarget, nDC, nSavingThrowSubType);
                }
                if (!nSavingThrowSuccess)
                {
                    fDelay = PRCGetRandomDelay(0.4, 1.1);



                    //Apply VFX impact
                    if (GetEffectType(eVis) != 0)
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }

                    // * Apply effects
                   // if (GetEffectType(eLink) != 0)
                   // * Had to remove this test because LINKED effects have no valid type.
                    {

                        DelayCommand(fDelay, ApplyEffectToObject(nDurationType, eLink, oTarget, fDuration));
                    }

                    // * If this is a removal spell then perform the appropriate removals
                    if (nRemoveEffectSpell == TRUE)
                    {
                        //Remove effects
                        PRCRemoveSpecificEffect(nRemoveEffect1, oTarget);
                        if(nRemoveEffect2 != 0)
                        {
                            PRCRemoveSpecificEffect(nRemoveEffect2, oTarget);
                        }
                        if(nRemoveEffect3 != 0)
                        {
                            PRCRemoveSpecificEffect(nRemoveEffect3, oTarget);
                        }

                    }
                }// saving throw
            } // resist spell check
        }
        //Get the next target in the specified area around the caster
        if (bPersistentObject == TRUE)
            oTarget = GetNextInPersistentObject();
        else
            oTarget = GetNextObjectInShape(nShape, fRadiusSize, lTargetLoc, bLineOfSight, nObjectFilter);

    }
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId();
    SpellRemovalCheck(oCaster, oTarget);
    int nVis;
    int iAttackRoll = TRUE;
    switch(nSpellID)
    {   //Setting visual effect
        case SPELL_GREATER_RESTORATION: nVis = VFX_IMP_RESTORATION_GREATER; break;
        case SPELL_RESTORATION: nVis = VFX_IMP_RESTORATION; break;
        case SPELL_LESSER_RESTORATION: nVis = VFX_IMP_RESTORATION_LESSER; break;
        default: nVis = VFX_IMP_REMOVE_CONDITION; break;
    }
    if(nSpellID == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS)
    {   //Remove Blindness and Deafness aoe hack largely untouched
        effect eLink;
        PRCGenericAreaOfEffect(OBJECT_SELF, PRCGetSpellTargetLocation(), SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,
            SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), eLink, EffectVisualEffect(nVis),
            DURATION_TYPE_INSTANT, 0.0,
            SPELL_TARGET_ALLALLIES, FALSE, TRUE, EFFECT_TYPE_BLINDNESS, EFFECT_TYPE_DEAF);
        return TRUE;
    }
    effect eEffect = GetFirstEffect(oTarget);
    if(!((nSpellID == SPELL_PANACEA) && (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)))
    {
        while(GetIsEffectValid(eEffect))
        {   //Effect removal - see prc_sp_func for list of effects removed
            if(CheckRemoveEffects(nSpellID, GetEffectType(eEffect)) && !GetIsSupernaturalCurse(eEffect) && (GetEffectSubType(eEffect) != SUBTYPE_EXTRAORDINARY) && !GetShouldNotBeRemoved(eEffect))
                RemoveEffect(oTarget, eEffect);
            eEffect = GetNextEffect(oTarget);
        }
    }
    if(nSpellID == SPELL_GREATER_RESTORATION && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD
    && !(GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
    {   //Greater Restoration healing
        int nHeal = 10 * nCasterLevel;
        if(nHeal > 250 && !GetPRCSwitch(PRC_BIOWARE_GRRESTORE))
            nHeal = 250;
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHeal, oTarget), oTarget);
        SetLocalInt(oTarget, "WasRestored", TRUE);
        DelayCommand(HoursToSeconds(1), DeleteLocalInt(oTarget, "WasRestored"));
    }
    if(nSpellID == SPELL_PANACEA)
    {
        int nAdd = (nCasterLevel > 20) ? 20 : nCasterLevel;
        if((MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
        && (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)))
        {
            PRCSignalSpellEvent(oTarget);
            if (!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
            {
                iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
                if (iAttackRoll)
                {
                    // Roll the damage (allowing for a critical) and let the target make a will save to
                    // halve the damage.
                    int nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_POSITIVE, 1 == iAttackRoll ? 1 : 2, 8, 0, nAdd);
                    if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF)))
                    {
                        nDamage /= 2;
                        if (GetHasMettle(oTarget, SAVING_THROW_WILL)) nDamage = 0;
                    }
                    // Apply damage and VFX.
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_POSITIVE), oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTarget);
                }
            }
        }
        else
        {
            // Roll the healing 'damage'.
            int nHeal = PRCGetMetaMagicDamage(DAMAGE_TYPE_POSITIVE, 1, 8, 0, nAdd);
            // Apply the healing and VFX.
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHeal, oTarget), oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oTarget);
        }
    }
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), oTarget);

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}