//::////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//::////////////////////////////////////////////////////////
//;:
//:: Epic Spell: Summon Elemental Paragon
//:: Author: Jaysyn
//:: Updated on: 2026-08-15 00:58:10
//::
//::////////////////////////////////////////////////////////
/*
	Summon Elemental Paragon

	Conjuration (Summoning)
	Spellcraft DC: 87

	Components: V, S
	Casting Time: 1 minute
	Range: 75 ft.
	Effect: One summoned paragon elder elemental
	Duration: 17 hours
	Saving Throw: Will negates
	Spell Resistance: Yes

	The caster summons an elder elemental of the caster's choice: 
	air, earth, fire, or water. The summoned elemental has the 
	paragon template applied to it.

	The elemental appears where the caster designates 
	and acts immediately, on the caster's turn. It attacks the 
	caster's opponents to the best of its ability. The caster 
	can direct the elemental's actions as normal for a summoned 
	creature.

	Mitigating Factor: Burn 500 XP during casting (–5 DC).

	To Develop: 783,000 gp; 16 days; 31,320 XP.
*/
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int bAnimalDomain;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSwitch = GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL);
    float fDuration = nSwitch == 0 ? HoursToSeconds(24) :
                                     RoundsToSeconds(PRCGetCasterLevel(oCaster) * nSwitch);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;
        
    if (GetPRCSwitch(PRC_BIOWARE_ANIMAL_DOMAIN_POWER))
        bAnimalDomain = GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oCaster);

    string sSummon;
    int nVFX;
    switch(GetSpellId())
    {
        case SPELL_SUMMON_CREATURE_I:
            sSummon = bAnimalDomain ? "boardire" : "badgerdire";
            nVFX = VFX_FNF_SUMMON_MONSTER_1;
            break;
        case SPELL_SUMMON_CREATURE_II:
            sSummon = bAnimalDomain ? "wolfdire" : "boardire";
            nVFX = VFX_FNF_SUMMON_MONSTER_1;
            break;
        case SPELL_SUMMON_CREATURE_III:
            if(bAnimalDomain)
            {
                sSummon = "spiddire";
                nVFX = VFX_FNF_SUMMON_MONSTER_2;
            }
            else
            {
                sSummon = "wolfdire";
                nVFX = VFX_FNF_SUMMON_MONSTER_1;
            }
            break;
        case SPELL_SUMMON_CREATURE_IV:
            sSummon = bAnimalDomain ? "beardire" : "spiddire";
            nVFX = VFX_FNF_SUMMON_MONSTER_2;
            break;
        case SPELL_SUMMON_CREATURE_V:
            sSummon = bAnimalDomain ? "diretiger" : "beardire";
            nVFX = VFX_FNF_SUMMON_MONSTER_2;
            break;
        case SPELL_SUMMON_CREATURE_VI:
            if(bAnimalDomain)
            {
                nVFX = VFX_FNF_SUMMON_MONSTER_3;
                int nRoll = d4();
                sSummon = nRoll == 1 ? "airhuge" :
                          nRoll == 2 ? "earthhuge" :
                          nRoll == 3 ? "firehuge" :
                          "waterhuge";
            }
            else
            {
                sSummon = "diretiger";
                nVFX = VFX_FNF_SUMMON_MONSTER_2;
            }
            break;
       case SPELL_SUMMON_CREATURE_VII_AIR:
            sSummon = bAnimalDomain ? "airgreat" : "airhuge";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_VII_EARTH:
            sSummon = bAnimalDomain ? "earthgreat" : "earthhuge";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_VII_FIRE:
            sSummon = bAnimalDomain ? "firegreat" : "firehuge";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_VII_WATER:
            sSummon = bAnimalDomain ? "watergreat" : "waterhuge";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_VIII_AIR:
            sSummon = bAnimalDomain ? "airelder" : "airgreat";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_VIII_EARTH:
            sSummon = bAnimalDomain ? "earthelder" : "earthgreat";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_VIII_FIRE:
            sSummon = bAnimalDomain ? "fireelder" : "firegreat";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_VIII_WATER:
            sSummon = bAnimalDomain ? "waterelder" : "watergreat";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_IX_AIR:
            sSummon = "airelder";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_IX_EARTH:
            sSummon = "earthelder";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_IX_FIRE:
            sSummon = "fireelder";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
       case SPELL_SUMMON_CREATURE_IX_WATER:
            sSummon = "waterelder";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            break;
        case SPELL_SUMMON_CREATURE_VII:
            {
                nVFX = VFX_FNF_SUMMON_MONSTER_3;
                int nRoll = d4();
                sSummon = nRoll == 1 ? "airhuge" :
                          nRoll == 2 ? "earthhuge" :
                          nRoll == 3 ? "firehuge" :
                          "waterhuge";
            }
            break; 
        case SPELL_SUMMON_CREATURE_VIII:
            {
                nVFX = VFX_FNF_SUMMON_MONSTER_3;
                int nRoll = d4();
                sSummon = nRoll == 1 ? "airgreat" :
                          nRoll == 2 ? "earthgreat" :
                          nRoll == 3 ? "firegreat" :
                          "watergreat";
            }
            break;   
        case SPELL_SUMMON_CREATURE_IX:
            {
                nVFX = VFX_FNF_SUMMON_MONSTER_3;
                int nRoll = d4();
                sSummon = nRoll == 1 ? "airelder" :
                          nRoll == 2 ? "earthelder" :
                          nRoll == 3 ? "fireelder" :
                          "waterelder";
            }
            break;             
    }

    if (GetHasFeat(FEAT_SUMMON_ALIEN, oCaster) || GetHasSpellEffect(VESTIGE_ZCERYLL, oCaster)) sSummon = "pseudo"+sSummon;
    else     sSummon = "nw_s_"+sSummon;
    
    if (DEBUG) DoDebug("nw_s0_summon: oCaster " +GetName(oCaster)+", GetSpellId " +IntToString(GetSpellId())+", sSummon " +sSummon);
    
    effect eSummon = EffectSummonCreature(sSummon, nVFX);

    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

    DelayCommand(0.8, AugmentSummonedCreature(sSummon));
	
	DelayCommand(0.5, ExecuteScript("make_paragon", GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster)));

    PRCSetSchool();
}