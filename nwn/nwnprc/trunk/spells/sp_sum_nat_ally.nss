//::///////////////////////////////////////////////
//:: Summon Nature's Ally
//:: sp_sum_nat_ally
//:: 
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Nature's Ally Series 
	of spells 1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 2025-08-01 22:02:26
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster 	= OBJECT_SELF;
	
	//int nSpellId 	= PRCGetSpellId();
	int nSpellId 	= GetSpellId();
	int nRandom;
    int nMetaMagic 	= PRCGetMetaMagicFeat();
    int nSwitch 	= GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL);
	
    float fDuration = nSwitch == 0 ? HoursToSeconds(24) :
                                     RoundsToSeconds(PRCGetCasterLevel(oCaster) * nSwitch);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    string sSummon;
    int nVFX;
	
	switch(nSpellId)
	{				
		//:: Summon Nature's Ally 1
		case SPELL_SUMMON_NATURES_ALLY_1_DIREBADGER: 
		{
			sSummon = "nw_s_badgerdire"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;					
		}					
		case SPELL_SUMMON_NATURES_ALLY_1_DIRERAT: 
		{ 
			sSummon = "prc_s_direrat001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_1_DOG: 
		{
			sSummon = "prc_s_dog001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;									
		}
		case SPELL_SUMMON_NATURES_ALLY_1_HAWK: 
		{
			sSummon = "prc_s_hawk001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;		
		}
		case SPELL_SUMMON_NATURES_ALLY_1_TINY_VIPER: 
		{
			sSummon = "prc_s_tnviper001";
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;			
		}	
		//:: Summon Nature's Ally 2				
		case SPELL_SUMMON_NATURES_ALLY_2_DIREBOAR: 
		{
			sSummon = "nw_s_boardire"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_2_COOSHEE: 
		{ 
			sSummon = "prc_s_cooshee001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_2_WOLF: 
		{
			sSummon = "prc_s_wolf001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_2_SMALL_VIPER: 
		{
			sSummon = "prc_s_smviper001";
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;					
		}
		case SPELL_SUMMON_NATURES_ALLY_2_BLACKBEAR: 
		{
			sSummon = "prc_s_blkbear001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;	
		}
		//:: Summon Nature's Ally 3				
		case SPELL_SUMMON_NATURES_ALLY_3_BROWNBEAR: 
		{
			sSummon = "prc_s_brnbear001";
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_3_DIREWOLK: 
		{ 
			sSummon = "nw_s_wolfdire"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;					
		}
		case SPELL_SUMMON_NATURES_ALLY_3_LARGE_VIPER: 
		{ 
			sSummon = "prc_s_lgviper001";
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;				
		}
		case SPELL_SUMMON_NATURES_ALLY_3_LEOPARD: 
		{ 
			sSummon = "prc_s_leopard001";
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;					
		}
		case SPELL_SUMMON_NATURES_ALLY_3_SATYR: 
		{ 
			sSummon = "prc_s_satyr001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_1;
			break;
		}
		//:: Summon Nature's Ally 4	
		case SPELL_SUMMON_NATURES_ALLY_4_LION: 
		{
			sSummon = "prc_s_lion001";
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;										
		}
		case SPELL_SUMMON_NATURES_ALLY_4_POLAR_BEAR: 
		{ 
			sSummon = "prc_s_plrbear001";
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;					
		}
		case SPELL_SUMMON_NATURES_ALLY_4_DIRE_SPIDER: 
		{ 
			sSummon = "nw_s_spiddire";
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;						
		}
		case SPELL_SUMMON_NATURES_ALLY_4_HUGE_VIPER: 
		{ 
			sSummon = "prc_s_hgviper001";
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;						
		}
		case SPELL_SUMMON_NATURES_ALLY_4_WEREBOAR: 
		{
			sSummon = "prc_s_wrboar001";
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;						
		}				
		//:: Summon Nature's Ally 5
		case SPELL_SUMMON_NATURES_ALLY_5_MED_AIR: 
		{
			sSummon = "x1_s_airsmall"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;	
		}
		case SPELL_SUMMON_NATURES_ALLY_5_MED_EARTH: 
		{
			sSummon = "x1_s_earthsmall"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;	
		}
		case SPELL_SUMMON_NATURES_ALLY_5_MED_FIRE: 
		{
			sSummon = "x1_s_firesmall";
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_5_MED_WATER: 
		{
			sSummon = "x1_s_watersmall"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_5_DIRE_BEAR: 
		{
			sSummon = "nw_s_beardire"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;
		}
		//:: Summon Nature's Ally 6
		case SPELL_SUMMON_NATURES_ALLY_6_LG_AIR: 
		{
			sSummon = "prc_s_airlarge";
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_6_LG_EARTH: 
		{
			sSummon = "prc_s_earthlarge"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_6_LG_FIRE: 
		{
			sSummon = "prc_s_firelarge"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_6_LG_WATER: 
		{
			sSummon = "prc_s_waterlarge"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_6_DIRETIGER: 
		{
			sSummon = "nw_s_diretiger";
			nVFX = VFX_FNF_SUMMON_MONSTER_2;
			break;
		}			
		//:: Summon Nature's Ally 7
		case SPELL_SUMMON_NATURES_ALLY_7_BULETTE: 
		{
			sSummon = "prc_s_bueltte001";
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_7_INVSTALKER: 
		{
			sSummon = "prc_s_invstlk001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_7_PIXIE: 
		{
			sSummon = "prc_s_pixie001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_7_GORGON: 
		{
			sSummon = "prc_s_gorgon001"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_7_MANTICORE: 
		{
			sSummon = "prc_s_mntcore001";
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}				
		//:: Summon Nature's Ally 8
		case SPELL_SUMMON_NATURES_ALLY_8_GR_AIR: 
		{
			sSummon = "nw_s_airgreat";
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_8_GR_EARTH: 
		{
			sSummon = "nw_s_earthgreat"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_8_GR_FIRE: 
		{
			sSummon = "nw_s_firegreat"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_8_GR_WATER: 
		{
			sSummon = "nw_s_watergreat"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_8_NYMPH: 
		{
			sSummon = "prc_s_nymph001";
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}				
		//:: Summon Nature's Ally 9
		case SPELL_SUMMON_NATURES_ALLY_9_ELD_AIR: 
		{
			sSummon = "nw_s_airelder";
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_9_ELD_EARTH: 
		{
			sSummon = "nw_s_earthelder"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_9_ELD_FIRE: 
		{
			sSummon = "nw_s_fireelder"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_9_ELD_WATER: 
		{
			sSummon = "nw_s_waterelder"; 
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}
		case SPELL_SUMMON_NATURES_ALLY_9_ARANEA: 
		{
			sSummon = "prc_s_aranea001";
			nVFX = VFX_FNF_SUMMON_MONSTER_3;
			break;
		}				
	}			
			
	if (DEBUG) DoDebug("sp_summon_nature: oCaster " +GetName(oCaster)+", GetSpellId " +IntToString(GetSpellId())+", sSummon " +sSummon);
	
	effect eSummon = EffectSummonCreature(sSummon, nVFX);

	//Apply the VFX impact and summon effect
	MultisummonPreSummon();
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

	DelayCommand(0.5, AugmentSummonedCreature(sSummon));

	PRCSetSchool();						
}
	
 /*   switch(nSpellId)
    {
		
	
         case SPELL_SUMMON_NATURES_ALLY_1:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "nw_s_badgerdire"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;					
				}					
				case 2: 
				{ 
					sSummon = "prc_s_direrat001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;
				}
				case 3: 
				{
					sSummon = "prc_s_dog001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;									
				}
				case 4: 
				{
					sSummon = "prc_s_hawk001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;		
				}
				case 5: 
				{
					sSummon = "prc_s_tnviper001";
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;			
				}
			}
		}
		case SPELL_SUMMON_NATURES_ALLY_2:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "nw_s_boardire"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;
				}
				case 2: 
				{ 
					sSummon = "prc_s_cooshee001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;
				}
				case 3: 
				{
					sSummon = "prc_s_wolf001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;
				}
				case 4: 
				{
					sSummon = "prc_s_smviper001";
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;					
				}
				case 5: 
				{
					sSummon = "prc_s_blkbear001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;	
				}
			}
		}
		case SPELL_SUMMON_NATURES_ALLY_3:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "prc_s_brnbear001";
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;
				}
				case 2: 
				{ 
					sSummon = "nw_s_wolfdire"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;					
				}
				case 3: 
				{ 
					sSummon = "prc_s_lgviper001";
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;				
				}
				case 4: 
				{ 
					sSummon = "prc_s_leopard001";
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;					
				}
				case 5: 
				{ 
					sSummon = "prc_s_satyr001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_1;
					break;
				}
			}
		}
		case SPELL_SUMMON_NATURES_ALLY_4:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "prc_s_lion001";
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;										
				}
				case 2: 
				{ 
					sSummon = "prc_s_plrbear001";
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;					
				}
				case 3: 
				{ 
					sSummon = "nw_s_spiddire";
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;						
				}
				case 4: 
				{ 
					sSummon = "prc_s_hgviper001";
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;						
				}
				case 5: 
				{
					sSummon = "prc_s_wrboar001";
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;						
				}
			}
		}
		case SPELL_SUMMON_NATURES_ALLY_5:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "x1_s_airsmall"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;	
				}
				case 2: 
				{
					sSummon = "x1_s_earthsmall"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;	
				}
				case 3: 
				{
					sSummon = "x1_s_firesmall";
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;
				}
				case 4: 
				{
					sSummon = "x1_s_watersmall"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;
				}
				case 5: 
				{
					sSummon = "nw_s_beardire"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;
				}
			}
		}		
		case SPELL_SUMMON_NATURES_ALLY_6:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "prc_s_airlarge";
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;
				}
				case 2: 
				{
					sSummon = "prc_s_earthlarge"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;
				}
				case 3: 
				{
					sSummon = "prc_s_firelarge"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;
				}
				case 4: 
				{
					sSummon = "prc_s_waterlarge"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;
				}
				case 5: 
				{
					sSummon = "nw_s_diretiger";
					nVFX = VFX_FNF_SUMMON_MONSTER_2;
					break;
				}
			}
		}		
		case SPELL_SUMMON_NATURES_ALLY_7:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "prc_s_bueltte001";
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 2: 
				{
					sSummon = "prc_s_invstlk001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 3: 
				{
					sSummon = "prc_s_pixie001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 4: 
				{
					sSummon = "prc_s_gorgon001"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 5: 
				{
					sSummon = "prc_s_mntcore001";
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
			}
		}		
		case SPELL_SUMMON_NATURES_ALLY_8:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "nw_s_airgreat";
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 2: 
				{
					sSummon = "nw_s_earthgreat"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 3: 
				{
					sSummon = "nw_s_firegreat"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 4: 
				{
					sSummon = "nw_s_watergreat"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 5: 
				{
					sSummon = "prc_s_nymph001";
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
			}
		}		
		case SPELL_SUMMON_NATURES_ALLY_9:
		{
            nRandom = Random(5)+1;
			
			switch(nRandom)
			{
				case 1: 
				{
					sSummon = "nw_s_airelder";
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 2: 
				{
					sSummon = "nw_s_earthelder"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 3: 
				{
					sSummon = "nw_s_fireelder"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 4: 
				{
					sSummon = "nw_s_waterelder"; 
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
				case 5: 
				{
					sSummon = "prc_s_aranea001";
					nVFX = VFX_FNF_SUMMON_MONSTER_3;
					break;
				}
			}
		}		
		
 */

/* 		
		// [TODO] Turn this into a proper template
		if (GetHasFeat(FEAT_SUMMON_ALIEN, oCaster) || GetHasSpellEffect(VESTIGE_ZCERYLL, oCaster)) 
		{
			sSummon = "pseudo"+sSummon;
		}
		else     
		{
			sSummon = "nw_s_"+sSummon;
		} */
		

			
		
		
		
