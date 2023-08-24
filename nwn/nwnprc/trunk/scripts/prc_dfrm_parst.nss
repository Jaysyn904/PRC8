//////////////////////////////////////////////////////
/*
Deformity (Parasite) [Vile, Deformity]
You invite parasites into your body in exchange for a greater
hardiness against diseases and poisons.
Prerequisite: Willing Deformity.
Benefit: As an immediate action, you can negate any
disease or poison affecting you. On your next turn, you can
take only a move action or a standard action as the agitated
parasites wriggle in your flesh.*/
/////////////////////////////////////////////////////////////

void main()
{
        object oPC = OBJECT_SELF;
        int bRemoved = FALSE;
        effect eTest = GetFirstEffect(oPC);
                
        while(GetIsEffectValid(eTest) && bRemoved == FALSE)
        {
                int nType = GetEffectType(eTest);
                if(nType == EFFECT_TYPE_DISEASE || nType == EFFECT_TYPE_POISON)
                {
                        RemoveEffect(oPC, eTest);
                        bRemoved = TRUE;
                }
                eTest = GetNextEffect(oPC);
        }
        if(bRemoved)
        {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISEASE_S), oPC);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, TurnsToSeconds(1));
                FloatingTextStringOnCreature("You are unable to move as the parasites within you wriggle in your flesh.", oPC, FALSE);
        }
        
        else FloatingTextStringOnCreature("No poison or disease found.", oPC, FALSE);        
}                