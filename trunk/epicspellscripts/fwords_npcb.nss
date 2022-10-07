//:://////////////////////////////////////////////
//:: FileName: "fwords_npcb"
/*   Purpose:
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "x0_i0_position"
#include "prc_alterations"
#include "inc_dispel"
#include "inc_epicspells"

location GetOppositeLoc(object oTarget);

void main()
{
    object oPC = OBJECT_SELF;
    float fDur = 1200.0f; // 20 minutes max, or NPC destroys self at end of conv
    // Create the NPC fiend in front of oPC.
    location lNPC = GetOppositeLoc(oPC);
    object oNPC = CreateObject(OBJECT_TYPE_CREATURE, "fiendw_npcb", lNPC);
    effect eGhost = EffectCutsceneGhost();
    effect eEther = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    effect eHold = EffectCutsceneImmobilize();
    effect eLink = EffectLinkEffects(eGhost, eEther);
    eLink = EffectLinkEffects(eLink, eHold);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oNPC, fDur, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF));
    SetPlotFlag(oNPC, TRUE);
    // Initiate a conversation with the PC.
    AssignCommand(oNPC, ActionStartConversation(oPC, "", TRUE, FALSE));
    // After the maximum duration, destroy the NPC (sever the connection).
    DelayCommand(fDur, SetPlotFlag(oNPC, FALSE));
    DelayCommand(fDur, DestroyObject(oNPC));
}

location GetOppositeLoc(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngleOpposite = GetOppositeDirection(fDir);
    return GenerateNewLocation(oTarget,
                               1.5f,
                               fDir,
                               fAngleOpposite);
}

