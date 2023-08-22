/*
    nw_s0_res.nss

    Raise Dead, Resurrection

    By: Flaming_Sword
    Created: Jun 16, 2006
    Modified: Jun 16, 2006

    Consolidation of 2 scripts, cleaned up
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId();
    int bRes = (nSpellID == SPELL_RESURRECTION);

    if (GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
        if (GetIsDead(oTarget))
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oTarget);
            if(bRes) SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(GetMaxHitPoints(oTarget) + 10, oTarget), oTarget);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), GetLocation(oTarget));
            ExecuteScript(bRes ? "prc_pw_res" : "prc_pw_raisedead", oCaster);
            if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
                SetPersistantLocalInt(oTarget, "persist_dead", FALSE);
        }
        else
        {
            if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                int nStrRef = GetLocalInt(oTarget,"X2_L_RESURRECT_SPELL_MSG_RESREF");
                if(nStrRef == 0)
                    nStrRef = 83861;
                if(nStrRef != -1)
                    FloatingTextStrRefOnCreature(nStrRef,oCaster);
            }
        }
    }
    return TRUE;    //return TRUE if spell charges should be decremented
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