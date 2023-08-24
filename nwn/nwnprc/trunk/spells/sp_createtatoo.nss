/*
    sp_createtatoo

    <Didn't find a description>

    By: ???
    Created: ???
    Modified: Jul 1, 2006

    fixed spelling of tattoo
*/

#include "prc_sp_func"

int GetTattooCount(object oTarget, int nSpellID)
{
    // Loop through all of the effects on the target, counting
    // the number of them that have this spell ID.
    int nTattoos = 0;
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect))
    {
        if (nSpellID == GetEffectSpellId(eEffect)) nTattoos++;
        eEffect = GetNextEffect(oTarget);
    }

    return nTattoos;
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nTattooSpellID = PRCGetSpellId() + 1;

    if (GetIsPC(oCaster))
    {
        // A creature is only allowed 3 tattoos, check the number they have to make
        // sure we have room to add another.
        int nTattoo = GetTattooCount(oTarget, nTattooSpellID);
        if (nTattoo >= 3)
        {
            // Let the caster know they cannot add another tattoo to the target.
            SendMessageToPC(OBJECT_SELF, GetName(oTarget) + " already has 3 tattoos.");
        }
        else
        {
            // Raise the spell cast event.
            PRCSignalSpellEvent(oTarget, FALSE);

            // Save the ID of the tattoo spell (so the conversation scripts can cast it),
            // and save the metamagic and target.  Then invoke the conversation to
            // let the caster pick what tattoo to scribe.
            SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_LEVEL", nCasterLevel);
            SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_SPELLID", nTattooSpellID);
            SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_METAMAGIC", PRCGetMetaMagicFeat());
            SetLocalObject(OBJECT_SELF, "SP_CREATETATOO_TARGET", oTarget);
            ActionStartConversation(OBJECT_SELF, "sp_createtatoo", FALSE, FALSE);
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