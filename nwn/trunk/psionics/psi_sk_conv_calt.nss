//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Calculate status
//:: psi_sk_conv_calt
//::///////////////////////////////////////////////
/*
    Constructs the strings telling the current
    status of the mindblade enhancement.
    
    This is for the settings being built.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nFlags = GetLocalInt(oPC, MBLADE_FLAGS + "_T");
    // Build selections
    string sSelect = "";
    int bFirst = 1;

    if(nFlags & MBLADE_FLAG_LUCKY)              { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(1982); }
    if(nFlags & MBLADE_FLAG_DEFENDING)          { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824499); }
    if(nFlags & MBLADE_FLAG_KEEN)               { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(713); }
    if(nFlags & MBLADE_FLAG_VICIOUS)            { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824500); }
    if(nFlags & MBLADE_FLAG_PSYCHOKINETIC)      { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824501); }
    if(nFlags & MBLADE_FLAG_MIGHTYCLEAVING)     { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824502); }
    if(nFlags & MBLADE_FLAG_COLLISION)          { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824503); }
    if(nFlags & MBLADE_FLAG_MINDCRUSHER)        { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824504); }
    if(nFlags & MBLADE_FLAG_PSYCHOKINETICBURST) { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824505); }
    if(nFlags & MBLADE_FLAG_SUPPRESSION)        { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824506); }
    if(nFlags & MBLADE_FLAG_WOUNDING)           { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(741); }
    if(nFlags & MBLADE_FLAG_DISRUPTING)         { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824507); }
    if(nFlags & MBLADE_FLAG_SOULBREAKER)        { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824508); }    
    if(nFlags & MBLADE_FLAG_SHIELD_1)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +1"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_2)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +2"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_3)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +3"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_4)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +4"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_5)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +5"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_6)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +6"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_7)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +7"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_8)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +8"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_9)           { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +9"; }    
    if(nFlags & MBLADE_FLAG_SHIELD_10)          { sSelect += (bFirst-- > 0 ? "":" ,") + "Shield of Thought +10"; }        
    
    SetCustomToken(100, sSelect);
    
    // Build free enhancement boni
    SetCustomToken(101, IntToString(GetMaxEnhancementCost(oPC) - GetTotalEnhancementCost(nFlags)));
    
    // Always pass, this is just to get the tokens in
    return TRUE;
}