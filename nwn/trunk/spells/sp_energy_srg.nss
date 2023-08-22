//::///////////////////////////////////////////////
//:: Name      Energy Surge
//:: FileName  sp_energy_srg.nss
//:://////////////////////////////////////////////
/**@file Energy Surge
Transmutation [See text]
Duskblade 3, sorcerer/wizard 3
Components: V
Casting time: 1 swift action
Range: Close
Target: One weapon
Duration: 1 round
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You temporarily imbue a weapon with elemental
energy.  When you cast this spell, specify an
energy type (acid, cold, electricity, fire, or
sonic).  This spell is a spell of that type, and
the target weapon is sheathed in that energy. If
the attack is successful, it deals an extra 2d6
points of energy damage.

**/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpell = PRCGetSpellId();
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = RoundsToSeconds(1);
    int nDamType;
    int nDam = d6(2);

    if(nMetaMagic & METAMAGIC_MAXIMIZE)
    {
        nDam = 12;
    }

    if(nMetaMagic & METAMAGIC_EMPOWER)
    {
        nDam = (nDam/2);
    }

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }

    //Get the item to be enhanced
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)))
        {
            oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        }
        else if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)))
        {
            oTarget = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
        }

        else
        {
            PRCSetSchool();
            return;
        }
    }

    //Determine damage type
    if(nSpell == SPELL_ENERGY_SURGE_ACID)
    {
        nDamType = IP_CONST_DAMAGETYPE_ACID;
    }

    else if(nSpell == SPELL_ENERGY_SURGE_COLD)
    {
        nDamType = IP_CONST_DAMAGETYPE_COLD;
    }

    else if(nSpell == SPELL_ENERGY_SURGE_ELEC)
    {
        nDamType = IP_CONST_DAMAGETYPE_ELECTRICAL;
    }

    else if(nSpell == SPELL_ENERGY_SURGE_FIRE)
    {
        nDamType = IP_CONST_DAMAGETYPE_FIRE;
    }

    else if(nSpell == SPELL_ENERGY_SURGE_SONIC)
    {
        nDamType = IP_CONST_DAMAGETYPE_SONIC;
    }

    else
    {
        return;
    }

    itemproperty ipBuff = ItemPropertyDamageBonus(nDamType, nDam);

    IPSafeAddItemProperty(oTarget, ipBuff, fDur);

    PRCSetSchool();
}
