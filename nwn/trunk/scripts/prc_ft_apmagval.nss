//::///////////////////////////////////////////////
//:: Appraise Magic Value
//::
/*
    Roll an appraise check to determine the value of an item
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 26, 2008
//:://////////////////////////////////////////////

#include "prc_inc_nwscript"

int AppraiseItem(object item)
{
    int gp = GetGoldPieceValue(item);
    int nAppraise;

    if (gp<10)      nAppraise = 0;
    if (gp==10)     nAppraise = 1;
    if (gp>11)      nAppraise = 2;
    if (gp>50)      nAppraise = 3;
    if (gp>101)     nAppraise = 4;
    if (gp>151)     nAppraise = 5;
    if (gp>201)     nAppraise = 6;
    if (gp>301)     nAppraise = 7;
    if (gp>401)     nAppraise = 8;
    if (gp>501)     nAppraise = 9;
    if (gp>1001)    nAppraise = 10;
    if (gp>2501)    nAppraise = 11;
    if (gp>3751)    nAppraise = 12;
    if (gp>4801)    nAppraise = 13;
    if (gp>6501)    nAppraise = 14;
    if (gp>9501)    nAppraise = 15;
    if (gp>13001)   nAppraise = 16;
    if (gp>17001)   nAppraise = 17;
    if (gp>20001)   nAppraise = 18;
    if (gp>30001)   nAppraise = 19;
    if (gp>40001)   nAppraise = 20;
    if (gp>50001)   nAppraise = 21;
    if (gp>60001)   nAppraise = 22;
    if (gp>80001)   nAppraise = 23;
    if (gp>100001)  nAppraise = 24;
    if (gp>150001)  nAppraise = 25;
    if (gp>200001)  nAppraise = 26;
    if (gp>250001)  nAppraise = 27;
    if (gp>300001)  nAppraise = 28;
    if (gp>350001)  nAppraise = 29;
    if (gp>400001)  nAppraise = 30;
    if (gp>500001)
    {
        gp = gp - 500000;
        gp = gp / 100000;
        nAppraise = gp + 31;
    }
    return nAppraise;
}

void main()
{
        object oItem = PRCGetSpellTargetObject();
        effect eVis;
        int nDC = AppraiseItem(oItem);
        int nSkill = GetIsSkillSuccessful(OBJECT_SELF, SKILL_APPRAISE, nDC + 10);

        if (nSkill && GetIdentified(oItem))
        {
             eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
             FloatingTextStringOnCreature("The value of " + GetName(oItem) + " is " + IntToString(GetGoldPieceValue(oItem)), OBJECT_SELF, FALSE);
        }
        else
        {
             eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
        }

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
}