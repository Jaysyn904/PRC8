//::///////////////////////////////////////////////
//:: Identification
//::
/*
    Roll a spellcraft check to attempt to ID an item.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 15, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

int LoreItem(object item)
{
    int id=0;
    if (!GetIdentified(item))
    {
        id=1;
        SetIdentified(item,TRUE);
    }
    int gp = GetGoldPieceValue(item);
    int nLore;

    if (gp<10)  nLore= 0;
    if (gp==10)     nLore= 1;
    if (gp>11)  nLore= 2;
    if (gp>50)  nLore= 3;
    if (gp>101)     nLore= 4;
    if (gp>151)     nLore= 5;
    if (gp>201)     nLore= 6;
    if (gp>301)     nLore= 7;
    if (gp>401)     nLore= 8;
    if (gp>501)     nLore= 9;
    if (gp>1001)    nLore= 10;
    if (gp>2501)    nLore= 11;
    if (gp>3751)    nLore= 12;
    if (gp>4801)    nLore= 13;
    if (gp>6501)    nLore= 14;
    if (gp>9501)    nLore= 15;
    if (gp>13001)   nLore= 16;
    if (gp>17001)   nLore= 17;
    if (gp>20001)   nLore= 18;
    if (gp>30001)   nLore= 19;
    if (gp>40001)   nLore= 20;
    if (gp>50001)   nLore= 21;
    if (gp>60001)   nLore= 22;
    if (gp>80001)   nLore= 23;
    if (gp>100001)  nLore= 24;
    if (gp>150001)  nLore= 25;
    if (gp>200001)  nLore= 26;
    if (gp>250001)  nLore= 27;
    if (gp>300001)  nLore= 28;
    if (gp>350001)  nLore= 29;
    if (gp>400001)  nLore= 30;
    if (gp>500001)
    {
        gp= gp - 500000;
        gp = gp / 100000;
        nLore = gp + 31;
    }
    if (id) SetIdentified(item,FALSE);
    return nLore;
}

void main()
{
    object oItem = PRCGetSpellTargetObject();

    if (!GetLocalInt(oItem, "MaesterID"))
    {
        effect eVis;

        int nDC = LoreItem(oItem);
        int nSkill = GetIsSkillSuccessful(OBJECT_SELF, SKILL_SPELLCRAFT, nDC);

        if (nSkill)
        {
             eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
             SetIdentified(oItem, TRUE);
        }
        else
        {
             eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
        }

        SetLocalInt(oItem, "MaesterID", TRUE);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    }
}

