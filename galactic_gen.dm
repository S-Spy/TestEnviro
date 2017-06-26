/*
1. Сначала нужно создать файл
2. Заполнить его блоками
3. Дальше по функции и координатам заполнять

*/
proc/map_int(var/u)
	var/mods[3]
	for(var/i=3, i>0, i--)
		mods[i] = u%52
		if(u%52>26)	u--
		u = round(u/52)

	var/d3 = (mods[3]<=26) ? ascii2text(65+mods[3]) : ascii2text(97+mods[3])
	var/d2 = (mods[2]<=26) ? ascii2text(65+mods[2]) : ascii2text(97+mods[2])
	var/d1 = (mods[1]<=26) ? ascii2text(65+mods[1]) : ascii2text(97+mods[1])

	return d1+d2+d3



var/galaxy[500][500]
/datum/spawn_point
	var/x
	var/y
	var/thickness
	New(var/t1, var/t2, var/t3)
		x = t1
		y = t2
		thickness = t3

/turf/star
	icon='galaxy.dmi'
	icon_state = "star"

var/progress = 1

proc/gen_galaxy()
	set background=1
	//Сначала нужно расставить точки
	//4 спирали по 30 точек
	var/list/datum/spawn_point/SP_list = list()
	for(var/start_angle = 0, start_angle<=270, start_angle += 90)
		for(var/i=1, i<30, i++)
			var/angle = start_angle+i*5
			SP_list += new /datum/spawn_point(250+8*i*cos(angle), 250+8*i*sin(angle), 30-i)

	for(var/datum/spawn_point/SP in SP_list)
		for(var/i=1, i<=round(0.5*SP.thickness), i++)
			var/rand_x = max(1, min(500, SP.x + pick(rand(-SP.thickness, 0), rand(0, SP.thickness))))
			var/rand_y = max(1, min(500, SP.y + pick(rand(-SP.thickness, 0), rand(0, SP.thickness))))

			galaxy[rand_x][rand_y] = "(/turf/star,/area)"



	var/dat0 = ""
	var/dat = "(1,1,1) = {\""

	world << time2text(world.timeofday)

	var/u = 2
	for(var/x=1, x<=500, x++)
		dat += "\n"
		progress = x/500
		for(var/y=1, y<=500, y++)
			if(!galaxy[x][y])
				dat += map_int(1)
				if(!findtext(dat0, "(/turf,/area)"))
					dat0 += "\"[map_int(1)]\" = (/turf,/area)\n"
			else

				if(!findtext(dat0, galaxy[x][y]))
					dat0 += "\"[map_int(u)]\" = [galaxy[x][y]]\n"
					dat += map_int(u)
					u++
				else
					dat += copytext(dat0, findtext(dat0, galaxy[x][y])-8, 5)

	world << time2text(world.timeofday)

	fdel("galaxy_map.dmm")
	text2file(dat0+"\n"+dat, "galaxy_map.dmm")


mob/Stat()
	statpanel("Progress","[progress*100] %")


/client/verb/new_galaxy()
	gen_galaxy()