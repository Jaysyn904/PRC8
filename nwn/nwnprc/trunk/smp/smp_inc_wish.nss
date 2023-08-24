/*:://////////////////////////////////////////////
//:: Name Wish functions
//:: FileName SMP_INC_WISH
//:://////////////////////////////////////////////
    Functions for the Wish, Miracle and so on spells.

    These can be used, therefore, in those scripts, and replaces the SMP_INC_SPELLS
    line, as it will include it here.

    Not just wish effects, but also wish checks :-)

    Call these functions from a script from a wish creature or DM.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// Note: You must set on the person calling these functions a name - under
// SMP_WISH_NAME, so it can be used to send a correct message:
// "You cannot cast Magic Missile using Wish", might be "using Miracle" instead.
// Remember:
const string SMP_WISH_NAME_LOCAL = "SMP_WISH_NAME_LOCAL";

// SPECIAL

// SMP_INC_WISH. Gets the wish's name - IE: Miracle, Limited Wish, Wish, for things like
// "You cannot cast Magic Missile using Miracle"
string SMP_WishGetName();

// SMP_INC_WISH. Checks if oObject is within oWisher's LOS
// * Placables, doors, items. Creatures use GetObjectSeen()/Heard().
int SMP_WishGetObjectInLOS(object oTarget, object oWisher);
// SMP_INC_WISH. Applies the loop onto oWisher of what they can see in thier LOS (40M)
// * Only call this directly from the object doing the wish, so oWisher should
//   always be OBJECT_SELF
void SMP_WishSetLOS(object oWisher = OBJECT_SELF);
// SMP_INC_WISH. Deletes all locals set in SMP_WishSetLOS().
void SMP_WishDeleteLOS(location lWisher, string sLocal);


// CHECKS

// Note 2: Given the above local setting, whenever it says "Wish" inside debug
// strings, it'll be subsituted as approprate.

// SMP_INC_WISH. This will make sure cirtain spells can *never* be cast from wish.
// * TRUE if they cannot cast it ever, period.
// Debugs using: "You cannot cast 'GetName(nSpellId)' using Wish" (or other..)
int SMP_WishGetIsUncastableSpell(object oWisher, int nSpellId);
// SMP_INC_WISH. This makes sure that oTarget is a valid target for nSpellId, using range,
// types of target affected,
// * TRUE if they ARE a valid target
// If FALSE Debug: "You cannot cast nSpellId at oTarget"... + Reason
int SMP_WishGetIsSpellTargetValid(object oWisher, object oTarget, int nSpellId);

// SMP_INC_WISH. Deciphers sName into a spell id's number. This, sadly, will
// do a large loop. Use wisely! It uses FindSubString(), and so must match
// pretty well. Does capitalise both.
// * loops the spell values on SMP_ArrayGetObject(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_NAME);
// * Returns SPELL_INVALID as default, if no spell is found to be a match.
int SMP_WishGetSpellId(string sName, object oWisher);
// SMP_INC_WISH. This is from this (this is from Wish, it is similar for others)
// • Duplicate any wizard or sorcerer spell of 8th level or lower, provided the
//   spell is not of a school prohibited to you. (nClassBan = any spell from nClass's normal list)
// • Duplicate any other spell of 6th level or lower, provided the spell is not
//   of a school prohibited to you. (nAnyBan = Any spell from any list, not banned via. school)
// • Duplicate any wizard or sorcerer spell of 7th level or lower even if it’s
//   of a prohibited school. (nClassNoBan = Any spell from this class's list, up to this level)
// • Duplicate any other spell of 5th level or lower even if it’s of a
//   prohibited school.  (nAny = Any other spell, even opposing schools)
// In this example: nClassBan = 7, nClassNoBan = 8, nAnyBan = 6, nAny = 5.
// * Put in CLASS_TYPE_WIZARD or CLASS_TYPE_CLERIC for nClass, always.
int SMP_WishGetIsSpellValid(object oWisher, int nClass, int nSpellId, int nClassBan, int nClassNoBan, int nAnyBan, int nAny);

// SMP_INC_WISH. Get a valid target for wish, using sName. We will loop all
// objects which we allow (In order: Creatuers, then any Placables, Doors,
// Items on the Ground).
// * Can use bCreatureOnly to only check creatures in range.
// * Only will use seen creatures, that oWisher can see, or objects that are within
//   oWisher's LOS too (we do a loop in the SMP_S_WISH script, or similar, to
//   set it up using functions here).
// * Returns OBJECT_INVALID in case of no valid target to return
// * Can use bSeenOnly to force the object to be seen (ala, spell targeting)
// Gets the nearest target, of course, a placable with name sNAme could be nearer
// then a creature with sName, but we return the creature first. Also, hardly happens.
object SMP_WishGetTargetByName(object oWisher, string sName, int bCreatureOnly = FALSE, int bSeenOnly = FALSE);


// EFFECTS

// SMP_INC_WISH. Cures oWisher's party of all damage, to thier maximum hit points, if they
// are at -10 or higher hit points
void SMP_WishDoCurePartyDamage(object oWisher);
// SMP_INC_WISH. Cures oWisher's party of nAffiction
void SMP_WishDoCurePartyAffiction(object oWisher, int nAffiction);
// SMP_INC_WISH. Makes oWisher cast nSpellId at oTarget
void SMP_WishCastSpellAtObject(object oWisher, int nSpellId, object oTarget);
// SMP_INC_WISH. Makes oWisher undo the harmful effects of all Insanity spells on oTarget
void SMP_WishRemoveInsanity(object oWisher, object oTarget);
// SMP_INC_WISH. Makes oWisher attempt to teleport oTarget to lLocation.
// Must be used seperatly on each person. Willing people go for free, else, it
// uses nSpellSaveDC, and nCasterLevel to do the checks for resistance and will save
// * Reports saves normally, etc.
// * No other feedback.
// * Returns TRUE if sucessful, so a complete feedback can be made up.
int SMP_WishTeleportPerson(object oWisher, object oTarget, location lTarget, int nSpellSaveDC, int nCasterLevel);

// Creates a particular item for oWisher, named by them, it will search a database
// of items to get which one to create.
// void SMP_WishCreateMundateItem()
// Creates magical of above
// FINISH!!!!

// START SPECIAL

// Gets the wish's name
string SMP_WishGetName()
{
    return GetLocalString(OBJECT_SELF, SMP_WISH_NAME_LOCAL);
}

// Checks if oObject is within oWisher's LOS
// * Placables, doors, items. Creatures use GetObjectSeen()/Heard().
int SMP_WishGetObjectInLOS(object oTarget, object oWisher)
{
    // Check local on the target
    string sLocal = "SMP_WISH_LOS" + ObjectToString(oWisher);
    // Local gets set on the target if they are in the wishers LOS. Gets
    // removed too after wish is cast.
    if(GetLocalInt(oTarget, sLocal))
    {
        return TRUE;
    }
    return FALSE;
}

// Applies the loop onto oWisher of what they can see in thier LOS (40M)
// * Only call this directly from the object doing the wish, so oWisher should
//   always be OBJECT_SELF
void SMP_WishSetLOS(object oWisher = OBJECT_SELF)
{
    // Check LOS of those objects:
    // * Placables, doors, items
    string sLocal = "SMP_WISH_LOS" + ObjectToString(oWisher);
    location lWisher = GetLocation(oWisher);
    object oLOS = GetFirstObjectInShape(SHAPE_SPHERE, 40.0, lWisher, TRUE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_ITEM);
    while(GetIsObjectValid(oLOS))
    {
        // Set local on them
        SetLocalInt(oLOS, sLocal, TRUE);

        // Get next object
        oLOS = GetNextObjectInShape(SHAPE_SPHERE, 40.0, lWisher, TRUE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_ITEM);
    }

    // Delay the deletion
    DelayCommand(6.0, SMP_WishDeleteLOS(lWisher, sLocal));
}

// Deletes all locals set in SMP_WishSetLOS().
void SMP_WishDeleteLOS(location lWisher, string sLocal)
{
    // Delete all previous (if any) locals.
    // This is delayed after they have been set. Should clear up them all
    int nCnt = 1;
    object oLOS = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_ITEM, lWisher, nCnt);
    while(GetIsObjectValid(oLOS) && GetDistanceBetweenLocations(lWisher, GetLocation(oLOS)) <= 41.0)
    {
        // Delete the local.
        DeleteLocalInt(oLOS, sLocal);

        nCnt++;
        oLOS = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_ITEM, lWisher, nCnt);
    }
}

// START CHECKS

// This will make sure cirtain spells can *never* be cast from wish.
// * TRUE if they cannot cast it ever, period.
// Debugs using: "You cannot cast 'GetName(nSpellId)' using Wish"
int SMP_WishGetIsUncastableSpell(object oWisher, int nSpellId)
{
    switch(nSpellId)
    {
        // Spells which have more then 1 round casting time
        //case SMP_SPELL_RAISE_DEAD:
        //{
        //    SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " using " + SMP_WishGetName() + " because it takes longer then a round to cast");
        //    return TRUE;
        //}
        break;
        // Spells which are duplicated by the resurrection part of all these spells
        case SMP_SPELL_RAISE_DEAD:
        //case SMP_SPELL_RESURRECTION:
        //case SMP_SPELL_TRUE_RESURRECTION:
        {
            SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " because you can duplicate its effects using " + SMP_WishGetName() + " anyway.");
            return TRUE;
        }
        break;
    }
    // Default return - no debug
    return FALSE;
}

// This makes sure that oTarget is a valid target for nSpellId, using range,
// types of target affected,
// * TRUE if they ARE a valid target
// If FALSE Debug: "You cannot cast nSpellId at oTarget
int SMP_WishGetIsSpellTargetValid(object oWisher, object oTarget, int nSpellId)
{
    // Check the target type (IE: Self, creature, trigger ETC)
    int nTargetsType = GetObjectType(oTarget);
    int nSpellTargetType = SMP_ArrayGetSpellTargetType(nSpellId);

    // If the spell can be cast at any location, it can be cast at any object
    // too (because otherwise some locations under people cannot be hit right)
    if(!SMP_GetIsTargetTypeLocation(nSpellTargetType))
    {
        // Check for any object, regardless (cannot target the ground with
        // wish, it targets a specific being)
        if(!SMP_GetIsTargetTypeObject(nSpellTargetType))
        {
            // This spell cannot target any object
            SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " at " + GetName(oTarget) + " because the spell doesn't allow it");
            return FALSE;
        }
        // Check each type.
        switch(nTargetsType)
        {
            case OBJECT_TYPE_CREATURE:
            {
                // Special case for self
                if(oTarget == oWisher)
                {
                    if(!SMP_GetIsTargetTypeSelf(nSpellTargetType))
                    {
                        // Cannot cast at yourself.
                        SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " at yourself.");
                        return FALSE;
                    }
                }
                // Check default
                if(!SMP_GetIsTargetTypeCreature(nSpellTargetType))
                {
                    // Cannot cast at a creature.
                    SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " at a creature.");
                    return FALSE;
                }
            }
            case OBJECT_TYPE_DOOR:
            {
                // Check door
                if(!SMP_GetIsTargetTypeDoor(nSpellTargetType))
                {
                    SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " at a door.");
                    return FALSE;
                }
            }
            case OBJECT_TYPE_ITEM:
            {
                // Check item
                if(!SMP_GetIsTargetTypeItem(nSpellTargetType))
                {
                    SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " at an item.");
                    return FALSE;
                }
            }
            case OBJECT_TYPE_PLACEABLE:
            {
                // Check placeable
                if(!SMP_GetIsTargetTypePlaceable(nSpellTargetType))
                {
                    SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " at a placeable.");
                    return FALSE;
                }
            }
        }
    }
    // Check the range of this spell
    float fRange = SMP_ArrayGetSpellRange(nSpellId);
    // Note: We make the "personal" range 1.0 here, in case some spell uses it.
    // ABOVE is a nicer check for target type, and is more by the book.
    if(fRange == 0.0) fRange = 1.0;
    if(SMP_ArrayGetSpellRange(nSpellId) > GetDistanceBetween(oWisher, oTarget))
    {
        // Cannot cast - to far away
        SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + ", the target is too far away");
        return FALSE;
    }
    // Return TRUE by default, allowing the target as valid
    return TRUE;
}

// Deciphers sName into a spell id's number. This, sadly, will do a large loop.
// Use wisely! It uses FindSubString(), and so must match pretty well. Does capitalise both.
// * loops the spell values on SMP_ArrayGetObject(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_NAME);
// * Returns SPELL_INVALID as default, if no spell is found to be a match.
int SMP_WishGetSpellId(string sName, object oWisher)
{
    string sCheck, sSpell;
    int nCnt;
    // Uppercase of sName.
    sCheck = GetStringUpperCase(sName);

    // We set the last spell name got by this onto OBJECT_SELF, and oWisher's
    // Id. This is retrieved first, and checked (they might have asked to cast
    // the same spell, but wrong syntax etc. before).
    nCnt = GetLocalInt(OBJECT_SELF, "SMP_WISH_LASTSPELLNAME" + ObjectToString(oWisher));
    // We won't ever recheck spell entry 0, because it returns 0 on default
    if(nCnt > 0)
    {
        // Get the spell name at nCnt
        sSpell = GetStringUpperCase(SMP_ArrayGetSpellName(nCnt));

        // Check the two strings together
        if(FindSubString(sCheck, sSpell) >= 0)
        {
            // Return nCnt - the names match
            return nCnt;
        }
    }

    // Loop all the spell names until we find a match.
    // * Check only real spells.
    for(nCnt = SMP_SPELLS_2DA_MIN_SPELL_ENTRY;
        nCnt <= SMP_SPELLS_2DA_MAX_ENTRY; nCnt++)
    {
        // Get the spell name at nCnt
        sSpell = GetStringUpperCase(SMP_ArrayGetSpellName(nCnt));

        // Check the two strings together
        if(FindSubString(sCheck, sSpell) >= 0)
        {
            // Return nCnt - the names match
            return nCnt;
        }
    }
    return SPELL_INVALID;
}
// This is from this (this is from Wish, it is similar for others)
// • Duplicate any wizard or sorcerer spell of 8th level or lower, provided the
//   spell is not of a school prohibited to you. (nClassBan = any spell from nClass's normal list)
// • Duplicate any other spell of 6th level or lower, provided the spell is not
//   of a school prohibited to you. (nAnyBan = Any spell from any list, not banned via. school)
// • Duplicate any wizard or sorcerer spell of 7th level or lower even if it’s
//   of a prohibited school. (nClassNoBan = Any spell from this class's list, up to this level)
// • Duplicate any other spell of 5th level or lower even if it’s of a
//   prohibited school.  (nAny = Any other spell, even opposing schools)
// In this example: nClassBan = 7, nClassNoBan = 8, nAnyBan = 6, nAny = 5.
// * Put in CLASS_TYPE_WIZARD or CLASS_TYPE_CLERIC for nClass, always.
int SMP_WishGetIsSpellValid(object oWisher, int nClass, int nSpellId, int nClassBan, int nClassNoBan, int nAnyBan, int nAny)
{
    // MUST BE CASTABLE NORMALLY
    if(!SMP_ArrayGetSpellIsPCCastable(nSpellId))
    {
        // Cannot cast it
        SpeakString("You cannot cast " + SMP_ArrayGetSpellName(nSpellId) + " because it is on no class' spell list");
        return FALSE;
    }

    // Get nSpellId's level, from nClass and nInnate
    int nClassLevel = SMP_ArrayGetSpellLevel(nSpellId, nClass);
    int nInnateLevel = SMP_ArrayGetSpellLevelGeneral(nSpellId, oWisher);

    // Check if they can cast it regardless of class, or school
    if(nInnateLevel <= nAny)
    {
        // Can cast it!
        return TRUE;
    }
    // Have they got nSpellId on thier list of spells?
    if(nClassLevel != -1)
    {
        // Check if they can cast it due to it being on thier class list, and it is
        // of a low enough level, and so we can cast it (never mind spell schools)
        // we check here
        if(nClassLevel <= nClassNoBan)
        {
            // Can cast it!
            return TRUE;
        }
        // Checks for the spell school one
        //if(SMP_ArrayGetSpellSchool(nSpellId) != WHAT_THIER_BANNED_SPELL_SCHOOL_IS)
        //{
        //    if(nClassLevel <= nClassBan)
        //    {
        //        // Can cast it!
        //        return TRUE;
        //    }
        //}
    }
    // Check for the spell school for all class lists.
    //if(SMP_ArrayGetSpellSchool(nSpellId) != WHAT_THIER_BANNED_SPELL_SCHOOL_IS)
    //{
    //    if(nInnateLevel <= nAnyBan)
    //    {
    //        // Can cast it!
    //        return TRUE;
    //    }
    //}
    // Cannot cast it (default return)
    return FALSE;
}

// Get a valid target for wish, using sName. We will loop all objects which we
// allow (In order: Creatuers, then any Placables, Doors, Items on the Ground).
// * Can use bCreatureOnly to only check creatures in range.
// * Only will use seen creatures, that oWisher can see, or objects that are within
//   oWisher's LOS too (we do a loop in the SMP_S_WISH script, or similar, to
//   set it up using functions here).
// * Returns OBJECT_INVALID in case of no valid target to return
// * Can use bSeenOnly to force the object to be seen (ala, spell targeting)
// Gets the nearest target, of course, a placable with name sNAme could be nearer
// then a creature with sName, but we return the creature first. Also, hardly happens.
object SMP_WishGetTargetByName(object oWisher, string sName, int bCreatureOnly = FALSE, int bSeenOnly = FALSE)
{
    // Loop all creatures first
    int nCnt = 1;
    object oCheck = GetNearestObject(OBJECT_TYPE_CREATURE, oWisher, nCnt);
    while(GetIsObjectValid(oCheck))
    {
        if(FindSubString(sName, GetName(oCheck)) >= 0)
        {
            // Check if seen, or can sometimes be heard
            if(GetObjectSeen(oCheck, oWisher) ||
              (bSeenOnly == FALSE && GetObjectHeard(oCheck, oWisher)))
            {
                // Return them
                return oCheck;
            }
        }
        nCnt++;
        oCheck = GetNearestObject(OBJECT_TYPE_CREATURE, oWisher, nCnt);
    }
    // Check placables, doors and items last
    nCnt = 1;
    oCheck = GetNearestObject(OBJECT_TYPE_DOOR | OBJECT_TYPE_ITEM | OBJECT_TYPE_PLACEABLE, oWisher, nCnt);
    while(GetIsObjectValid(oCheck))
    {
        if(FindSubString(sName, GetName(oCheck)) >= 0)
        {
            // Check if in LOS
            if(SMP_WishGetObjectInLOS(oCheck, oWisher))
            {
                // Return them
                return oCheck;
            }
        }
        nCnt++;
        oCheck = GetNearestObject(OBJECT_TYPE_DOOR | OBJECT_TYPE_ITEM | OBJECT_TYPE_PLACEABLE, oWisher, nCnt);
    }
    // Default return value
    return OBJECT_INVALID;
}

// START FUNCTIONS


// Cures oWisher's party of all damage, to thier maximum hit points, if they
// are at -10 or higher hit points
void SMP_WishDoCurePartyDamage(object oWisher)
{
    // Get PC party members, and our area
    effect eHeal;
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    object oArea = GetArea(oWisher);
    object oMember = GetFirstFactionMember(oWisher, TRUE);
    while(GetIsObjectValid(oMember))
    {
        // Must be in same area
        if(GetArea(oMember) == oArea)
        {
            // Heal them
            eHeal = EffectHeal(GetMaxHitPoints(oMember));
            SMP_ApplyInstantAndVFX(oMember, eVis, eHeal);
        }
        // Get next member
        oMember = GetNextFactionMember(oWisher, TRUE);
    }
    // Loop NPC's
    oMember = GetFirstFactionMember(oWisher, FALSE);
    while(GetIsObjectValid(oMember))
    {
        // Must be in same area
        if(GetArea(oMember) == oArea)
        {
            // Heal them
            eHeal = EffectHeal(GetMaxHitPoints(oMember));
            SMP_ApplyInstantAndVFX(oMember, eVis, eHeal);
        }
        // Get next member
        oMember = GetNextFactionMember(oWisher, FALSE);
    }
}
// Cures oWisher's party of nAffiction
void SMP_WishDoCurePartyAffiction(object oWisher, int nAffiction)
{
    // Get PC party members, and our area
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    object oArea = GetArea(oWisher);
    object oMember = GetFirstFactionMember(oWisher, TRUE);
    while(GetIsObjectValid(oMember))
    {
        // Must be in same area
        if(GetArea(oMember) == oArea)
        {
            // Heal them
            SMP_RemoveSpecificEffect(nAffiction, oMember, SUBTYPE_IGNORE);
            SMP_ApplyVFX(oMember, eVis);
        }
        // Get next member
        oMember = GetNextFactionMember(oWisher, TRUE);
    }
    // Loop NPC's
    oMember = GetFirstFactionMember(oWisher, FALSE);
    while(GetIsObjectValid(oMember))
    {
        // Must be in same area
        if(GetArea(oMember) == oArea)
        {
            // Heal them
            SMP_RemoveSpecificEffect(nAffiction, oMember, SUBTYPE_IGNORE);
            SMP_ApplyVFX(oMember, eVis);
        }
        // Get next member
        oMember = GetNextFactionMember(oWisher, FALSE);
    }
}

// Makes oWisher cast nSpellId at oTarget
void SMP_WishCastSpellAtObject(object oWisher, int nSpellId, object oTarget)
{
    // Say we have done the wish
    SpeakString("Your " + SMP_WishGetName() + " is granted, you cast " + SMP_ArrayGetSpellName(nSpellId));

    // Assign the wisher to cast the spell
    AssignCommand(oWisher, ActionCastSpellAtObject(nSpellId, oTarget, METAMAGIC_NONE, TRUE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}

// Makes oWisher undo the harmful effects of all Insanity spells on oTarget
void SMP_WishRemoveInsanity(object oWisher, object oTarget)
{
    // Say we have done the wish
    SpeakString("Your " + SMP_WishGetName() + " is granted, Insanity will be removed from " + GetName(oTarget));

    // Send messages
    // * Not in yet, might not add

    // Loop effects, remove isanity
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        switch(GetEffectSpellId(eCheck))
        {
            // - All insanity
            case SMP_SPELL_INSANITY:
            case SMP_SPELL_SYMBOL_OF_INSANITY:
            {
                // Remove it
                RemoveEffect(oTarget, eCheck);
            }
            break;
        }
    }
}

// Makes oWisher attempt to teleport oTarget to lLocation.
// Must be used seperatly on each person. Willing people go for free, else, it
// uses nSpellSaveDC, and nCasterLevel to do the checks for resistance and will save
// * Reports saves normally, etc.
// * No other feedback.
// * Returns TRUE if sucessful, so a complete feedback can be made up.
int SMP_WishTeleportPerson(object oWisher, object oTarget, location lTarget, int nSpellSaveDC, int nCasterLevel)
{
    // If the target is in the party of oWisher, it is automatic.
    if(GetFactionEqual(oWisher, oTarget))
    {
        // Move them (with some feedback to them)
        SendMessageToPC(oTarget, "*You are teleported by Wish to a new location*");
        AssignCommand(oTarget, SMP_ForceMovementToLocation(lTarget, VFX_FNF_TELEPORT_OUT, VFX_FNF_TELEPORT_IN));
        return TRUE;
    }
    // Else, check saves and spell resistance.
    // Spell resistance (Only)
    if(!SMP_SpellResistanceManualCheck(oWisher, oTarget, nCasterLevel, 9))
    {
        // * Will save negates (And note: It is save type spell, because this isn't a
        //   spell script).
        if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SPELL, oWisher))
        {
            // Move them! (Forcefully)
            SendMessageToPC(oTarget, "*You are teleported by Wish to a new location*");
            AssignCommand(oTarget, SMP_ForceMovementToLocation(lTarget, VFX_FNF_TELEPORT_OUT, VFX_FNF_TELEPORT_IN));
            return TRUE;
        }
    }

    // Failed to teleport them
    return FALSE;
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
