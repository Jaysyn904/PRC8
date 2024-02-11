#include "prc_alterations"
#include "prc_craft_inc"

void main()
{
    //struct ipstruct iptemp = GetIpStructFromString("1_*_1_*");
    //itemproperty ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);
    //PrintString(GetItemPropertyString(ip));
    DoDebug("fs_test: starting");
    //DoDebug(GetItemPropertyString(ip));
    object oPC = GetFirstPC();
    GetIsSkillSuccessful(oPC, SKILL_PERFORM, 10);
    GetIsSkillSuccessful(oPC, SKILL_PERFORM, 20);
    GetIsSkillSuccessful(oPC, SKILL_PERFORM, 20);
    GetIsSkillSuccessful(oPC, SKILL_PERFORM, 20);
    GetPRCIsSkillSuccessful(oPC, SKILL_PERFORM, 20, d20());
    GetPRCIsSkillSuccessful(oPC, SKILL_PERFORM, 20, 10);
    GetPRCIsSkillSuccessful(oPC, SKILL_PERFORM, 20, 20);
    GetIsSkillSuccessful(oPC, SKILL_PERFORM, 40);
    GetPRCIsSkillSuccessful(oPC, SKILL_PERFORM, 40, d20());
    GetIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, 10);
    GetIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, 40);
    GetIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, 1);
    //DoDebug(IntToString(PRCGetHasSpell(368, oPC)));
    DoDebug("fs_test: ending");
}
