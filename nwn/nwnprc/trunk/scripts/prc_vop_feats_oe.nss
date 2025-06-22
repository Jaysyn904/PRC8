//:://////////////////////////////////////////////
//:: Restore VoP Bonus Feats OnClientEnter
//:: Uses prc_vop_feats.2da
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "inc_debug"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC) || GetIsDM(oPC)) return;

    int nRow = 0;
    int nFeat;
    string sFeatTag;

    int nRows = Get2DARowCount("prc_vop_feats");
    if (DEBUG) DoDebug("[VoPRestore] Checking " + IntToString(nRows) + " exalted feats...");

    while (nRow < nRows)
    {
        string sIndex = Get2DAString("prc_vop_feats", "FeatIndex", nRow);

        if (sIndex != "****" && sIndex != "")
        {
            nFeat = StringToInt(sIndex);
            sFeatTag = "VoPFeatID" + IntToString(nFeat);

            if (GetPersistantLocalInt(oPC, sFeatTag) == 1)
            {
                if (DEBUG) DoDebug("[VoPRestore] Restoring feat ID " + IntToString(nFeat));

                effect eFeat = EffectBonusFeat(nFeat);
                       eFeat = UnyieldingEffect(eFeat);
                       eFeat = TagEffect(eFeat, "VoPFeat" + IntToString(nFeat));

                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFeat, oPC);
            }
            else
            {
                // Only uncomment this line if you want to see *every* non-match
                // SendMessageToPC(oPC, "[VoPRestore] Not set: " + sFeatTag);
            }
        }
        else
        {
            if (DEBUG) DoDebug("[VoPRestore] Invalid FeatIndex at row " + IntToString(nRow));
        }

        nRow++;
    }

    if (DEBUG) DoDebug("[VoPRestore] Done.");
}


/* void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC) || GetIsDM(oPC)) return;

    int nRow = 0;
    int nFeat;
    string sFeatTag;

    int nRows = Get2DARowCount("prc_vop_feats");
    while (nRow < nRows)
    {
        // Read the feat index from the 2DA
        nFeat = StringToInt(Get2DACache("prc_vop_feats", "FeatIndex", nRow));
        sFeatTag = "VoPFeat" + IntToString(nFeat);

        // If the PC has a persistent variable set for this feat, reapply the effect
        if (GetPersistantLocalInt(oPC, sFeatTag) == 1)
        {
            effect eFeat = EffectBonusFeat(nFeat);
                   eFeat = UnyieldingEffect(eFeat);
                   eFeat = TagEffect(eFeat, sFeatTag);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFeat, oPC);
        }

        nRow++;
    }
} */