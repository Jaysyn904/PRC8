tlk.dialog tlk => 'c:/games/NeverwinterNights/NWN/dialog.tlk', 
	custom => 'C:/Documents and Settings/user/Desktop/PRC Stuff/prc/tlk/prc_consortium.tlk';
meta dir => 'C:/Documents and Settings/user/Desktop/PRC Stuff/prc/2das';

$TLKBASE = 16830956;
$CLASSNAME = 'Occular Adept';
$nRowMax = 411;

$nRow = 0;
for($nRow=1; $nRow<$nRowMax; $nRow++)
{
	$nRealSpellID = lookup 'cls_spell_ocu', $nRow, 'RealSpellID';
	$nTlkLineNo = $nRow+$TLKBASE;
	$nTlkEntry = $CLASSNAME+' '+tlk.getstrref lookup 'spells', $nRealSpellID, 'Name';
	$nMetamagicFeat = lookup 'cls_spell_ocu', $nRow, 'ReqFeat';
	$nMetamagicTlk = '';
	if(($nMetamagicFeat != '****') and ($nMetamagicFeat != ''))
	{
		$nMetamagicTlk;
		if($nMetamagicFeat eq 29)
		{ $nMetamagicTlk = '(quicken)'; }
		if($nMetamagicFeat eq 33)
		{ $nMetamagicTlk = '(silent)'; }
		if($nMetamagicFeat eq 37)
		{ $nMetamagicTlk = '(still)'; }
		if($nMetamagicFeat eq 12)
		{ $nMetamagicTlk = '(extend)'; }
		if($nMetamagicFeat eq 11)
		{ $nMetamagicTlk = '(empower)'; }
		if($nMetamagicFeat eq 25)
		{ $nMetamagicTlk = '(maximize)'; }
		$nTlkEntry = $nTlkEntry+' '+$nMetamagicTlk;
	}
	print "$nRow $nRealSpellID $nMetamagicFeat $nMetamagicTlk $nTlkLineNo $nTlkEntry \n";
	tlk.setstrref $nTlkLineNo, $nTlkEntry;
}
tlk.dialog custom => '>';
/*This feat opens the spellbook for this class. This is a conversation and feat driven version of the normal spellbook. Instead of appearing on the spell radial, they will appear on the class radial instead. Also, you may be able to use the spell after you have cast all your uses. No spell will result, but you will spend a round trying to cast it.*/