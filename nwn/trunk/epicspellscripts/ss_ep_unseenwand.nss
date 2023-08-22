//:://////////////////////////////////////////////
//:: FileName: "ss_ep_unseenwand"
/*   Purpose: Unseen Wanderer - grants a player target the "Wander Unseen"
        feat, which allows you to turn invisible/visible at will, permanently.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"
//#include "x2_inc_spellhook"
#include "x0_i0_position"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    object oTarget = PRCGetSpellTargetObject();
    if (GetIsObjectValid(oTarget) &&  // Is the target valid?
        !GetHasFeat(5028, oTarget) && // Does the target not already have the feat?
        GetIsPC(oTarget))             // Is the target a player?
    {
        if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_UNSEENW))
        {
            int nY;
            effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            float fAngle, fDist, fOrient;
            location lTarget = GetLocation(oTarget);
            location lNew, lNew2;
            float fDelay = 0.2;
            for (nY = 20; nY > 0; nY--) // Where in perimeter.
            {
                fAngle = IntToFloat(nY * 18);
                fDist = 1.1;
                fOrient = fAngle;
                lNew = GenerateNewLocationFromLocation
                    (lTarget, fDist, fAngle, fOrient);
                fAngle += 180.0;
                fOrient = fAngle;
                lNew2 = GenerateNewLocationFromLocation
                    (lTarget, fDist, fAngle, fOrient);
                DelayCommand(fDelay,
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lNew));
                DelayCommand(fDelay,
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lNew2));
                fDelay += 0.4;
            }
            DelayCommand(6.0, GiveFeat(oTarget, 428));
            FloatingTextStringOnCreature("You have gained the ability " +
                "to wander unseen at will!", oTarget, FALSE);
        }
    }
    else
        FloatingTextStringOnCreature("Spell failed - target already has this " +
            "ability.", OBJECT_SELF, FALSE);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

