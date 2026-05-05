/*
    nw_s0_healharm

    Heal/Harm in the one script

    By: Flaming_Sword
    Created: Jun 14, 2006
    Modified: Nov 21, 2006

    Consolidation of heal/harm scripts
    Mass Heal vfx on target looks like heal
    added greater harm, mass harm
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_inc_function"
#include "prc_add_spell_dc"
#include "inc_dispel"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nSpellID)
{
    int bIsHeal = IsHeal(nSpellID);  //whether it is a heal or harm spell
    int bMass = IsMassHealHarm(nSpellID);
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nHealVFX, nHurtVFX, nEnergyType, nDice, iBlastFaith, nHeal;
    float fRadius;
    string nSwitch;
    int nCap = 150;
    if(bIsHeal)
    {
        nHealVFX = VFX_IMP_HEALING_X;
        nHurtVFX = VFX_IMP_SUNSTRIKE;
        nEnergyType = DAMAGE_TYPE_POSITIVE;
        nSwitch = PRC_BIOWARE_HEAL;
        fRadius = RADIUS_SIZE_COLOSSAL;
        if(nSpellID == SPELL_MASS_HEAL)
        {
            nSwitch = PRC_BIOWARE_MASS_HEAL;
            nCap = 250;
        }
    }
    else
    {
        nHealVFX = VFX_IMP_HEALING_G;
        nHurtVFX = 246;
        nEnergyType = DAMAGE_TYPE_NEGATIVE;
        nSwitch = PRC_BIOWARE_HARM;
        fRadius = RADIUS_SIZE_HUGE;
    }
    int iHeal;
    int iAttackRoll = 1;
    if((nSpellID == SPELL_MASS_HARM) || (nSpellID == SPELL_GREATER_HARM))
    {
        nDice = (nCasterLevel > 20) ? 20 : nCasterLevel;
        nHeal = d12(nDice);
        if((nMetaMagic & METAMAGIC_MAXIMIZE) || BlastInfidelOrFaithHeal(oCaster, oTarget, nEnergyType, TRUE))
            nHeal = 12 * nDice; //in case higher level spell slots are available
    }
    else
    {
        nHeal = 10 * nCasterLevel;
    }
    if(nHeal > nCap && !GetPRCSwitch(nSwitch))
        nHeal = nCap;
    location lLoc;
    if(bMass)
    {
        lLoc = (nSpellID == SPELL_MASS_HARM) ? GetLocation(oCaster) : PRCGetSpellTargetLocation();
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(bIsHeal ? VFX_FNF_LOS_HOLY_30 : VFX_FNF_LOS_EVIL_20), lLoc);
    }
    float fDelay = 0.0;
    
    while(GetIsObjectValid(oTarget))
    {
        if(bMass) fDelay = PRCGetRandomDelay();
        int iTombTainted = GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD;
		
		// Signal placeables even if they're not creatures  
		if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)  
		{  
			SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));  
		}
        
        iHeal = GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
                ((!bIsHeal && (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || iTombTainted)) ||
                (bIsHeal && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && !iTombTainted));
		if (GetLocalInt(oTarget, "AcererakHealing")) iHeal = TRUE;
                
        if(iHeal && (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster) || (GetIsDead(oTarget) && (GetCurrentHitPoints(oTarget) > -10))))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
            
            //Warforged are only healed for half, none if they have Improved Fortification
            if(GetIsWarforged(oTarget)) nHeal /= 2;
            if(GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oTarget)) nHeal = 0;
            
            
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHeal, oTarget), oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nHealVFX), oTarget));
            // Code for FB to remove damage that would be caused at end of Frenzy
            SetLocalInt(oTarget, "PC_Damage", 0);
        }
        else if((GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && !bIsHeal) ||
                (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !iHeal))
        {
            if(!GetIsReactionTypeFriendly(oTarget) && oTarget != oCaster)
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));
                iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
                if(iAttackRoll)
                {
                    if (!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
                    {
                        int nModify = d4();
                        iBlastFaith = BlastInfidelOrFaithHeal(oCaster, oTarget, nEnergyType, TRUE);
                        if((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith)
                        {
                            nModify = 1;
                        }
                        if((nSpellID == SPELL_MASS_HARM) || (nSpellID == SPELL_GREATER_HARM))
                        {
                            nHeal = d12(nDice);
                            if((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith)
                                nHeal = 12 * nDice;
                                
                            nHeal += SpellDamagePerDice(oCaster, nDice);    
                        }
                        else
                        {
                            nHeal = 10 * nCasterLevel;
                        }
                        if(nHeal > nCap && !GetPRCSwitch(nSwitch))
                            nHeal = nCap;

                        if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
                        {
                            nHeal /= 2;
                            if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                                nHeal = 0;
                        }
                        int nHP = GetCurrentHitPoints(oTarget);
                        if (nHeal > nHP - nModify)
                            nHeal = nHP - nModify;
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nHeal, nEnergyType), oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nHurtVFX), oTarget));
                    }
                }
            }
        }
        if(!bMass) break;
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
    }
    //Spell Removal Check
    SpellRemovalCheck(oCaster, oTarget);
    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (DEBUG) DoDebug("nw_s0_healharm running "+IntToString(GetIsPC(OBJECT_SELF)));
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if(X2PreSpellCastCode())
    {
        object oCaster = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
        if(!nEvent) //normal cast
        {
            if (DEBUG )DoDebug("nw_s0_healharm running normal casting");
            if(IsTouchSpell(nSpellID) && GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
            {   //holding the charge, casting spell on self
                SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
                if (DEBUG) DoDebug("nw_s0_healharm running returning");
                return;
            }
            if (DEBUG) DoDebug("nw_s0_healharm running DoSpell");
            DoSpell(oCaster, oTarget, nSpellID);
        }
        else
        {
            if (DEBUG) DoDebug("nw_s0_healharm running else casting");
            if(nEvent & PRC_SPELL_EVENT_ATTACK)
            {
                if(DoSpell(oCaster, oTarget, nSpellID))
                    DecrementSpellCharges(oCaster);
            }
        }
    }
    PRCSetSchool();
}