/*:://////////////////////////////////////////////
//:: Spell Name Create Water
//:: Spell FileName PHS_S_CreateWatr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Close (8M) Effect: Up to 2 gallons of water/level

    This spell generates wholesome, drinkable water, just like clean rain water.
    Water can be created in an area as small as will actually contain the liquid,
    or in an area three times as large-possibly creating a downpour or filling
    many small receptacles.

    Note: Conjuration spells can’t create substances or objects within a
    creature. Water weighs about 8 pounds per gallon. One cubic foot of water
    contains roughly 8 gallons and weighs about 60 pounds.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This can be a clever spell.

    2 gallons/level is quite a lot at higher levels.

    We can say:

    - At levels 1+, we can cast it so it fills a bottle/level (need empty
      bottles, automatically filled)
    - At levels 12+, it is enough to create a visual effect, and also stop
      the burning effect of some spells for a short duration (25% fire immunity
      for X seconds)
    - At levels 19+, it can rain for a short duration, which may extinguish
      fires and fire-based spells. It is a % chance per level over 15, against
      the DC of the AOE's caster level. VERY small chance, mind you.
        - Spells are: Wall of fire, ....
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CREATE_WATER)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    // Caster Levels, MetaMagic, Save DC, Spell ID
    int nCasterLevel = PHS_GetCasterLevel();

}
