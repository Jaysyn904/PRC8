#include "pnp_shft_poly"

void main()
{
    object oPC = OBJECT_SELF;
    int iPoly = GetHasFeat(FEAT_BONDED_AIR)   ? POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL:
                GetHasFeat(FEAT_BONDED_EARTH) ? POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL:
                GetHasFeat(FEAT_BONDED_FIRE)  ? POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL:
                POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL;//if(GetHasFeat(FEAT_BONDED_WATER))

    // abort if mounted
    if(!GetLocalInt(GetModule(), "X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if(PRCHorseGetIsMounted(oPC))
        { // abort
            if(GetIsPC(oPC))
                FloatingTextStrRefOnCreature(111982, oPC, FALSE);
            return;
        }
    }

    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(oPC);

    ClearAllActions(); // prevents an exploit

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(iPoly), oPC, HoursToSeconds(10));
    DelayCommand(1.5, ActionCastSpellOnSelf(SPELL_SHAPE_INCREASE_DAMAGE));
}