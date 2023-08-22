//:://////////////////////////////////////////////
//:: FileName: "ss_ep_piousparly"
/*   Purpose: Pious Parley - this spell will look at the Deity field on the
        caster, and will then use that to open the corresponding conversation
        for that god with the caster. If no deity name exists on the caster,
        a default conversation will open, telling them they're faithless.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "x0_i0_position"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_PIOUS_P))
    {
        string sDeity = GetDeity(OBJECT_SELF);
        string sDeityConv = "pparl_" + GetStringLeft(sDeity, 10);
        //Debug.
        //SendMessageToPC(OBJECT_SELF, "Deity = " + sDeity);
        //SendMessageToPC(OBJECT_SELF, "DeityConv = " + sDeityConv);

        location lLoc = GetLocation(OBJECT_SELF);
        location lNew;
        float fAngle, fDist, fOrient, fDelay;

        effect eDur = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
        effect eVisG = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
        effect eVisN = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        effect eVisE = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
        effect eE;
        effect eImp = EffectVisualEffect(VFX_IMP_HEALING_S);
        int nPray = ANIMATION_LOOPING_MEDITATE;
        int nX, nY;

        if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD) eE = eVisG;
        else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL) eE = eVisE;
        else eE = eVisN;

        AssignCommand(OBJECT_SELF, ActionPlayAnimation(nPray, 1.0, 6.0));
        fDelay = 0.2;
        for (nX = 10; nX > 0; nX--)
        {
            for (nY = 20; nY > 0; nY--)
            {
                fAngle = IntToFloat(nY * 18);
                fDist = IntToFloat(nX);
                fOrient = fAngle;
                lNew = GenerateNewLocationFromLocation
                    (lLoc, fDist, fAngle, fOrient);
                DelayCommand(fDelay,
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp, lNew));
            }
            fDelay += 0.4;
        }
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, 15.0, FALSE, -1, GetTotalCastingLevel(OBJECT_SELF));
        DelayCommand(4.0,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eE, lNew));

        //DelayCommand(4.9, AssignCommand(OBJECT_SELF, ClearAllActions()));
        DelayCommand(5.0, AssignCommand(OBJECT_SELF,
            ActionStartConversation(OBJECT_SELF,
            sDeityConv, TRUE, FALSE)));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

