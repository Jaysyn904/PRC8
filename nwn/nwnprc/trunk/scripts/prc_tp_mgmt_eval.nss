//::///////////////////////////////////////////////
//:: Teleport management feat evaluation script
//:: prc_tp_mgmt_eval
//::///////////////////////////////////////////////
/** @file
    This script checks for the presence of the
    teleport management feat radial on OBJECT_SELF.
    If it's missing, it is added via an itemproperty
    on the hide.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_alterations"


void main()
{
    if(!GetHasFeat(FEAT_TELEPORT_MANAGEMENT_RADIAL, OBJECT_SELF))
    {
        object oSkin = GetPCSkin(OBJECT_SELF);

        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TELEPORT_MANAGEMENT_RADIAL), oSkin);
    }
}