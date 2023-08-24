//////////////////////////////////////////////////////////
// Unseen Weapon: Activate
// prc_sb_uwactiv.nss
/////////////////////////////////////////////////////////
#include "prc_inc_combat"
void main()
{
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        effect eVis;
        int nUnexpect = GetLocalInt(oPC, "PRC_SB_UNEXPECTED");
        int nEphemeral = GetLocalInt(oPC, "PRC_SB_EPHEMERAL");
        int nShadowy   = GetLocalInt(oPC, "PRC_SB_SHADOWY");

        if(nShadowy) eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION);

        if(nEphemeral)
        {
                if(nUnexpect) AssignCommand(oTarget, ClearAllActions(TRUE));
                PerformAttack(oTarget, oPC, eVis, 0.0f, 0, d6(2), DAMAGE_TYPE_MAGICAL, "","", nShadowy);
        }

        else
        {
                if(nUnexpect) AssignCommand(oTarget, ClearAllActions(TRUE));
                PerformAttack(oTarget, oPC, eVis, 0.0f, 0, 0, 0, "", "", nShadowy);
        }

        //Clean up
        DeleteLocalInt(oPC, "PRC_SB_UNEXPECTED");
        DeleteLocalInt(oPC, "PRC_SB_EPHEMERAL");
        DeleteLocalInt(oPC, "PRC_SB_SHADOWY");
        DeleteLocalInt(oPC, "PRC_SB_UNERRING");
}