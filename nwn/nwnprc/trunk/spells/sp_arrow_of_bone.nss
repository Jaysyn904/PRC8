//::///////////////////////////////////////////////
//:: Name      Arrow of Bone
//:: FileName  sp_arrow_of_bone.nss
//:://////////////////////////////////////////////
/**@file Arrow of Bone
Necromancy [Death]
Level: Sorcerer/wizard 7
Components: V, S, M
Range: Touch
Target: One projectile or thrown weapon touched
Duration: 1 hour/level or until discharged
Saving Throw: Fortitude partial
Spell Resistance: Yes

You complete the ritual needed to
cast the spell, scribing arcane runes into
the item. It changes before your eyes into
an identical item made of bone. The runes
glow with dark magic and the weapon feels
cold to the touch.
When thrown or fired at a creature as a
normal ranged attack, the weapon gains
a +4 enhancement bonus on attack
rolls and damage rolls. In addition, any
living creature struck by an arrow of
bone must succeed on a Fortitude save
or be instantly slain. A creature that
makes its save instead takes 3d6 points
of damage +1 point per caster level
(maximum +20). Regardless of whether
the attack hits, the magic of the arrow
of bone is discharged by the attack, and
the missile is destroyed.

Material Component: A tiny sliver
of bone and an oil of magic weapon

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        if(!X2PreSpellCastCode()) return;
        
        object oPC = OBJECT_SELF;
        object oStack = PRCGetSpellTargetObject();
        string sBone;
        int nType = GetBaseItemType(oStack);
        int nCasterLevel = PRCGetCasterLevel(oPC);
        
        
        if(nType == BASE_ITEM_ARROW)  sBone = "PRC_AB_ARROW001";    
        
        else if (nType == BASE_ITEM_BOLT)  sBone = "PRC_AB_BOLT";
        
        else if (nType == BASE_ITEM_BULLET) sBone = "PRC_AB_BULLET";
        
        else if (nType == BASE_ITEM_DART)   sBone = "PRC_AB_DART";
        
        else if (nType == BASE_ITEM_THROWINGAXE) sBone = "PRC_AB_THRAXE";
        
        else if (nType == BASE_ITEM_SHURIKEN) sBone = "PRC_AB_SHURIKEN";
        
        else
        {
                SendMessageToPC(oPC, "Invalid item type.");
                return;
        }       
        
        //Decrement the stack
        int nNewStack = GetItemStackSize(oStack);
        nNewStack--;
        
        SetItemStackSize(oStack, nNewStack);
        
        //create appropriate item
        object oArrowBone = CreateItemOnObject(sBone, oPC, 1);
                       
        //Hook the onhit script
        itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
        IPSafeAddItemProperty(oArrowBone, ipHook, 0.0f);
        AddEventScript(oArrowBone, EVENT_ITEM_ONHIT, "prc_evnt_arrbone", FALSE, FALSE);        
                
        PRCSetSchool();
}