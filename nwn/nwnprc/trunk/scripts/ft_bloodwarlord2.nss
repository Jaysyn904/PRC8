// Blood of the Warlord - On Exit
#include "prc_alterations"
#include "prc_spell_const"

void main()
{
    object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);
    object oExit = GetExitingObject();

    if (GetHasSpellEffect(SPELL_BLOOD_OF_THE_WARLORD, oExit))
    {
        PRCRemoveSpellEffects(SPELL_BLOOD_OF_THE_WARLORD, oCreator, oExit);
    }
}

