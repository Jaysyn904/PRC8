/*:://////////////////////////////////////////////
//:: Spell Name Forbiddance: On Exit
//:: Spell FileName PHS_S_ForbiddncB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, creates an AOE:

    - Large and permament (takes 6 rounds to cast!)
    - Party members immune to its effects (And SR + Save applieS)
    - Always blocks Planar Travel
    - Does damage to those who don't enter in the first few seconds:
      - 1 Alignment difference, (EG: N cast, LN goes in) 6d6 damage (divine?) (will half)
      - 2 alignment difference, (EG: N cast, LG goes in) 12d6 damage. (divine?) (will half)

    Material component worth 4000 too!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_FORBIDDANCE);
}
