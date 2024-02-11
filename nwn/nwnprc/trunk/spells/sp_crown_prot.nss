//::///////////////////////////////////////////////
//:: Name      Crown of Protection
//:: FileName  sp_crown_prot.nss
//:://////////////////////////////////////////////
/**@file Crown of Protection
Transmutation
Level: Cleric 3, duskblade 3, sorcerer/wizard 3
Components: V,S,F
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 hour/level (D) or until discharged
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

This spell creates a crown of magical energy that
grants the spell's recipient a +1 deflection bonus
to AC and a +1 resistance bonus on all saves.

As an immediate action, the creature wearing a
crown of protection can discharge its magic to gain
a +4 deflection bonus to AC or a +4 resistance bonus
on saves for 1 round.  The spell ends after the wearer
uses the crown in this manner.

The crown occupies space on the body as a headband, hat
or helm.  If the crown is removed, the spell immediately
ends.

Focus: An iron hoop 6 inches in diameter.

**/
#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLevel = PRCGetCasterLevel(oPC);
        object oCrown = CreateItemOnObject("prc_crown_prot", oTarget, 1);
        float fDur = HoursToSeconds(nCasterLevel);
        int nMetaMagic = PRCGetMetaMagicFeat();

        PRCSignalSpellEvent(oTarget,FALSE, SPELL_CROWN_OF_PROTECTION, oPC);

        if(nMetaMagic & METAMAGIC_EXTEND)
        {
                fDur += fDur;
        }

        itemproperty iBonus = ItemPropertyACBonus(1);
        itemproperty iBonus2 = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 1);
        itemproperty iBonus3 = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, 1);
        itemproperty iBonus4 = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 1);

        IPSafeAddItemProperty(oCrown, iBonus, fDur, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
        IPSafeAddItemProperty(oCrown, iBonus2, fDur, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
        IPSafeAddItemProperty(oCrown, iBonus3, fDur, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
        IPSafeAddItemProperty(oCrown, iBonus4, fDur, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);

        //ClearActions
        ClearAllActions(TRUE);

        //Force equip
        ForceEquip(oTarget, oCrown, INVENTORY_SLOT_HEAD);

        //Schedule Destruction
        DestroyObject(oCrown, fDur);

        PRCSetSchool();
}