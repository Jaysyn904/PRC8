//::///////////////////////////////////////////////
//:: Turn off all Psionic Focus-based abilities
//:: psi_toff_focab
//::///////////////////////////////////////////////
/*
    Switches off all the abilities that would
    cause psionic focus expenditure when manifesting.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 25.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;

    int bFirst = 1;
    string sTurnedOff = "";


    // Metapsionics
    if(GetLocalInt(oPC, METAPSIONIC_CHAIN_VAR))    { SetLocalInt(oPC, METAPSIONIC_CHAIN_VAR,   FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826532); }
    if(GetLocalInt(oPC, METAPSIONIC_EMPOWER_VAR))  { SetLocalInt(oPC, METAPSIONIC_EMPOWER_VAR, FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826534); }
    if(GetLocalInt(oPC, METAPSIONIC_EXTEND_VAR))   { SetLocalInt(oPC, METAPSIONIC_EXTEND_VAR,  FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826536); }
    if(GetLocalInt(oPC, METAPSIONIC_MAXIMIZE_VAR)) { SetLocalInt(oPC, METAPSIONIC_MAXIMIZE_VAR,FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826538); }
    if(GetLocalInt(oPC, METAPSIONIC_SPLIT_VAR))    { SetLocalInt(oPC, METAPSIONIC_SPLIT_VAR,   FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826540); }
    if(GetLocalInt(oPC, METAPSIONIC_TWIN_VAR))     { SetLocalInt(oPC, METAPSIONIC_TWIN_VAR,    FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826542); }
    if(GetLocalInt(oPC, METAPSIONIC_WIDEN_VAR))    { SetLocalInt(oPC, METAPSIONIC_WIDEN_VAR,   FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826544); }
    if(GetLocalInt(oPC, METAPSIONIC_QUICKEN_VAR))  { SetLocalInt(oPC, METAPSIONIC_QUICKEN_VAR, FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826651); }


    // Others
    if(GetLocalInt(oPC, "PsionicEndowmentActive"))    { SetLocalInt(oPC, "PsionicEndowmentActive",    FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + (GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT, oPC) ? GetStringByStrRef(16826454):GetStringByStrRef(16826452)); }
    if(GetLocalInt(oPC, "PowerPenetrationActive"))    { SetLocalInt(oPC, "PowerPenetrationActive",    FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + (GetHasFeat(FEAT_GREATER_POWER_PENETRATION, oPC) ? GetStringByStrRef(16826438):GetStringByStrRef(16826438)); }
    if(GetLocalInt(oPC, "PowerSpecializationActive")) { SetLocalInt(oPC, "PowerSpecializationActive", FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826446); }
    if(GetLocalInt(oPC, "TalentedActive"))            { SetLocalInt(oPC, "TalentedActive",            FALSE); sTurnedOff += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826499); }

    if(bFirst < 1)
        FloatingTextStringOnCreature(sTurnedOff + " " + GetStringByStrRef(63799/*Deactivated*/), oPC, FALSE);

    PrintString("bFirst: " + IntToString(bFirst) + "\nSturnedOff: " + sTurnedOff);
}