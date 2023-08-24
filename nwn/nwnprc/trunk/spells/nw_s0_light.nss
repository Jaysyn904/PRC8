/*
    nw_s0_light

    Applies a light source to the target for
    1 hour per level

    XP2
    If cast on an item, item will get temporary
    property "light" for the duration of the spell
    Brightness on an item is lower than on the
    continual light version.

    By: Preston Watamaniuk
    Created: Aug 15, 2001
    Modified: Jun 29, 2006

    Flaming_Sword: Cleaned up code
        added continual flame
*/

#include "prc_sp_func"
#include "prc_x2_craft"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId();
    int bLight = (nSpellID == SPELL_LIGHT);
    int nDuration = bLight ? nCasterLevel : 0;
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        nDuration = nDuration *2; //Duration is +100%

    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CIGetIsCraftFeatBaseItem(oTarget))
    {
        if (!IPGetIsItemEquipable(oTarget))
        {   // Item must be equipable...
            FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
            return TRUE;
        }
        itemproperty ip = ItemPropertyLight(bLight ? IP_CONST_LIGHTBRIGHTNESS_NORMAL : IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE);
        IPSafeAddItemProperty(oTarget, ip, HoursToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, !bLight, TRUE);
    }
    else
    {
        effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        if(!bLight) eLink = SupernaturalEffect(eLink);
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
        SPApplyEffectToObject(bLight ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,nCasterLevel);
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    //if(GetHasFeat(FEAT_SHADOWWEAVE,OBJECT_SELF)) return;
    if (!X2PreSpellCastCode()) return;
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
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