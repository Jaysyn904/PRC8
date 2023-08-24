//::///////////////////////////////////////////////
//:: Psionic Focus spellscript
//:: psi_psionic_foc
//::///////////////////////////////////////////////
/** @file
    Does a concentration check to see if the user
    gains psionic focus.

    In the event this is used while already focused,
    it will still run the GainPsionicFocus() -
    function.

    @author Modified by - Ornedan
    @date   Modified on - 2005.03.23
    @date   Modified on - 2005.12.30
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetCurrentPowerPoints(oPC) == 0)
    {
        SendMessageToPCByStrRef(oPC, 16824068); // "You do not have any Power Points, you cannot become Psionically Focused"
        return;
    }

    if(GetIsPsionicallyFocused(oPC))
    {
        SendMessageToPCByStrRef(oPC, 16824065); // "You are already Psionically Focused."
        GainPsionicFocus(oPC); // Recheck the bonuses associated with Psionic Focus
        return;
    }
    
    if (PRCGetSpellId() == 2822) // Psionic meditation feat
    {
        if(!TakeMoveAction(oPC)) return;
    }
    

    int nDC = 20;
    if(GetHasFeat(FEAT_NARROW_MIND, oPC))          nDC -= 4;
    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC)) nDC += 4; // Hack to avoid granting bonus from Combat manifestation where it should not be

    if(GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, nDC))
    {
        SendMessageToPCByStrRef(oPC, 16824066); // "You are now Psionically Focused."
        GainPsionicFocus(oPC);
    }
    else
        SendMessageToPCByStrRef(oPC, 16824067); // "You failed to become Psionically Focused."
}
