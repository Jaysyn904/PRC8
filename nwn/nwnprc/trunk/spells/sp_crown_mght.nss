//::///////////////////////////////////////////////
//:: Name      Crown of Might
//:: FileName  sp_crown_mght.nss
//:://////////////////////////////////////////////
/**@file Crown of Might
Transmutation
Level: Cleric 3, duskblade 3, sorcerer/wizard 3
Components: V,S,F
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 hour/level (D) or until discharged
Saving Throw: Will negates (harmles)

This spell creates a crown of magical energy that
grants the spell's recipient a +2 enhancement bonus
to Strength.

As an immediate action, the creature wearing a crown
of might can discharge its magic to gain a +8
enhancement bonus to Strength for 1 round.  The spell
ends after the wearer uses the crown in this manner.

The crown occupies space on the body as a headband,
hat, or helm. If the crown is removed, the spell
immediately ends.

Focus: A copper hoop 6 inches in diameter.
**/
////////////////////////////////////////////////////
// Author: Tenjac
// Date:   21.9.06
/////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLevel = PRCGetCasterLevel(oPC);
        object oCrown = CreateItemOnObject("prc_crown_might", oTarget, 1);
        float fDur = HoursToSeconds(nCasterLevel);
        int nMetaMagic = PRCGetMetaMagicFeat();

        PRCSignalSpellEvent(oTarget,FALSE, SPELL_CROWN_OF_MIGHT, oPC);

        if(nMetaMagic & METAMAGIC_EXTEND)
        {
                fDur += fDur;
        }

        itemproperty iBonus = ItemPropertyAbilityBonus(ABILITY_STRENGTH, 2);

        IPSafeAddItemProperty(oCrown, iBonus, fDur);

        //ClearActions
        ClearAllActions(TRUE);

        //Force equip
        ForceEquip(oTarget, oCrown, INVENTORY_SLOT_HEAD);

        //Schedule Destruction
        DestroyObject(oCrown, fDur);

        PRCSetSchool();
}


