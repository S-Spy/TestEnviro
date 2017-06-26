/mob/var/icon/cutiemark_paint
/mob/var/icon/cutiemark_paint_reverse
/mob/var/brush_color
var/list/colors4x4[4][4]


/mob/verb/browse_paint()
	if(!brush_color)	brush_color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	if(!cutiemark_paint)
		cutiemark_paint = new/icon('cutiemark.dmi', "blank")
		cutiemark_paint_reverse = new/icon('cutiemark.dmi', "blank")


	var/dat = {"
<html>
<body>
<b>Brush color:<b> <table><tr><td bgcolor='[brush_color]'><font face='fixedsys' size='3' color='[brush_color]'><a href='?src=\ref[src];cutie_paint=1;' style='color: [brush_color]'>__</a></font></td></tr></table>
<table border=0 cellspacing=0>"}

	for(var/y=4, y>=1, y--)
		dat += "<tr>"
		for(var/x=1, x<=4, x++)
			if(!colors4x4[x][y])	colors4x4[x][y] = cutiemark_paint.GetPixel(x, y)
			if(!colors4x4[x][y])	colors4x4[x][y] = rgb(150, 150, 150)

			dat += "<td bgcolor='[colors4x4[x][y]]'>"
			dat += "<font face='fixedsys' size='3' color='[colors4x4[x][y]]'><a href='?src=\ref[src];cutie_paint=2;x=[x];y=[y]' style='color: [colors4x4[x][y]]'>__</a></font>"
			dat += "</td>"
		dat += "</tr>"
	usr << browse_rsc(cutiemark_paint,"cutiemark_paint.png")
	usr << browse_rsc(cutiemark_paint_reverse,"cutiemark_paint2.png")
	dat += {"</table>
<img src=cutiemark_paint.png height=128 width=128>
<img src=cutiemark_paint2.png height=128 width=128>
</body>
</html>
"}

	usr << browse(dat, "window=cutie_paint")


/mob/Topic(href,href_list[])
	switch(href_list["cutie_paint"])
		if("1")
			brush_color = input(usr, "Choose your brush colour:", "Character Preference", brush_color) as color|null
			browse_paint()
		if("2")
			var/ix = text2num(href_list["x"])
			var/iy = text2num(href_list["y"])

			if( !(ix==1 && (iy==4 || iy==3)) && !(ix==2 && iy==4) )
				colors4x4[ix][iy] = brush_color
				cutiemark_paint.DrawBox(brush_color, 11+ix, 9+iy)
				cutiemark_paint_reverse.DrawBox(brush_color, 16+5-ix, 9+iy)
			browse_paint()
