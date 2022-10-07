//::///////////////////////////////////////////////
//:: OnUserDefined eventscript
//:: prc_onuserdef
//:://////////////////////////////////////////////
#include "prc_alterations"

const string DAMAGE_ARRAY_HEAL  = "DAMAGE_ARRAY_HEAL";

void main()
{
    // Unlike normal, this is executed on OBJECT_SELF. Therefore, we have to first
    // check that the OBJECT_SELF is a creature.
    int nEvent = GetUserDefinedEventNumber();

    //if(DEBUG) DoDebug("prc_onuserdef: " + IntToString(nEvent));

    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE)
    {
        switch(nEvent)
        {
            case EVENT_DAMAGED:
            {
                object oSelf = OBJECT_SELF;
                //object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oSelf);
                //itemproperty ip = GetFirstItemProperty(oHide);
                int nType;
                int nSubType;
                int nCostTableValue;
                int nDamageComponent;
                int nDivisor;
                int nHeal;
                int nDiff;

                //string sHide;

                int nRawDamage = GetTotalDamageDealt();

                //BEGIN HEAL BY DAMAGE TYPE
/*
                if(DEBUG) DoDebug("prc_onuserdef: EVENT_DAMAGED - nRawDamage1 = " + IntToString(nRawDamage));

                if(array_exists(oSelf, DAMAGE_ARRAY_HEAL))
                    array_delete(oSelf, DAMAGE_ARRAY_HEAL);

                array_create(oSelf, DAMAGE_ARRAY_HEAL);

                //this bit would probably be better off in an equip event script...
                //this can get bad on creatures using the newspellbooks

                if(GetIsObjectValid(oHide))
                {
                    sHide = GetResRef(oHide);
                    //add lookup code here to populate array
                    //array_set_int(oSelf, DAMAGE_ARRAY_HEAL, i, nCostTableValue)
                }

                int nRawDamage = 0;
                nHeal = 0;
                int i;
                for(i = 0; i < 13; i++)
                {
                    nDamageComponent = GetDamageDealtByType(1 << i);
                    if(nDamageComponent > 0)
                    {
                        nDivisor = array_get_int(oSelf, DAMAGE_ARRAY_HEAL, i);
                        if(nDivisor > 0)
                        {
                            nHeal += nDamageComponent + (nDamageComponent / nDivisor);
                        }
                        else
                            nRawDamage += nDamageComponent;
                    }
                }

                nDiff = GetMaxHitPoints(oSelf) - GetCurrentHitPoints(oSelf);
                if(nHeal > nDiff)
                {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDiff), oSelf);
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTemporaryHitpoints(nHeal - nDiff), oSelf);
                }
                else
                {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oSelf);
                }

                if(DEBUG) DoDebug("prc_onuserdef: EVENT_DAMAGED - nRawDamage2 = " + IntToString(nRawDamage));
*/
                //END HEAL BY DAMAGE TYPE

                //BEGIN SHIELD OTHER
                object oAttacker = GetLastDamager();
                object oSucker = OBJECT_INVALID;     //the poor bastard who offered to take half my damage for me :D
                int nShieldDamage = nRawDamage / 2;     //use damage left over if some of it went to healing the target

                if(nShieldDamage > 0)
                {
                    effect eSearch = GetFirstEffect(oSelf);
                    while(GetIsEffectValid(eSearch))
                    {
                        if(GetEffectSpellId(eSearch) == SPELL_SHIELD_OTHER)
                        {
                            oSucker = GetEffectCreator(eSearch);
                            if(DEBUG) DoDebug("Shield Other: Found a sucker! (" + GetName(oSucker) + ")");
                            break;
                        }
                        eSearch = GetNextEffect(oSelf);
                    }

                    if(GetIsObjectValid(oSucker))
                    {
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nShieldDamage), oSelf);
                        //make the damager apply the damage to the sucker
                        AssignCommand(oAttacker, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nShieldDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY), oSucker));
                    }
                }
                //END SHIELD OTHER
                //ExecuteScript("prc_shield_other", OBJECT_SELF);
                break;
            }
        }
        ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_ONUSERDEFINED);
    }
}
