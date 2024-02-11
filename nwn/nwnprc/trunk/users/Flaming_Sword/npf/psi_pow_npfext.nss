/*
   ----------------
   Null Psionics Field - OnExit

   psi_pow_npfext
   ----------------

   6/10/05 by Stratovarius
   Modified: Nov 1, 2007 - Flaming_Sword
*/ /** @file

    Null Psionics Field - OnExit

    Psychokinesis
    Level: Kineticist 6
    Manifesting Time: 1 standard action
    Range: 10 ft.
    Area: 10-ft.-radius emanation centered on you
    Duration: 10 min./level(D)
    Saving Throw: None
    Power Resistance: See text
    Power Points: 11
    Metapsionics: Extend, Widen

    An invisible barrier surrounds you and moves with you. The space within this
    barrier is impervious to most psionic effects, including powers, psi-like
    abilities, and supernatural abilities. Likewise, it prevents the functioning
    of any psionic items or powers within its confines. A null psionics field
    negates any power or psionic effect used within, brought into, or manifested
    into its area.

    Dispel psionics does not remove the field. Two or more null psionics fields
    sharing any of the same space have no effect on each other. Certain powers
    may be unaffected by null psionics field (see the individual power
    descriptions).


    Implementation note: To dismiss the power, use the control feat again. If
                         the power is active, that will end it instead of
                         manifesting it.
*/

#include "prc_craft_inc"

void RemoveEffectsNPF(object oObject)
{
    effect eEff = GetFirstEffect(oObject);
    while(GetIsEffectValid(eEff))
    {
        if(GetEffectType(eEff) == EFFECT_TYPE_SPELL_FAILURE)
            RemoveEffect(oObject, eEff);
        eEff = GetNextEffect(oObject);
    }
}

//Restores object itemprops
void RestoreObjects(object oCreature)
{
    int i = 0;
    int j = 0;
    int nIP = 0;
    object oItem;
    string sItem;
    itemproperty ip;
    string sIP;
    struct ipstruct iptemp;
    string sCreature = GetName(oCreature);
    string sItemName;
    int nSize = persistant_array_get_size(oCreature, "PRC_NPF_ItemList_obj");
    for(i = 0; i < nSize; i++)
    {
        oItem = persistant_array_get_object(oCreature, "PRC_NPF_ItemList_obj", i);
        sItem = persistant_array_get_string(oCreature, "PRC_NPF_ItemList_str", i);
        sItemName = GetName(oItem);
        if(DEBUG)
        {
            DoDebug("RestoreObjects: " + sCreature + ", " + sItemName + ", " + sItem + ", " + ObjectToString(oItem));
        }
        nIP = persistant_array_get_size(oCreature, "PRC_NPF_ItemList_" + sItem);
        for(j = 0; j < nIP; j++)
        {
            sIP = persistant_array_get_string(oCreature, "PRC_NPF_ItemList_" + sItem, j);
            iptemp = GetIpStructFromString(sIP);
            ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);
            IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            if(DEBUG) DoDebug("RestoreObjects: " + sCreature + ", " + sItem + ", " + sIP);
        }
        persistant_array_delete(oCreature, "PRC_NPF_ItemList_" + sItem);
    }
    persistant_array_delete(oCreature, "PRC_NPF_ItemList_obj");
    persistant_array_delete(oCreature, "PRC_NPF_ItemList_str");
}

void main()
{
    object oExit = GetExitingObject();
    if(GetObjectType(oExit) == OBJECT_TYPE_CREATURE)
    {
        if(DEBUG) DoDebug("psi_pow_npfext: Creature exiting NPF: " + DebugObject2Str(oExit));
        DeleteLocalInt(oExit, "NullPsionicsField");

        RemoveEffectsNPF(oExit);

        // Restore objects
        RestoreObjects(oExit);
    }
}