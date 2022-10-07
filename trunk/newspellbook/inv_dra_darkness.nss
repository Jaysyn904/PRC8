//::///////////////////////////////////////////////
//:: Name      Darkness
//:: FileName  inv_dra_darkness.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You can create magical darkness in a 20' radius.
All creatures within the darkness can only see in
it using Ultravision, True Seeing, blindsense, or
blindsight.

*/
//::///////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItemTarget = oTarget;
    int nCasterLevel = GetInvokerLevel(oCaster, GetInvokingClass());
    int iAttackRoll = 1;
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);

    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {   //touch attack roll if target creature is not an ally
        if(!spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
            iAttackRoll = PRCDoMeleeTouchAttack(oTarget);

        if(iAttackRoll > 0)
        {
            oItemTarget = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
            if(!GetIsObjectValid(oTarget))
            {
                //no armor, check other slots
                int i;
                for(i=0;i<14;i++)
                {
                    oItemTarget = GetItemInSlot(i, oTarget);
                    if(GetIsObjectValid(oTarget))
                        break;//end for loop
                }
            }
        }
    }
    int nCasterLvl = nCasterLevel;
    int  nDuration = nCasterLvl;//10min/level for PnP

    //Create an instance of the AOE Object using the Apply Effect function
    //placeables get an effect
    //or if no equipment
    if(!GetPRCSwitch(PRC_PNP_DARKNESS))
    {
        if (iAttackRoll > 0)
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oTarget), RoundsToSeconds(nDuration));
    }
    else if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE
        || !GetIsObjectValid(oItemTarget))
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCasterLvl);
    else
    {
        //otherwise items get an IP
        itemproperty ipDarkness = ItemPropertyAreaOfEffect(IP_CONST_AOE_DARKNESS, nCasterLvl);
        IPSafeAddItemProperty(oItemTarget, ipDarkness, TurnsToSeconds(nDuration*10));
        //this applies the effects relating to it
        DelayCommand(0.1, VoidCheckPRCLimitations(oItemTarget, OBJECT_INVALID));
    }
}