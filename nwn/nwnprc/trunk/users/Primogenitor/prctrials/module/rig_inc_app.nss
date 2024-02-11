object RandomizeItemAppearance(object oItem, int nAC = 0);

#include "random_inc"

// Creates a new copy of an item, while making a single change to the appearance of the item.
// Helmet models and simple items ignore iIndex.
// iType                            iIndex                      iNewValue
// ITEM_APPR_TYPE_SIMPLE_MODEL      [Ignored]                   Model #
// ITEM_APPR_TYPE_WEAPON_COLOR      ITEM_APPR_WEAPON_COLOR_*    1-4
// ITEM_APPR_TYPE_WEAPON_MODEL      ITEM_APPR_WEAPON_MODEL_*    Model #
// ITEM_APPR_TYPE_ARMOR_MODEL       ITEM_APPR_ARMOR_MODEL_*     Model #
// ITEM_APPR_TYPE_ARMOR_COLOR       ITEM_APPR_ARMOR_COLOR_*     0-63
//
// Unlike biowares version, this will only return a valid combo
object CheckedCopyItemAndModify(object oItem, int nType, int nIndex, int nNewValue, int bCopyVars=TRUE)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
        DoDebug("oItem is not valid going into CheckedCopyItemAndModify");
        return OBJECT_INVALID;
    }
    string sTag = "RIG_WP_BaseItem_"+IntToString(GetBaseItemType(oItem));
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation(), FALSE, sTag);
    //sanity checks
    if(!GetIsObjectValid(oWP))
        return OBJECT_INVALID;
    object oTest = OBJECT_INVALID;
    int nIsValid = GetLocalInt(oWP, "Appear_"+IntToString(nType)+"_"+IntToString(nIndex)+"_"+IntToString(nNewValue));
    if(nIsValid == 2)//not valid
    {
        oTest = OBJECT_INVALID;
    }
    else
    {
        oTest = CopyItemAndModify(oItem, nType, nIndex, nNewValue, bCopyVars);
        if(GetIsObjectValid(oTest))
            SetLocalInt(oWP, "Appear_"+IntToString(nType)+"_"+IntToString(nIndex)+"_"+IntToString(nNewValue), 1);
        else
            SetLocalInt(oWP, "Appear_"+IntToString(nType)+"_"+IntToString(nIndex)+"_"+IntToString(nNewValue), 2);
    }
    DestroyObject(oItem);
    return oTest;
}
object RandomizeItemAppearance(object oItem, int nAC = 0)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
        DoDebug("oItem is not valid going into RandomizeItemAppearance");
        return OBJECT_INVALID;
    }
    int nBaseItem = GetBaseItemType(oItem);
    int nModelType = StringToInt(Get2DACache("baseitems", "ModelType", nBaseItem));
    int nColourRow;
    int nArmorRow;
    int nValue;
    switch(nModelType)
    {
        case 0: //Simple
            nValue = StringToInt(GetRandomFrom2DA("rig_a_r", "random_default", nBaseItem));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, nValue);
            break;
        case 1: //Layered (simple with customizable colors, i.e. helmets & cloaks)
            nValue = StringToInt(GetRandomFrom2DA("rig_a_r", "random_default", nBaseItem));
            //cloaks cant have this done to them at this stage so hardcode avoid it
            if(nBaseItem != BASE_ITEM_CLOAK)
                oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, -1, nValue);
            //this is the colour scheme, uses semi-randomization
            nColourRow = StringToInt(GetRandomFrom2DA("rig_color_r", "random_default", 0));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, StringToInt(Get2DACache("rig_colour", "Cloth1", nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, StringToInt(Get2DACache("rig_colour", "Cloth2", nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, StringToInt(Get2DACache("rig_colour", "Leather1", nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, StringToInt(Get2DACache("rig_colour", "Leather2", nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, StringToInt(Get2DACache("rig_colour", "Metal1", nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, StringToInt(Get2DACache("rig_colour", "Metal2", nColourRow)));
            break;
        case 2: //Composite (weapons & poitions)
        {
            string sRow = GetRandomFrom2DA("rig_a_r", "random_default", nBaseItem);
            int nBottomModel = StringToInt(GetStringLeft(sRow, 2));
            int nMiddleModel = StringToInt(GetStringLeft(GetStringRight(sRow, GetStringLength(sRow)-2),  2));
            int nTopModel    = StringToInt(GetStringLeft(GetStringRight(sRow, GetStringLength(sRow)-4),  2));
            int nBottomColor = StringToInt(GetStringLeft(GetStringRight(sRow, GetStringLength(sRow)-6),  2));
            int nMiddleColor = StringToInt(GetStringLeft(GetStringRight(sRow, GetStringLength(sRow)-8),  2));
            int nTopColor    = StringToInt(GetStringLeft(GetStringRight(sRow, GetStringLength(sRow)-10), 2));
            nBottomModel = Random(nBottomModel)+1;
            nMiddleModel = Random(nMiddleModel)+1;
            nTopModel    = Random(nTopModel)   +1;
            nBottomColor = Random(nBottomColor)+1;
            nMiddleColor = Random(nMiddleColor)+1;
            nTopColor    = Random(nTopColor)   +1;
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM, nBottomModel);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE, nMiddleModel);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP,    nTopModel);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, nBottomColor);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, nMiddleColor);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP,    nTopColor);
        }
            break;
        case 3: //Armor
        {
            //should randomize model, but keep the same overall AC.
            nArmorRow = StringToInt(GetRandomFrom2DA("rig_armor_r", "random_default", nAC));
            int nRobe       = StringToInt(Get2DACache("rig_armor", "Robe",      nArmorRow));
            int nNeck       = StringToInt(Get2DACache("rig_armor", "Neck",      nArmorRow));
            int nTorso      = StringToInt(Get2DACache("rig_armor", "Torso",     nArmorRow));
            int nBelt       = StringToInt(Get2DACache("rig_armor", "Belt",      nArmorRow));
            int nPelvis     = StringToInt(Get2DACache("rig_armor", "Pelvis",    nArmorRow));
            int nLShoulder  = StringToInt(Get2DACache("rig_armor", "LShoulder", nArmorRow));
            int nLBicep     = StringToInt(Get2DACache("rig_armor", "LBicep",    nArmorRow));
            int nLForearm   = StringToInt(Get2DACache("rig_armor", "LForearm",  nArmorRow));
            int nLHand      = StringToInt(Get2DACache("rig_armor", "LHand",     nArmorRow));
            int nLThigh     = StringToInt(Get2DACache("rig_armor", "LThigh",    nArmorRow));
            int nLShin      = StringToInt(Get2DACache("rig_armor", "LShin",     nArmorRow));
            int nLFoot      = StringToInt(Get2DACache("rig_armor", "LFoot",     nArmorRow));
            int nRShoulder  = StringToInt(Get2DACache("rig_armor", "RShoulder", nArmorRow));
            int nRBicep     = StringToInt(Get2DACache("rig_armor", "RBicep",    nArmorRow));
            int nRForearm   = StringToInt(Get2DACache("rig_armor", "RForearm",  nArmorRow));
            int nRHand      = StringToInt(Get2DACache("rig_armor", "RHand",     nArmorRow));
            int nRThigh     = StringToInt(Get2DACache("rig_armor", "RThigh",    nArmorRow));
            int nRShin      = StringToInt(Get2DACache("rig_armor", "RShin",     nArmorRow));
            int nRFoot      = StringToInt(Get2DACache("rig_armor", "RFoot",     nArmorRow));

/*
DoDebug("nArmorRow = "+IntToString(nArmorRow));
DoDebug("nNeck = "+IntToString(nNeck));
DoDebug("nTorso = "+IntToString(nTorso));
DoDebug("nBelt = "+IntToString(nBelt));
DoDebug("nPelvis = "+IntToString(nPelvis));
DoDebug("nLShoulder = "+IntToString(nLShoulder));
DoDebug("nLBicep = "+IntToString(nLBicep));
DoDebug("nLForearm = "+IntToString(nLForearm));
DoDebug("nLHand = "+IntToString(nLHand));
DoDebug("nLThigh = "+IntToString(nLThigh));
DoDebug("nLShin = "+IntToString(nLShin));
DoDebug("nLFoot = "+IntToString(nLFoot));
DoDebug("nRShoulder = "+IntToString(nRShoulder));
DoDebug("nRBicep = "+IntToString(nRBicep));
DoDebug("nRForearm = "+IntToString(nRForearm));
DoDebug("nRHand = "+IntToString(nRHand));
DoDebug("nRThigh = "+IntToString(nRThigh));
DoDebug("nRShin = "+IntToString(nRShin));
DoDebug("nRFoot = "+IntToString(nRFoot));
*/

            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE,      nRobe);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT,      nBelt);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK,      nNeck);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO,     nTorso);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP,    nLBicep);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT,     nLFoot);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM,  nLForearm);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND,     nLHand);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN,     nLShin);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER, nLShoulder);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH,    nLThigh);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP,    nRBicep);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT,     nRFoot);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM,  nRForearm);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND,     nRHand);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN,     nRShin);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER, nRShoulder);
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH,    nRThigh);

            //this is the colour scheme, uses semi-randomization
            nColourRow = StringToInt(GetRandomFrom2DA("rig_color_r", "random_default", 0));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1,   StringToInt(Get2DACache("rig_colour", "Cloth1",   nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2,   StringToInt(Get2DACache("rig_colour", "Cloth2",   nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, StringToInt(Get2DACache("rig_colour", "Leather1", nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, StringToInt(Get2DACache("rig_colour", "Leather2", nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1,   StringToInt(Get2DACache("rig_colour", "Metal1",   nColourRow)));
            oItem = CheckedCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2,   StringToInt(Get2DACache("rig_colour", "Metal2",   nColourRow)));
        }
            break;
        default:
            //something odds going on here...
            DestroyObject(oItem);
            oItem = OBJECT_INVALID;
            break;
    }
    if(!GetIsObjectValid(oItem))
    {
//        DoDebug("Invalid appearance randomizing "+GetName(oItem));
        return OBJECT_INVALID;
    }
    return oItem;
}
