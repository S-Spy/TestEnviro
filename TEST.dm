/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)
	New()
		..()
		spawn(100)	world << "world"


// Make objects move 8 pixels per tick when walking

mob
	step_size = 8
	New()
		..()
		spawn(100)	world << "mob"


var/wsn = 0

/mob/verb/check_list_in()
	var/list/L = list("z"="a","y"="b","x"="c")
	usr << L[1]
	usr << L[2]
	usr << L[3]

/mob/verb/tohash(t as text)
	var/hash = md5(t)
	usr << hash
	usr << (md5(t) == hash)

//Подпись архимага: ArhiSpy
//=
//21459042ba2f1c10b56afbca2f55df86



datum/fractionrelations
	var/one = 1
	var/two = 2
	var/three = 3

var/datum/fractionrelations/F

proc/fill_fractions()
	F = new
	sleep(5)
	for(var/V in F.vars)
		world << V

obj
	step_size = 8


	New()
		..()
		if(wsn == 0)
			wsn = 1
			fill_fractions()

mob/verb/test_interface()
	var/dat = {"<html><head><style type=text/css>
#DIV1 {width=300;height=300;margin=7;padding=10;border=1;background=#fc0;overflow=auto;}
#DIV2 {width=300;height=50;margin=7;padding=10;border=1;background=#fc0}
</style>
</head>
<body bgcolor=#407010>"}



	dat += "<table width=650><tr><td valign=top>"	//INTERFACE

	dat += "<div id=DIV2><table width=282><tr><td> <A href='?src=\ref[src]'>\<</a> Items: <A href='?src=\ref[src]'>\></a></td></tr>"
	dat += "<tr><td align=right>Cups</td><td align=right> 70</td></tr>"
	dat += "<tr> </tr>"
	dat += "</table></div></td><td></td>"


	dat += "<td><div id=DIV2><table width=282><tr><td> \< Merchant Dick Nixon: \></td></tr>"
	dat += "<tr><td align=right>Cups</td><td align=right> 3760</td></tr>"
	dat += "<tr> </tr>"
	dat += "</table></div></td></tr>"



	dat += "<tr><td><div id=DIV1><table width=260 height=400>"

	for(var/i=1, i<=3, i++)
		dat += "<tr><td><A href='?src=\ref[src]'>\[X\]</a> </td><td><A href='?src=\ref[src]'>Item_of_merchant_for_trade[i]</a></td> <td align=right> [i*25] </td><tr><td>"
	for(var/i=1, i<=70, i++)
		dat += "<tr><td></td><td><A href='?src=\ref[src]'>Item_of_player[i]</a><td align=right>[i*10]</td><tr><td>"
	dat += "</table></div></td>"

	dat += "<td valign=top color=#0000e0> <b> 150>></b></td><td valign=top>"

	dat += "<div id=DIV1><table width=250 height=400 align=left>"

	for(var/i=1, i<=1, i++)
		dat += "<tr><td><A href='?src=\ref[src]'>\[X\]</a> </td><td> <A href='?src=\ref[src]'>Item_of_player_for_trade[i]</a></td> <td align=right> [i*15] </td><tr><td>"
	for(var/i=1, i<=40, i++)
		dat += "<tr><td></td><td><A href='?src=\ref[src]'>Item_of_merchant[i]</a><td align=right>[i*13]</td><tr><td>"
	dat += "</table>"


	dat += "</td></tr></div></table>"

	dat += "<table border=1 align=center><tr height=100>"
	dat += "<td width=100 align=center valign=center>[usr.icon]</td>"
	dat += "<td width=450>This is a desc of item!</td>"
	dat += "<td align=center width=130><A href='?src=\ref[src]'><b>Accept\[No\]</b></a></td>"

	dat += "</tr></table></body></html>"

	usr << browse(dat, "window=barter;size=718x548;can_resize=0")


//mob/verb/fix_255(var/t as text)
	//t = replacetext(t, "я", "&#255;")
	//usr << t//"[answer]"//</body><html>"
	//usr << browse("<html><head></head><body><script>alert(navigator.userAgent);</script></body></html>", "window=barter;size=100x100")

mob/verb/all_entities()
	for(var/i=1, i<256, i++)//255 is maximum
		usr << "[i] = &#[i];"

mob/verb/all_entities_in_html()
	for(var/i=1, i<256, i++)//255 is maximum
		usr << "[i] = \"[ascii2text(i)]\" = \"[html_encode(ascii2text(i))]\""

obj/planet
	New()
		..()
		for()
			sleep(1)
			PLANET.angle += 5
			if(PLANET.angle>=360)	PLANET.angle = 360-PLANET.angle
			PLANET.update_perspective()
			icon = PLANET.ICON

