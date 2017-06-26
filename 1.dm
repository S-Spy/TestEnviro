mob/verb/test_interface()
	var/dat = "<html>"
	dat += {"<head>
  <meta charset="utf-8">
  <title>overflow-y</title>
  <style>
   body {
   }
   .layer {
    width: 300px; /* Ширина блока */
    height: 150px; /* Высота блока */
    padding: 5px; /* Поля вокруг текста */
   }
  </style>
 </head>"}

	dat += "<body bgcolor=#407010><table width=700>"
	dat += "<tr><td width=20></td><td width=230>\< Items: \></td><td width=50></td>"		//INTERFACE
	dat += "<td width=100></td>"
	dat += "<td width=20></td><td width=230>\< Merchant Dick Nixon \></td><td align=right width=50></td></tr>"

	dat += "<td></td><td></td><td align=right>Caps 70</td><td align=center>   150 \>\> </td>"
	dat += "<td></td><td></td><td align=right>Caps 940</td></tr>"
	dat += "<tr></tr>"

	for(var/i=1, i<=max(40+3,1+70), i++)
		dat += "<tr border=1><td>"
		if(i<=3)
			dat += "<A href='?src=\ref[src]'>\[X\]</a></td><td><A href='?src=\ref[src]'>Item of merchant for trade[i]"
			dat += "</td><td>[i*15]</td>"
		else if(i<=40+3)
			dat += "</td><td><A href='?src=\ref[src]'>Item of player[i-3]"
			dat += "</td><td>[i*10]</td>"
		else if(i>40+3)
			dat += "</td><td></td><td></td>"

		dat += "<td></td><td>"

		if(i<=1)
			dat += "<A href='?src=\ref[src]'>\[X\]</a></td><td><A href='?src=\ref[src]'>Item of player for trade[i]]</a>"
			dat += "</td><td>[i*15]</td>"
		else if(i<=70+1)
			dat += "</td><td><A href='?src=\ref[src]'>Item of merchant[i-1]]</a>"
			dat += "</td><td>[i*10]</td>"
		else if(i>70+1)
			dat += "</td><td></td><td></td>"
		dat += "</td><td></tr>"



	//dat= += "</table>"


	/*dat += "<td align=center><A href='?src=\ref[src];trade=1;'>Trade</A>"
	dat += "</td><td align=right>Cost: 5 caps</td></tr>"
	dat += "<tr><td>Agree: No"
	dat += "</td><td></td><td align=right>Agree: <A href='?src=\ref[src];man1=[src]'>"
	dat += "Yes"
	dat += "</a></td></tr></table><br><br><hr><table border=1; width=500>"


	for(var/i=1, i<=7, i++)
		dat += "<tr><td>"
		if(i<7)
			dat += "<A href='?src=\ref[src]'>Item of merchant[i]]</a>"
		dat += "</td><td>"
		if(i<2)
			dat += "<A href='?src=\ref[src]'>Item of merchant for trade[i]]</a>"
		dat += "</td><td align=right>"
		if(i<4)
			dat += "<A href='?src=\ref[src]'>Item of player for trade[i]]</a>"
		dat += "</td><td align=right>"
		if(i<3)
			dat += "<A href='?src=\ref[src]'>Item of merchant[i]]</a>"
		dat += "</td></tr>"

	dat += "</table><table width=200>	*/


	dat += "</table></td></tr></table></body></html>"

	usr << browse(dat, "window=barter;size=739x500")