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
    object oCaster = GetAreaOfEffectCreator();
    effect eEff = GetFirstEffect(oObject);
    int nEffID;
    while(GetIsEffectValid(eEff))
    {
        if(GetEffectCreator(eEff) == oCaster)
        {
            nEffID = GetEffectSpellId(eEff);
            if(nEffID == SPELL_ANTIMAGIC_FIELD
            || nEffID == POWER_NULL_PSIONICS_FIELD)
            {
                RemoveEffect(oObject, eEff);
            }
        }
        eEff = GetNextEffect(oObject);
    }
}

//Restores object itemprops
void RetoreItemprops(object oItem)
{
    if(DEBUG) DoDebug("RetoreItemprops: " + GetName(GetItemPossessor(oItem)) + ", " + GetName(oItem) + ", " + ObjectToString(oItem));

    int i;
    itemproperty ip;
    string sIP;
    struct ipstruct iptemp;

    int nIP = array_get_size(oItem, "PRC_NPF_ItemList");
    for(i = 0; i < nIP; i++)
    {
        sIP = array_get_string(oItem, "PRC_NPF_ItemList", i);
        iptemp = GetIpStructFromString(sIP);
        ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);
        IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        if(DEBUG) DoDebug("RetoreItemprops: " + GetName(GetItemPossessor(oItem)) + ", " + ObjectToString(oItem) + ", " + sIP);
    }
    array_delete(oItem, "PRC_NPF_ItemList");
}

//Restores object itemprops
void RestoreObjects(object oCreature)
{
    int i, nSlotMax = INVENTORY_SLOT_CWEAPON_L; //INVENTORY_SLOT_ARROWS;    //max slot number, to exempt creature items //ammo placeholders (?)
    object oItem;

    for(i = 0; i < nSlotMax; i++)   //equipped items
    {
        oItem = GetItemInSlot(i, oCreature);
        if(GetIsObjectValid(oItem))
        {
            RetoreItemprops(oItem);
        }
    }

    oItem = GetFirstItemInInventory(oCreature);
    while(GetIsObjectValid(oItem))
    {
        RetoreItemprops(oItem);
        oItem = GetNextItemInInventory(oCreature);
    }
}

void main()
{
    object oExit = GetExitingObject();
    if(GetObjectType(oExit) == OBJECT_TYPE_CREATURE)
    {
        if(DEBUG) DoDebug("psi_pow_npfext: Creature exiting NPF: " + DebugObject2Str(oExit));

        RemoveEffectsNPF(oExit);

        // Restore objects
        RestoreObjects(oExit);

        // Apply vfx
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID_DN_ORANGE), oEnter);

        DeletePersistantLocalInt(oExit, "NullPsionicsField");
    }
}