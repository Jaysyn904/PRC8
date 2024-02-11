/*
  Chastise Spirits (Su): Beginning at 2nd level, a spirit shaman can use divine energy granted by her patrons in the spirit world to damage hostile spirits (see the What is a Spirit? sidebar).
  
  Chastising spirits is a standard action that deals 1d6 damage/shaman level to all spirits within 30 feet of the shaman. The affected spirits get a Will save (DC 10+ shaman level + Cha modifier) for half damage.
*/

#include "prc_inc_spells"

int GetIsSpirit(object oCreature, int nAppearance)
{
	int nRace = MyPRCGetRacialType(oCreature);

    return nAppearance == APPEARANCE_TYPE_ALLIP
         || nAppearance == APPEARANCE_TYPE_DOG_SHADOW_MASTIF
         || nAppearance == APPEARANCE_TYPE_INVISIBLE_STALKER
         || nAppearance == APPEARANCE_TYPE_SHADOW
         || nAppearance == APPEARANCE_TYPE_SHADOW_FIEND
         || nAppearance == APPEARANCE_TYPE_SPECTRE
         || nAppearance == APPEARANCE_TYPE_WILL_O_WISP
         || nAppearance == APPEARANCE_TYPE_WRAITH
         || nRace == RACIAL_TYPE_ELEMENTAL
         || nRace == RACIAL_TYPE_FEY;
}

void main()
{

    object oShaman = OBJECT_SELF;
    location lTarget = GetLocation(oShaman);
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    int nSpirit = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oShaman);
    int nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA, oShaman) + nSpirit;
    //Get the first target in the radius around the caster
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget);
    while(GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        if(oShaman != oTarget && !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE) && GetIsSpirit(oTarget, GetAppearanceType(oTarget)))
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(d6(nSpirit), DAMAGE_TYPE_POSITIVE)), oTarget);
        }
        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget);
    }
}