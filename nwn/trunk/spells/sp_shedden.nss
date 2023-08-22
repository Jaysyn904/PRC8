//////////////////////////////////////////////////////
// Shedden
// sp_shedden.nss
////////////////////////////////////////////////////////
/*
Shedden: This gray paste is brewed from the exoskeletons
of monstrous spiders ground with silk-based oils and mixed
with various chemicals and reagents. When spread on your
exposed flesh, it temporarily hardens your skin, granting
you a +1 bonus to natural armor for 2 minutes. This bonus
stacks with any other natural armor you already have. It takes
1 minute to apply shedden to your entire body and obtain its
benefits.
Shedden can be created with a DC 20 Craft (alchemy) check.
Certain master alchemists can create shedden that provides
natural armor bonuses of +2 to +5, but doing so raises the
Craft DC by 4 for each additional point of natural armor and
increases the price as follows: 200 gp for +2, 500 gp for +3,
1,000 gp for +4, and 2,000 gp for +5.*/

#include "prc_inc_spells"

void main()
{
        object oTarget = PRCGetSpellTargetObject();
        int nSpell = GetSpellId();
        int nBonus;

        if(nSpell == SPELL_SHEDDEN) nBonus = 1;

        else if (nSpell == SPELL_SHEDDEN2) nBonus = 2;

        else if (nSpell == SPELL_SHEDDEN3) nBonus = 3;

        else if (nSpell == SPELL_SHEDDEN4) nBonus = 4;

        else if (nSpell == SPELL_SHEDDEN5) nBonus = 5;

        else return;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(nBonus, AC_NATURAL_BONUS), oTarget, TurnsToSeconds(2));
}