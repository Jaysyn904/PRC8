///////////////////////////////////////////////////////////
// Embalming Fire
// sp_embalmfire.nss
///////////////////////////////////////////////////////////
/*
Embalming Fire: This bitter-smelling liquid must
be poured over a corpse and allowed to soak for at least 1
minute before the corpse is animated as a zombie. Once
animated, if the zombie takes even a single point of
damage, it bursts into blue flame for 1 minute. This fire
does no damage to the zombie, but its attacks during
that time deal an additional 1d6 points of fire damage.*/

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    string sResRef = GetResRef(oTarget);

    //Conditional statement checking for resrefs of zombies. If you have custom zombies, add their resrefs here.
    if(sResRef == "nw_zombtyrant"
    || sResRef == "nw_zombie01"
    || sResRef == "nw_zombie02"
    || sResRef == "nw_zombieboss"
    || sResRef == "nw_zombwarr01"
    || sResRef == "nw_zombwarr02"
    || sResRef == "nw_s_zombie"
    || sResRef == "nw_s_zombtyrant")
    {
        object oZSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
        itemproperty ipOnHit = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
        IPSafeAddItemProperty(oZSkin, ipOnHit, 0.0f);
        AddEventScript(oTarget, EVENT_ONHIT, "prc_evnt_embfr.nss", FALSE, FALSE);
        SendMessageToPC(oPC, "You have coated the zombie in Embalming Fire.");
    }
    else
        SendMessageToPC(oPC, "Invalid target. The target must be a zombie.");
}