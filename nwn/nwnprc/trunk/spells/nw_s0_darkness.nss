/*
    nw_s0_darkness

    Creates a globe of darkness around those in the area
    of effect.

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: June 12, 2006

    Flaming_Sword: Added touch attack roll
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_inc_itmrstr"
#include "prc_add_spell_dc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    //Declare major variables including Area of Effect Object
    int iAttackRoll = 1;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nPnP = GetPRCSwitch(PRC_PNP_DARKNESS);
    float fDuration = nPnP ? TurnsToSeconds(nCasterLevel * 10) : RoundsToSeconds(nCasterLevel);//10min/level for PnP
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);

    //Make sure duration does no equal 0
    if(fDuration < 6.0f)
        fDuration = 6.0f;

    //Check Extend metamagic feat.
    if(nMetaMagic & METAMAGIC_EXTEND)
       fDuration *= 2;

	int nShadow = PRCMax(GetLocalInt(oCaster, "ShadowMantle_Shoulder"), GetLocalInt(oTarget, "ShadowMantle_Shoulder"));
	if (nShadow) nPnP = FALSE;
	if (DEBUG) DoDebug("nw_s0_darkness: oCaster "+GetName(oCaster)+" oTarget "+GetName(oTarget)+" nSwitch "+IntToString(nPnP));

    if(!nPnP)
    {
        if (nShadow)
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration);
        else
        	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, PRCGetSpellTargetLocation(), fDuration);

        object oAoE = GetAreaOfEffectObject(GetSpellTargetLocation(), "VFX_PER_DARKNESS");
        SetAllAoEInts(SPELL_DARKNESS, oAoE, PRCGetSpellSaveDC(SPELL_DARKNESS, SPELL_SCHOOL_EVOCATION), 0, nCasterLevel);
    }
    else
    {
        object oItemTarget = oTarget;
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {   //touch attack roll if target creature is not an ally
            // ally = friendly or party member
            if(!spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
                iAttackRoll = PRCDoMeleeTouchAttack(oTarget);

            if(iAttackRoll > 0)
            {
                oItemTarget = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
                if(!GetIsObjectValid(oItemTarget))
                {
                    //no armor, check other slots
                    int i;
                    for(i=0;i<14;i++)
                    {
                        oItemTarget = GetItemInSlot(i, oTarget);
                        if(GetIsObjectValid(oItemTarget))
                            break;//end for loop
                    }
                }
            }
        }
        else if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration, TRUE, -1, nCasterLevel);

            object oAoE = GetAreaOfEffectObject(GetSpellTargetLocation(), "VFX_PER_DARKNESS");
            SetAllAoEInts(SPELL_DARKNESS, oAoE, PRCGetSpellSaveDC(SPELL_DARKNESS, SPELL_SCHOOL_EVOCATION), 0, nCasterLevel);
        }
        // If nothing is valid
        else if (!GetIsObjectValid(oItemTarget) && !GetIsObjectValid(oItemTarget))
        {
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, PRCGetSpellTargetLocation(), fDuration);

            object oAoE = GetAreaOfEffectObject(GetSpellTargetLocation(), "VFX_PER_DARKNESS");
            SetAllAoEInts(SPELL_DARKNESS, oAoE, PRCGetSpellSaveDC(SPELL_DARKNESS, SPELL_SCHOOL_EVOCATION), 0, nCasterLevel);        
        }
        else
        {
            //otherwise items get an IP
            itemproperty ipDarkness = ItemPropertyAreaOfEffect(IP_CONST_AOE_DARKNESS, nCasterLevel);
            IPSafeAddItemProperty(oItemTarget, ipDarkness, fDuration);
            //this applies the effects relating to it
            DelayCommand(0.1, VoidCheckPRCLimitations(oItemTarget, OBJECT_INVALID));
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    if(!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}