//::///////////////////////////////////////////////
//:: Desecrate
//:: prc_tn_des_a
//::///////////////////////////////////////////////
/*
Desecrate
Evocation [Evil]
Level:            Clr 2, Evil 2
Components:       V, S, M, DF
Casting Time:     1 standard action
Range:            Close (25 ft. + 5 ft./2 levels)
Area:             20-ft.-radius emanation
Duration:         2 hours/level
Saving Throw:     None
Spell Resistance: Yes

This spell imbues an area with negative energy. Each
Charisma check made to turn undead within this area
takes a -3 profane penalty, and every undead creature
entering a desecrated area gains a +1 profane bonus
on attack rolls, damage rolls, and saving throws. An
undead creature created within or summoned into such
an area gains +1 hit points per HD.

If the desecrated area contains an altar, shrine, or
other permanent fixture dedicated to your deity or
aligned higher power, the modifiers given above are
doubled (-6 profane penalty on turning checks, +2
profane bonus and +2 hit points per HD for undead in
the area).

Furthermore, anyone who casts animate dead within
this area may create as many as double the normal
amount of undead (that is, 4 HD per caster level
rather than 2 HD per caster level).

If the area contains an altar, shrine, or other
permanent fixture of a deity, pantheon, or higher
power other than your patron, the desecrate spell
instead curses the area, cutting off its connection
with the associated deity or power. This secondary
function, if used, does not also grant the bonuses
and penalties relating to undead, as given above.

Desecrate counters and dispels consecrate.

Material Component
A vial of unholy water and 25 gp worth (5 pounds)
of silver dust, all of which must be sprinkled
around the area.
*/

#include "prc_alterations"

void main()
{
    object oTarget = GetEnteringObject();

    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        // Prevent stacking — only apply once per source
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectCreator(eTest) == GetAreaOfEffectCreator() &&
               GetStringLeft(GetEffectTag(eTest), 11) == "EFFECT_DESE")
            {
                return; // Already has desecrate from this AOE
            }
            eTest = GetNextEffect(oTarget);
        }

        effect eLink = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_NEGATIVE);
               eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1));
               eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
			   eLink = EffectLinkEffects(eLink, EffectTurnResistanceIncrease(3));
			   
        effect eHP = EffectTemporaryHitpoints(GetHitDice(oTarget));
        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

        // Give a unique tag so it can be recognized later
        eLink = TagEffect(eLink, "EFFECT_DESECRATE_AURA");
        eHP   = TagEffect(eHP,   "EFFECT_DESECRATE_HP");

        if(!GetPRCSwitch(PRC_TRUE_NECROMANCER_ALTERNATE_VISUAL))
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        else
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));

        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, SPELL_DESECRATE);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, oTarget, 0.0f, SPELL_DESECRATE);
    }
	else  
	{  
		// Apply visual indicator for non-undead
		effect eIcon = EffectIcon(EFFECT_ICON_FRIGHTENED);
		effect eVis	= EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
		//effect eLink = EffectLinkEffects(eIcon, eVis);
		effect eLink = EffectLinkEffects(eLink, eVis);
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));
		eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 1));

				eLink = TagEffect(eLink, "EFFECT_DESECRATE_AURA");
		
		SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, SPELL_DESECRATE);  
	}
}


/* void main()
{
    object oTarget = GetEnteringObject();

    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        effect eLink = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_NEGATIVE);
               eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1));
               eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eHP = EffectTemporaryHitpoints(GetHitDice(oTarget));
        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

        if(!GetPRCSwitch(PRC_TRUE_NECROMANCER_ALTERNATE_VISUAL))
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        //rather than a big flashy holy aid effect, the alternative is a minor evil red glow
        else
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, oTarget);
    }
}
 */