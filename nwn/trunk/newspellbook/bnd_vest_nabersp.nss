/**
 * @file
 * Spellscript for Naberius Vestige
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    int nCasterLevel = GetBinderLevel(oBinder, VESTIGE_NABERIUS);
    int nDC = GetBinderDC(oBinder, VESTIGE_NABERIUS);
    int nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    // All of these are under the same cooldown
    if (nSLA == VESTIGE_NABERIUS_COMMAND_APPROACH ||
    nSLA == VESTIGE_NABERIUS_COMMAND_DROP ||
    nSLA == VESTIGE_NABERIUS_COMMAND_FALL ||
    nSLA == VESTIGE_NABERIUS_COMMAND_FLEE ||
    nSLA == VESTIGE_NABERIUS_COMMAND_HALT)
    {
    	if(!BindAbilCooldown(oBinder, VESTIGE_NABERIUS_COMMAND_APPROACH, VESTIGE_NABERIUS)) return;
    }	
    
    switch(nSLA){
        case VESTIGE_NABERIUS_DISGUISE_SELF_LEARN:
        {
            nSpell = SPELL_DISGUISE_SELF_LEARN;
            break;
        } 
        case VESTIGE_NABERIUS_DISGUISE_SELF_OPTIONS:
        {
            nSpell = SPELL_DISGUISE_SELF_OPTIONS;
            break;
        } 
        case VESTIGE_NABERIUS_DISGUISE_SELF_QS1:
        {
            nSpell = SPELL_DISGUISE_SELF_QS1;
            break;
        } 
        case VESTIGE_NABERIUS_DISGUISE_SELF_QS2:
        {
            nSpell = SPELL_DISGUISE_SELF_QS2;
            break;
        } 
        case VESTIGE_NABERIUS_DISGUISE_SELF_QS3:
        {
            nSpell = SPELL_DISGUISE_SELF_QS3;
            break;
        }    
        
        case VESTIGE_NABERIUS_COMMAND_APPROACH:
        {
            nSpell = SPELL_COMMAND_APPROACH;
            if (nCasterLevel >= 14) nSpell = SPELL_GREATER_COMMAND_APPROACH;
            break;
        } 
        case VESTIGE_NABERIUS_COMMAND_DROP:
        {
            nSpell = SPELL_COMMAND_DROP;
            if (nCasterLevel >= 14) nSpell = SPELL_GREATER_COMMAND_DROP;
            break;
        } 
        case VESTIGE_NABERIUS_COMMAND_FALL:
        {
            nSpell = SPELL_COMMAND_FALL;
            if (nCasterLevel >= 14) nSpell = SPELL_GREATER_COMMAND_FALL;
            break;
        } 
        case VESTIGE_NABERIUS_COMMAND_FLEE:
        {
            nSpell = SPELL_COMMAND_FLEE;
            if (nCasterLevel >= 14) nSpell = SPELL_GREATER_COMMAND_FLEE;
            break;
        } 
        case VESTIGE_NABERIUS_COMMAND_HALT:
        {
            nSpell = SPELL_COMMAND_HALT;
            if (nCasterLevel >= 14) nSpell = SPELL_GREATER_COMMAND_HALT;
            break;
        }         
    }

    DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);    
}
        