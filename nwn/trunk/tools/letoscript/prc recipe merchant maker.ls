%store = '.\prc_merchant.utm' or die $!;
meta dir=> '..\..\Craft2das' or die $!;
$name = 'prc_recipe';
$i = 0;
$max = 1000;
$x = 0;
$y = 0;
$count = 0;
add Name => /StoreList/[2]/ItemList, Type=>gffList;
/ResRef = $name;
/LocName = $name;
/Tag = $name;


for($i=0; $i<=$max; $i++)
{
	$resref = lookup 'item_to_ireq', $i, 'RECIPE_TAG';
	if($resref eq '')
	{
		print "no entry\n";
	}
	else
	{
		add /StoreList/[2]/ItemList/InventoryRes, $resref, gffResRef;
		add /StoreList/[2]/ItemList/[_]/Infinite, 1, gffByte;
		add /StoreList/[2]/ItemList/[_]/Repos_PosX, $x, gffByte;
		add /StoreList/[2]/ItemList/[_]/Repos_Posy, $y, gffByte;
		$x++;
		if($x>9)
		{
			$x = 0;
			$y++;
		}
		/StoreList/[2]/ItemList/[_].id = $count;
		$count++;
	}
	print "$resref $x $y /StoreList/[2]/ItemList/[_]/InventoryRes /StoreList/[2]/ItemList/[_]/Infinite /StoreList/[2]/ItemList/[_]/Repos_PosX /StoreList/[2]/ItemList/[_]/Repos_Posy \n";
}

%store = ">..\\..\\others\\$name.utm";