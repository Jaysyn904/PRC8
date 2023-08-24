/*:://////////////////////////////////////////////
//:: Name Array functions
//:: FileName SMP_INC_METATARG (Metamagic Target types)
//:://////////////////////////////////////////////
    This contains specific things for checking Meta Magic and Target Types,
    the two columns in the spells.2da which, before Axe Murderer posted this,
    I didn't have a clue.

    Post:
    http://nwn.bioware.com/forums/viewcodepost.html?post=3170796
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Special constants (note: Integers)
const int SMP_TARGET_TYPE_SELF      = 0x01;
const int SMP_TARGET_TYPE_CREATURE  = 0x02;
const int SMP_TARGET_TYPE_LOCATION  = 0x04;
const int SMP_TARGET_TYPE_ITEM      = 0x08;
const int SMP_TARGET_TYPE_DOOR      = 0x10;
const int SMP_TARGET_TYPE_PLACEABLE = 0x20;
const int SMP_TARGET_TYPE_TRIGGER   = 0x40;
const int SMP_TARGET_TYPE_ANY       = 0x7F;
const int SMP_TARGET_TYPE_NONE      = 0x00;
// Metamagic ones
const int SMP_METAMAGIC_TYPE_EMPOWER  = 0x01;
const int SMP_METAMAGIC_TYPE_EXTEND   = 0x02;
const int SMP_METAMAGIC_TYPE_MAXIMIZE = 0x04;
const int SMP_METAMAGIC_TYPE_QUICKEN  = 0x08;
const int SMP_METAMAGIC_TYPE_SILENT   = 0x10;
const int SMP_METAMAGIC_TYPE_STILL    = 0x20;
const int SMP_METAMAGIC_TYPE_ANY      = 0x3F;
const int SMP_METAMAGIC_TYPE_NONE     = 0x00;

// Declare all the functions

// SMP_INC_METATARG. Returns TRUE if the the target type put in (nTypeToTest)
// (EG: SMP_TARGET_TYPE_CREATURE) is valid within the integer nTargetType.
int SMP_GetIsTargetTypeValid(int nTargetType, int nTypeToTest = SMP_TARGET_TYPE_ANY);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in is valid for casting on SELF.
int SMP_GetIsTargetTypeSelf(int nTargetType);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in is valid for casting on other CREATUREs.
int SMP_GetIsTargetTypeCreature(int nTargetType);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in is valid for casting at any LOCATION.
int SMP_GetIsTargetTypeLocation(int nTargetType);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in is valid for casting on any ITEM.
int SMP_GetIsTargetTypeItem(int nTargetType);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in is valid for casting on any DOOR.
int SMP_GetIsTargetTypeDoor(int nTargetType);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in is valid for casting on any PLAECABLE.
int SMP_GetIsTargetTypePlaceable(int nTargetType);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in is valid for casting at any TRIGGER.
int SMP_GetIsTargetTypeTrigger(int nTargetType);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in NOT valid on ANYTHING (Cannot cast it basically!)
int SMP_GetIsTargetTypeNone(int nTargetType);
// SMP_INC_METATARG. Returns TRUE if nTargetType put in is valid for casting at any OBJECT
// * Object = Self, Door, Creature, Item, Placable
int SMP_GetIsTargetTypeObject(int nTargetType);

// SMP_INC_METATARG. Returns TRUE if any of the bits in nTypeToTest are in nMetaMagicType.
int SMP_GetIsMetaMagicTypeValid(int nMetaMagicType, int nTypeToTest = SMP_METAMAGIC_TYPE_ANY);
// SMP_INC_METATARG. Returns TRUE if nMetaMagicType put in is valid for using metamagic EMPOWER.
int SMP_GetIsMetaMagicTypeEmpower(int nMetaMagicType);
// SMP_INC_METATARG. Returns TRUE if nMetaMagicType put in is valid for using metamagic EXTEND.
int SMP_GetIsMetaMagicTypeExtend(int nMetaMagicType);
// SMP_INC_METATARG. Returns TRUE if nMetaMagicType put in is valid for using metamagic MAXIMIZE.
int SMP_GetIsMetaMagicTypeMaximize(int nMetaMagicType);
// SMP_INC_METATARG. Returns TRUE if nMetaMagicType put in is valid for using metamagic QUICKEN.
int SMP_GetIsMetaMagicTypeQuicken(int nMetaMagicType);
// SMP_INC_METATARG. Returns TRUE if nMetaMagicType put in is valid for using metamagic SILENT.
int SMP_GetIsMetaMagicTypeSilent(int nMetaMagicType);
// SMP_INC_METATARG. Returns TRUE if nMetaMagicType put in is valid for using metamagic STILL.
int SMP_GetIsMetaMagicTypeStill(int nMetaMagicType);
// SMP_INC_METATARG. Returns TRUE if nMetaMagicType put in can have no metamagic applied.
int SMP_GetIsMetaMagicTypeNone(int nMetaMagicType);

// Returns TRUE if the the target type put in (nTypeToTest)
// (EG: SMP_TARGET_TYPE_CREATURE) is valid within the integer nTargetType.
int SMP_GetIsTargetTypeValid(int nTargetType, int nTypeToTest = SMP_TARGET_TYPE_ANY)
{
    // This one returns true if any of the target type bits is/are set on in the
    // input value nTargetType.
    // Note this is an intentional bitwise & not logical &&.
    return (nTargetType & nTypeToTest);
}
// Returns TRUE if nTargetType put in is valid for casting on SELF.
int SMP_GetIsTargetTypeSelf(int nTargetType)
{
    return SMP_GetIsTargetTypeValid(nTargetType, SMP_TARGET_TYPE_SELF);
}
// Returns TRUE if nTargetType put in is valid for casting on other CREATUREs.
int SMP_GetIsTargetTypeCreature(int nTargetType)
{
    return SMP_GetIsTargetTypeValid(nTargetType, SMP_TARGET_TYPE_CREATURE);
}
// Returns TRUE if nTargetType put in is valid for casting at any LOCATION.
int SMP_GetIsTargetTypeLocation(int nTargetType)
{
    return SMP_GetIsTargetTypeValid(nTargetType, SMP_TARGET_TYPE_LOCATION);
}
// Returns TRUE if nTargetType put in is valid for casting on any ITEM.
int SMP_GetIsTargetTypeItem(int nTargetType)
{
    return SMP_GetIsTargetTypeValid(nTargetType, SMP_TARGET_TYPE_ITEM);
}
// Returns TRUE if nTargetType put in is valid for casting on any DOOR.
int SMP_GetIsTargetTypeDoor(int nTargetType)
{
    return SMP_GetIsTargetTypeValid(nTargetType, SMP_TARGET_TYPE_DOOR);
}
// Returns TRUE if nTargetType put in is valid for casting on any PLACEABLE.
int SMP_GetIsTargetTypePlaceable(int nTargetType)
{
    return SMP_GetIsTargetTypeValid(nTargetType, SMP_TARGET_TYPE_PLACEABLE);
}
// Returns TRUE if nTargetType put in is valid for casting at any TRIGGER.
int SMP_GetIsTargetTypeTrigger(int nTargetType)
{
    return SMP_GetIsTargetTypeValid(nTargetType, SMP_TARGET_TYPE_TRIGGER);
}
// Returns TRUE if nTargetType put in NOT valid on ANYTHING (Cannot cast it basically!)
int SMP_GetIsTargetTypeNone(int nTargetType)
{
    return SMP_GetIsTargetTypeValid(nTargetType, SMP_TARGET_TYPE_NONE);
}
// Returns TRUE if nTargetType put in is valid for casting at any OBJECT
// * Object = Self, Door, Creature, Item, Placable
int SMP_GetIsTargetTypeObject(int nTargetType)
{
    // It would be easier on this one to:
    // return (GetIsTargetTypeValid( iTargetType) &&
    //         !GetIsTargetTypeLocation( iTargetType));
    // but I wrote it this way to show how you would combine the constants using
    // the bitwise or | operator (different than logical or ||).
    int nTypeMask = SMP_TARGET_TYPE_SELF | SMP_TARGET_TYPE_CREATURE |
                    SMP_TARGET_TYPE_ITEM | SMP_TARGET_TYPE_DOOR |
                    SMP_TARGET_TYPE_PLACEABLE | SMP_TARGET_TYPE_TRIGGER;
    return SMP_GetIsTargetTypeValid(nTargetType, nTypeMask);
}

// Returns TRUE if any of the bits in nTypeToTest are in nMetaMagicType.
int SMP_GetIsMetaMagicTypeValid(int nMetaMagicType, int nTypeToTest = SMP_METAMAGIC_TYPE_ANY)
{
    // This one returns true if any of the metamagic bits is/are set on in the
    // input value nMetaMagicType.
    // Note this is an intentional bitwise & not logical &&.
    return (nMetaMagicType & nTypeToTest);
}
// Returns TRUE if nMetaMagicType put in is valid for using metamagic EMPOWER.
int SMP_GetIsMetaMagicTypeEmpower(int nMetaMagicType)
{
    return SMP_GetIsMetaMagicTypeValid(nMetaMagicType, SMP_METAMAGIC_TYPE_EMPOWER);
}
// Returns TRUE if nMetaMagicType put in is valid for using metamagic EXTEND.
int SMP_GetIsMetaMagicTypeExtend(int nMetaMagicType)
{
    return SMP_GetIsMetaMagicTypeValid(nMetaMagicType, SMP_METAMAGIC_TYPE_EXTEND);
}
// Returns TRUE if nMetaMagicType put in is valid for using metamagic MAXIMIZE.
int SMP_GetIsMetaMagicTypeMaximize(int nMetaMagicType)
{
    return SMP_GetIsMetaMagicTypeValid(nMetaMagicType, SMP_METAMAGIC_TYPE_MAXIMIZE);
}
// Returns TRUE if nMetaMagicType put in is valid for using metamagic QUICKEN.
int SMP_GetIsMetaMagicTypeQuicken(int nMetaMagicType)
{
    return SMP_GetIsMetaMagicTypeValid(nMetaMagicType, SMP_METAMAGIC_TYPE_QUICKEN);
}
// Returns TRUE if nMetaMagicType put in is valid for using metamagic SILENT.
int SMP_GetIsMetaMagicTypeSilent(int nMetaMagicType)
{
    return SMP_GetIsMetaMagicTypeValid(nMetaMagicType, SMP_METAMAGIC_TYPE_SILENT);
}
// Returns TRUE if nMetaMagicType put in is valid for using metamagic STILL.
int SMP_GetIsMetaMagicTypeStill(int nMetaMagicType)
{
    return SMP_GetIsMetaMagicTypeValid(nMetaMagicType, SMP_METAMAGIC_TYPE_STILL);
}
// Returns TRUE if nMetaMagicType put in can have no metamagic applied.
int SMP_GetIsMetaMagicTypeNone(int nMetaMagicType)
{
    return SMP_GetIsMetaMagicTypeValid(nMetaMagicType, SMP_METAMAGIC_TYPE_NONE);
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
