$abbrev;
$lowHD;
$highHD;
$sizeplus;
$j;
for($j = 1; $j<= 7; $j++)
{
	if($j == 1)
	{
		$abbrev = 'clay';
		$lowHD  = 12;
		$highHD = 33;
		$sizeplus = 19;
	}
	if($j == 2)
	{
		$abbrev = 'fles';
		$lowHD  = 10;
		$highHD = 27;
		$sizeplus = 19;
	}
	if($j == 3)
	{
		$abbrev = 'ston';
		$lowHD  = 15;
		$highHD = 42;
		$sizeplus = 22;
	}
	if($j == 4)
	{
		$abbrev = 'adam';
		$lowHD  = 55;
		$highHD = 108;
		$sizeplus = 83;
	}
	if($j == 5)
	{
		$abbrev = 'demo';
		$lowHD  = 5;
		$highHD = 0;
	}
	if($j == 6)
	{
		$abbrev = 'iron';
		$lowHD  = 19;
		$highHD = 54;
		$sizeplus = 25;
	}
	if($j == 7)
	{
		$abbrev = 'mith';
		$lowHD  = 37;
		$highHD = 72;
		$sizeplus = 55;
	}

	print $abbrev;
	print ' ';
	print $lowHD;
	print ' ';
	print $highHD;
	print "\n";

	if($highHD > 80)
	{
		$highHD = 80;
	}

	%file = "..\\..\\others\\prc_con_$abbrev.utc" or die $!;
	$i;
	$sizeadded = 0;
	$count = 0;
	for($i=$lowHD; $i<=$highHD; $i = $i+1)
	{
		/ClassList/[0]/ClassLevel = /ClassList/[0]/ClassLevel+1;
		if($i%2 == 0)
		{
			/HitPoints = /HitPoints+5;
			/CurrentHitPoints = /CurrentHitPoints+5;
			/MaxHitPoints = /MaxHitPoints+5;
		}
		else
		{
			/HitPoints = /HitPoints+6;
			/CurrentHitPoints = /CurrentHitPoints+6;
			/MaxHitPoints = /MaxHitPoints+6;	
		}
		if($i>=$sizeplus and $sizeadded == 0)
		{
			add Name => /FeatList/Feat, Value => 2293, Type => gffWord, SetIfExists => TRUE;
			$sizeadded = 1;
			print "Added size \n";
		}
		if($count%5 == 0)
		{
			$name = "prc_con_"+$abbrev+"_$i";
			/TemplateResRef = $name;
			$name = "$name.utc";
			%file = ">..\\..\\others\\$name";
			print "Written to file $name\n";
		}	
		$count = $count+1;
	}
	close %file;
}	