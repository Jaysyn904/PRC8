//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Whirling Blade
Transmutation
Level: Bard 2, sorcerer/wizard 2,warmage 2
Components: V, S, F
Casting Time: 1 standard action
Range: 60 ft.
Effect: 60-ft. line
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

As you cast this spell, you hurl a single
slashing weapon at your foes, magically
striking at all enemies along a
line to the extent of the spell’s range.
You make a normal melee attack, just
as if you attacked with the weapon in
melee, against each foe in the weapon’s
path, but you can choose to substitute
your Intelligence or Charisma
modifier (as appropriate for your
spellcasting class) for your Strength
modifier on the weapon’s attack rolls
and damage rolls. Even if your base
attack bonus would normally give
you multiple attack rolls, a whirling
blade gets only one attack (at your best
attack bonus) against each target. The
weapon deals damage just as if you
had swung it in melee, including any
bonuses you might have from ability
scores or feats.

No matter how many targets your weapon hits or 
misses, it instantly and unerringly returns to 
your hand after attempting the last of its attacks.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        vector vOrigin = GetPosition(oPC);
        location lTarget = PRCGetSpellTargetLocation();
        effect eNone;
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(60.0f), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
        
        while(GetIsObjectValid(oTarget))
        {
                if(!GetIsReactionTypeFriendly(oTarget, oPC))
                {
                        PerformAttack(oTarget, oPC, eNone);
                }
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(60.0f), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
        }
        PRCSetSchool();
}