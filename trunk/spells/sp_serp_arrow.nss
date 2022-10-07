//::///////////////////////////////////////////////
//:: Name      Serpent Arrow
//:: FileName  sp_serp_arrow.nss
//:://////////////////////////////////////////////
/** @file Serpent Arrow
Transmutation
Level: Justice of weald and woe 3, sorcerer/wizard 4
Components: V, S, M
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: Up to eight projectiles
Duration: Up to 10 min./level; see text
Saving Throw: None
Spell Resistance: No

You transform arrows, bolts, or darts into serpents.
These missiles remain rigid and harmless until fired or hurled. 
They automatically bite any creature they hit, each dealing 1 point
of damage plus poison (injury, Fortitude DC 11, initial and secondary
damage 1d6 Con). The missiles remain in snake form for the duration of
the spell, fighting the creatures they initially struck using their normal
attack bonus. If a missile misses its target, or the target originally
struck moves out of reach, the snake moves to attack the nearest
creature other than you. If a target falls dead and no others are
in range, the spell ends even if its duration has not run out. When
the spell expires, the vipers melt away, leaving nothing behind.

Material Components: Up to eight arrows, bolts, or darts.

Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nStack = GetItemStackSize(oTarget);
        int nCreate = min(8, nStack);
        SetItemStackSize(oTarget, (nStack - nCreate));
        string sSerp;

        int nType = GetBaseItemType(oTarget);

        if(nType == BASE_ITEM_ARROW) sSerp = "prc_serparrow";
        if(nType == BASE_ITEM_BOLT) sSerp = "prc_serpbolt";
        if(nType == BASE_ITEM_DART) sSerp = "prc_serpdart";

        object oSerp = CreateItemOnObject(sSerp, oPC, nCreate);
        if(DEBUG) DoDebug("Creating item " + sSerp);

        //Item Prop already on item, so just add event script

        AddEventScript(oSerp, EVENT_ITEM_ONHIT, "prc_evnt_serparw", TRUE, FALSE);

        PRCSetSchool();
}