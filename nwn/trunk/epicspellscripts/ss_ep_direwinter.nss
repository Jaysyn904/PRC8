//:://////////////////////////////////////////////
//:: FileName: "ss_ep_direwinter"
/*   Purpose: Dire Winter - turns entire area the spell was cast in into a
        winter-wonderland.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"

void DoWinterCheck(object oArea, float fDuration);

const int X2_TL_GROUNDTILE_ICE = 426;

void TLChangeAreaGroundTiles(object oArea, int nGroundTileConst, int nColumns, int nRows, float fZOffset = -0.4f )
{
    // Author: Brad "Cutscene" Prince
    // * flood area with tiles
    object oTile;
    // * put ice everywhere
    vector vPos;
    vPos.x = 5.0;
    vPos.y = 0.0;
    vPos.z = fZOffset;
    float fFace = 0.0;
    location lLoc;

    // * fill x axis
    int i, j;
    for (i=0 ; i <= nColumns; i++)
    {
        vPos.y = -5.0;
        // fill y
        for (j=0; j <= nRows; j++)
        {
            vPos.y = vPos.y + 10.0;
            lLoc = Location(oArea, vPos, fFace);
            // Ice tile (even though it says water).
            oTile = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc,FALSE, "x2_tmp_tile");
            SetPlotFlag(oTile,TRUE);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(nGroundTileConst), oTile);
        }
        vPos.x = vPos.x + 10.0;
    }

}

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DIREWIN))
    {
        object oArea = GetArea(OBJECT_SELF);
        float fDuration = HoursToSeconds(20) - 6.0;
        TLChangeAreaGroundTiles(oArea, X2_TL_GROUNDTILE_ICE, 32, 32, 0.3);
        SetWeather(oArea, WEATHER_SNOW);
        // Add icy look to all placeables in area.
        effect eIce = EffectVisualEffect(VFX_DUR_ICESKIN);
        object oItem = GetFirstObjectInArea(oArea);
        while (oItem != OBJECT_INVALID)
        {
            if (GetObjectType(oItem) == OBJECT_TYPE_PLACEABLE)
            {
                float fDelay = PRCGetRandomDelay();
                DelayCommand(fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eIce, oItem, fDuration, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
            }
            oItem = GetNextObjectInArea(oArea);
        }
        DelayCommand(6.0, DoWinterCheck(oArea, fDuration));
        DelayCommand(fDuration, SetWeather(oArea, WEATHER_USE_AREA_SETTINGS));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void DoWinterCheck(object oArea, float fDuration)
{
    int nDam;
    effect eDam;
    object oTarget = GetFirstObjectInArea(oArea);
    while (oTarget != OBJECT_INVALID)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            nDam = d6(2);
            eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
        oTarget = GetNextObjectInArea(oArea);
    }
    fDuration -= 6.0;
    if (fDuration > 1.0)
        DelayCommand(6.0, DoWinterCheck(oArea, fDuration));
}
