//::///////////////////////////////////////////////
//:: PRC Spellbook NUI Events
//:: prc_nui_sb_event
//:://////////////////////////////////////////////
/*
    This is the event script for the PRC Spellbook NUI that handles button presses
    and the like
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 24.05.2005
//:://////////////////////////////////////////////

#include "prc_nui_consts"
#include "prc_nui_sb_inc"
#include "prc_nui_sbd_inc"

//
// SetWindowGeometry
// Saves the window geometry of the NUI Spellbook to the player so next time it
// renders it remembers where it was
//
// Arguments:
//   oPlayer:object player tied to NUI
//   nToken:int the NUI Spellbook window
//
void SetWindowGeometry(object oPlayer, int nToken);

//
// DetermineRangeForSpell
// Takes the string range from the spells.2da of a spell and converts it to
// the appropriate float range for the manual targetting mode
//
// Arguments:
//   sRange:string the string range of the spell (P,T,S,M,L)
//
// Returns:
//   float The flaot representation of the sRange provided
//
float DetermineRangeForSpell(string sRange);

//
// DetermineShapeForSpell
// Takes the string shape from the spells.2da of a spell and converts it to
// the int representation of the spell's shape. This is case sensitive and
// has to be in all UpperCase
//
// Arguments:
//   shape:string the string shape of the spell (SPHERE,CONE, etc.)
//
// Returns:
//   int the int representation of the shape provided
//
int DetermineShapeForSpell(string shape);

//
// DetermineTargetType
// Takes the string (actually hex) target type from the spells.2da of a spell and convers it to
// the int representation of the spell's target type. How this works is a bit unintuitive but
// it converts the string hex to a int, then subtracts it by the powers of 2. Each power represents
// the target the spell is allowed to be used on as all the ints are bitwise added together
//
// Arguments:
//   targetType:string the hex value of the target type as a string.
//
// Returns:
//   int the bitwise int representation of the targetType
int DetermineTargetType(string targetType);

void main()
{
    object oPlayer   = NuiGetEventPlayer();
    int nToken               = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);

    // if this was the Spell Description NUI and the OK button was clicked
    // then we close the window.
    if (sWindowId == NUI_SPELL_DESCRIPTION_WINDOW_ID)
    {
        if (sElement == NUI_SPELL_DESCRIPTION_OK_BUTTON)
            NuiDestroy(oPlayer, nToken);
        return;
    }

    // if the window is closed, save the geometry
    if (sEvent == "close")
    {
        SetWindowGeometry(oPlayer, nToken);
        return;
    }

    // Not a mouseup event, nothing to do.
    if (sEvent != "mouseup")
    {
        return;
    }

    // Save the geometry first
    SetWindowGeometry(oPlayer, nToken);

    int spellId;
    int featId;
    int realSpellId;

    // Checks to see if the event button has the class button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the ClassID gathered. (i.e. "test_123" gets converted to 123)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_CLASS_BUTTON_BASEID) >= 0)
    {
        int classId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_CLASS_BUTTON_BASEID, sElement, ""));
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR, classId);
        ExecuteScript("prc_nui_sb_view", oPlayer);
        return;
    }

    // Checks to see if the event button has the circle button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the circle number gathered. (i.e. "test_5" gets converted to 5)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID) >= 0)
    {
        int circle = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID, sElement, ""));
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, circle);
        ExecuteScript("prc_nui_sb_view", oPlayer);
        return;
    }

    // Checks to see if the event button has the meta button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the SpellID gathered. (i.e. "test_123" gets converted to 123)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_META_BUTTON_BASEID) >= 0)
    {
        spellId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_META_BUTTON_BASEID, sElement, ""));
        int masterSpellId = StringToInt(Get2DACache("spells", "Master", spellId));
        if (masterSpellId)
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR, spellId);
            featId = StringToInt(Get2DACache("spells", "FeatID", masterSpellId));
        }
        else
            featId = StringToInt(Get2DACache("spells", "FeatID", spellId));
    }

    // Checks to see if the event button has the class button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the SpellbookID gathered. (i.e. "test_123" gets converted to 123)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_SPELL_BUTTON_BASEID) >= 0)
    {
        int spellbookId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_SPELL_BUTTON_BASEID, sElement, ""));
        int classId = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);

        // special case for binders, since they don't have a spell 2da of their own.
        if (classId == CLASS_TYPE_BINDER)
        {
            json binderDict = GetBinderSpellToFeatDictionary(oPlayer);
            spellId = spellbookId;
            featId = JsonGetInt(JsonObjectGet(binderDict, IntToString(spellId)));
            int masterSpellId = StringToInt(Get2DACache("spells", "Master", spellId));
            if (masterSpellId)
            {
                SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR, spellId);
                featId = StringToInt(Get2DACache("spells", "FeatID", masterSpellId));
            }
            else
                featId = StringToInt(Get2DACache("spells", "FeatID", spellId));

        }
        else
        {
            string sFile = GetClassSpellbookFile(classId);

            spellId = StringToInt(Get2DACache(sFile, "SpellID", spellbookId));
            realSpellId = StringToInt(Get2DACache(sFile, "RealSpellID", spellbookId));

            int masterSpellId = StringToInt(Get2DACache("spells", "Master", spellId));
            // If this spell is part of a radial we need to send the master featID
            // to be used along with the radial spellId
            if (masterSpellId)
            {
                SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR, spellId);
                featId = StringToInt(Get2DACache("spells", "FeatID", masterSpellId));
            }
            else
                featId = StringToInt(Get2DACache("spells", "FeatID", spellId));
        }
    }

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

    // If right click, open the Spell Description NUI
    if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
    {
        CreateSpellDescriptionNUI(oPlayer, featId, spellId, realSpellId);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        return;
    }
    // If left click, operate normally
    if (nButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK)
    {

        // We use the spell's FeatID to do actions, and we set the OnTarget action
        // to PRC_NUI_SPELLBOOK so the handler knows what the action is being done
        SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_FEATID_VAR, featId);

        string sRange = GetStringUpperCase(Get2DACache("spells", "Range", spellId));
        // If its a personal spell/feat than use it directly on the player.
        if (sRange == "P")
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT, 1);
            ExecuteScript("prc_nui_sb_trggr", oPlayer);
        }
        // otherwise enter targetting mode
        else
        {
            SetLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR, "PRC_NUI_SPELLBOOK");

            // These gather the targetting information for the TargetingMode functions
            float fRange = DetermineRangeForSpell(sRange);
            string sShape = GetStringUpperCase(Get2DACache("spells", "TargetShape", spellId));
            int iShape = DetermineShapeForSpell(sShape);
            float fSizeX = StringToFloat(Get2DACache("spells", "TargetSizeX", spellId));
            float fSizeY = StringToFloat(Get2DACache("spells", "TargetSizeY", spellId));
            int nFlags = StringToInt(Get2DACache("spells", "TargetFlags", spellId));
            string sTargetType = Get2DACache("spells", "TargetType", spellId);
            int iTargetType = DetermineTargetType(sTargetType);

            SetEnterTargetingModeData(oPlayer, iShape, fSizeX, fSizeY, nFlags, fRange);
            EnterTargetingMode(oPlayer, iTargetType);
        }
    }
}

void SetWindowGeometry(object oPlayer, int nToken)
{
    json dimensions = NuiGetBind(oPlayer, nToken, "geometry");
    SetLocalJson(oPlayer, PRC_SPELLBOOK_NUI_GEOMETRY_VAR, dimensions);
}

int DetermineShapeForSpell(string shape)
{
    if (shape == "CONE")
    {
        return SPELL_TARGETING_SHAPE_CONE;
    }
    if (shape == "SPHERE")
    {
        return SPELL_TARGETING_SHAPE_SPHERE;
    }
    if (shape == "RECTANGLE")
    {
        return SPELL_TARGETING_SHAPE_RECT;
    }
    if (shape == "HSPHERE")
    {
        return SPELL_TARGETING_SHAPE_HSPHERE;
    }

    return SPELL_TARGETING_SHAPE_NONE;
}

float DetermineRangeForSpell(string sRange)
{
    //Personal
    if (sRange == "P")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 0));
    }
    //Touch
    if(sRange == "T")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 1));
    }
    //Short
    if(sRange == "S")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 2));
    }
    //Medium
    if(sRange == "M")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 3));
    }
    //Long
    if(sRange == "L")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 4));
    }

    return 0.0;
}

int DetermineTargetType(string targetType)
{
    int retValue = -1;
    int iTargetType = HexToInt(targetType);

    if (iTargetType - 64 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_TRIGGER;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_TRIGGER;
        }
        iTargetType -= 64;
    }
    if (iTargetType - 32 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_PLACEABLE;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_PLACEABLE;
        }
        iTargetType -= 32;
    }
    if (iTargetType - 16 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_DOOR;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_DOOR;
        }
        iTargetType -= 16;
    }
    if (iTargetType - 8 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_ITEM;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_ITEM;
        }
        iTargetType -= 8;
    }
    if (iTargetType - 4 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_TILE;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_TILE;
        }

        iTargetType -= 4;
    }
    if (iTargetType - 2 >= 0 || iTargetType - 1 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_CREATURE;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_CREATURE;
        }
        iTargetType = 0;
    }

    return retValue;
}
