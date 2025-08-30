//Spell script for reserve feat Summon Elemental
//prc_reservsmnelm
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

/* 
SUMMON ELEMENTAL [RESERVE]
You can channel the summoning power you hold to briefly bring forth an elemental servant.
Prerequisite: Ability to cast 4th-level spells.
Benefit: As long as you have a summoning spell of 4th level or higher available to cast, you can summon a Small elemental (air, earth, fire, or water; your choice) within a range of 30 feet. The elemental acts as if summoned by a summon monster spell (PH 285). The duration of the summoning is equal to 1 round per level of the highest-level conjuration (summoning) spell you have available to cast.
You can have only one summoned elemental from this feat at a time; if you use the ability a second time, the first elemental disappears. Also, you must remain close to the elemental you summon. If at the end of your turn you are more than 30 feet from the elemental, it disappears.
If you have a conjuration (summoning) spell of 6th level or higher available to cast, you can summon a Medium elemental instead. If you have a conjuration (summoning) spell of 8th | level or higher available to cast, you can summon a Large elemental instead.
As a secondary benefit, you gain a +1 competence bonus to your caster level when casting conjuration (summoning) spells. 
*/

#include "prc_inc_spells"

void MarkElemental(object oPC)
{
    int i=1;
    int nCount = GetPRCSwitch(PRC_MULTISUMMON);
    if(nCount < 0
        || nCount == 1)
        nCount = 99;
    if(nCount > 99)
        nCount = 99;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummon) && i < nCount)
    {
        string sTag = GetResRef(oSummon);
        if (sTag == "hen_air_lar" || 
            sTag == "hen_air_med" || 
            sTag == "hen_air_small001" || 
            sTag == "hen_earth_lar" || 
            sTag == "hen_earth_med" || 
            sTag == "hen_earth_small1" || 
            sTag == "hen_fire_lar" || 
            sTag == "hen_fire_med" || 
            sTag == "hen_fire_small01" || 
            sTag == "hen_water_lar" || 
            sTag == "hen_water_med" || 
            sTag == "hen_water_small1")
            SetLocalInt(oSummon, "RFSummonedElemental", TRUE);
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
}

void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    int nSwitch = GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL);
    int nBonus = GetLocalInt(oPC, "SummonElementalBonus");
    float fDuration = RoundsToSeconds(nBonus);
    string sSummon;
    int nVFX;

    if (!GetLocalInt(oPC, "SummonElementalBonus")) 
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    switch(GetSpellId())
    {
        case SPELL_SUMMON_ELEMENTAL_AIR:
        {
            if (nBonus > 7)
            {
                sSummon = "hen_air_lar";
                nVFX = VFX_FNF_SUMMON_MONSTER_3;
            }
            else if (nBonus > 5)
            {
                sSummon = "hen_air_med";
                nVFX = VFX_FNF_SUMMON_MONSTER_2;
            }
            else if (nBonus > 3)
            {
                sSummon = "hen_air_small001";
                nVFX = VFX_FNF_SUMMON_MONSTER_1;
            }
            break;
        }
        case SPELL_SUMMON_ELEMENTAL_EARTH:
        {
            if (nBonus > 7)
            {
                sSummon = "hen_earth_lar";
                nVFX = VFX_FNF_SUMMON_MONSTER_3;
            }
            else if (nBonus > 5)
            {
                sSummon = "hen_earth_med";
                nVFX = VFX_FNF_SUMMON_MONSTER_2;
            }
            else if (nBonus > 3)
            {
                sSummon = "hen_earth_small1";
                nVFX = VFX_FNF_SUMMON_MONSTER_1;
            }
            break;
        }
        case SPELL_SUMMON_ELEMENTAL_FIRE:
        {
            if (nBonus > 7)
            {
                sSummon = "hen_fire_lar";
                nVFX = VFX_FNF_SUMMON_MONSTER_3;
            }
            else if (nBonus > 5)
            {
                sSummon = "hen_fire_med";
                nVFX = VFX_FNF_SUMMON_MONSTER_2;
            }
            else if (nBonus > 3)
            {
                sSummon = "hen_fire_small01";
                nVFX = VFX_FNF_SUMMON_MONSTER_1;
            }
            break;
        }
        case SPELL_SUMMON_ELEMENTAL_WATER:
        {
            if (nBonus > 7)
            {
                sSummon = "hen_water_lar";
                nVFX = VFX_FNF_SUMMON_MONSTER_3;
            }
            else if (nBonus > 5)
            {
                sSummon = "hen_water_med";
                nVFX = VFX_FNF_SUMMON_MONSTER_2;
            }
            else if (nBonus > 3)
            {
                sSummon = "hen_water_small1";
                nVFX = VFX_FNF_SUMMON_MONSTER_1;
            }
            break;
        }       
    }
    
    effect eSummon = EffectSummonCreature(sSummon, nVFX);

    MarkElemental(oPC);

    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

    DelayCommand(0.5, AugmentSummonedCreature(sSummon));
}