//::///////////////////////////////////////////////
//:: Barbarian Rage
//:: NW_S1_BarbRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Str and Con of the Barbarian increases,
    Will Save are +2, AC -2.
    Greater Rage starts at level 15.
    
    Updated: 2004-01-18 mr_bumpkin: Added bonuses for exceeding +12 stat cap
    Updated: 2004-2-24 by Oni5115: Added Intimidating Rage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_addragebonus"
#include "prc_class_const"
void main()
{
    // simplified to cast regular rage on the character. Helps with keeping it up to date and keeping
    // things from stacking.  (Spell 307 == nw_s1_barbrage.nss) -- WodahsEht
    ActionCastSpellAtObject(307, OBJECT_SELF, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
}
