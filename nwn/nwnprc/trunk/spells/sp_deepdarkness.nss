/*
    sp_deepdarkness

    Creates a globe of darkness around those in the area
    of effect.
    As darkness but bigger & longer

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: Jul 1, 2006
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_inc_itmrstr"

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
    float fDuration = nPnP ? HoursToSeconds(nCasterLevel * 24) : TurnsToSeconds(nCasterLevel);//1day/level for PnP
    effect eAOE = EffectAreaOfEffect(AOE_PER_DEEPER_DARKNESS);

    //Make sure duration does no equal 0
    if(fDuration < 6.0f)
        fDuration = 6.0f;

    //Check Extend metamagic feat.
    if(nMetaMagic & METAMAGIC_EXTEND)
       fDuration *= 2;

    if(!nPnP)
    {
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, PRCGetSpellTargetLocation(), fDuration);
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

        if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE || !GetIsObjectValid(oItemTarget))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration, TRUE, -1, nCasterLevel);
        }
        else
        {
            //otherwise items get an IP
            itemproperty ipDarkness = ItemPropertyAreaOfEffect(IP_CONST_AOE_DEEPER_DARKNESS, nCasterLevel);
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