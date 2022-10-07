/*:://////////////////////////////////////////////
//:: Spell Name Insect Plague
//:: Spell FileName PHS_S_InsectPlag
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Insect Plague
    Conjuration (Summoning)
    Level: Clr 5, Drd 5
    Components: V, S, DF
    Casting Time: 1 round
    Range: Long (40M)
    Effect: One swarm of locusts per three levels, each of which must be adjacent
            to at least one other swarm
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: No

    You summon a number of swarms of locusts (one per three levels, to a maximum
    of six swarms at 18th level). The swarms must be summoned so that each one
    is adjacent to at least one other swarm (that is, the swarms must fill one
    contiguous area). You may summon the locust swarms so that they share the
    area of other creatures. Each swarm attacks any creatures occupying its area.
    The swarms are stationary after being summoned, and won’t pursue creatures
    that flee.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    How this works:
    - Create a new creature object to the stats of the locust swarm, and use a
      new appearance or something for it.
    - Apply Cutseen Ghost on in its OnSpawn.

    The creature is set as immobile. If they are spread out (too far from
    a corresponding creature) it will depissitate, as well when the duration
    runs out.

    Need to test some things before this can be correctly implimented.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_INSECT_PLAGUE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();  // Should be OBJECT_SELF.
    location lTarget = GetLocation(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sResRef = "phs_insectplague";
    int nCnt;
    object oLight;

    // Duration is 1 minute a level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Limit of 1 per 3 caster levels
    int nLimit = PHS_LimitInteger(nCasterLevel/3, 6);

    // Declare effect for the caster to check for
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // TO DO TO DO


    // Signal Event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INSECT_PLAGUE, FALSE);

    // New eDur effect on you
    PHS_ApplyDuration(oTarget, eDur, fDuration);

    // Create the creatures
    for(nCnt = 1; nCnt <= nLimit; nCnt++)
    {

    }
}
