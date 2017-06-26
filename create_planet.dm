/datum/planet
	var/icon/ICON
	var/list/places
	var/angle = 0

	New()
		places = list_of_places()


	proc/update_perspective()
		ICON = new/icon('planet.dmi', "0")
		var/k = places.len/64


		for(var/iy=1, iy<=64, iy++)
			var/datum/array/ARR = places[min(places.len, max(1, round(iy*k)))]
			var/list/view_line = list()
			var/list/view_line2 = list()
			for(var/datum/polar_place/P in ARR.L)
				if(angle<180)
					if(P.bax>=angle && P.bax<=angle+180)
						view_line += P
				else
					var/angle2 = angle-180

					if((P.bax>angle || P.eax>angle) && (P.bax<=360 || P.eax<=360))
						view_line += P
					else if(P.eax<angle2)
						view_line2 += P
			view_line += view_line2


			//for(var/datum/polar_place/P in view_line)
			//	world << "[P.bax]-[P.eax]"
			for(var/ix=1, ix<=64, ix++)
				var/k2 = view_line.len/64//Определяем сколько весит 1 пиксель.
				var/address = round(ix*k2)
				if(address > view_line.len)	address = address>view_line.len
				if(address < 1)				address = 1

				var/datum/polar_place/PP = view_line[address]


				if(ICON.GetPixel(ix, iy))
					//var/icon/shadow = new/icon('planet.dmi', "atmo")
					var/dist = sqrt((32-ix)*(32-ix) + (32-iy)*(32-iy))//Тень
					var/polar_dist = 1
					if(abs(32-iy)>16)
						for(var/i=1, i<abs(32-iy)-15, i++)
							polar_dist *= 2
					ICON.DrawBox(rgb(PP.place.color.R-dist*5+polar_dist, PP.place.color.G-dist*5+polar_dist, PP.place.color.B-dist*5+polar_dist), ix, iy)





	proc/list_of_places(var/R = 20)
		var/list/LIST = list()//Список полярных координат. Двумерная матрица
		var/h_place = 1 //Базовая высота квадранта
		var/alpha = 180*h_place/(3.14*R)//Длина шага по долготе в градусах
		var/len_h = round(180/alpha)//Количество шагов по долготе

		if(len_h%2!=1)//Нужно добиться нечетного количества по умолчанию
			len_h++
			alpha = 180/len_h
			h_place = 3.14*R*alpha/180



		var/H = h_place*(len_h-1)/2//Длина дуги четверти, общая для всех



		var/N = 0
		for(var/ay=90-alpha/2, ay<=180, ay+=alpha)	//Геометрия широты и долготы
			var/datum/array/line = new/datum/array()
			for(var/ax=0, ax<=360, ax+=alpha)
				var/h = h_place*( ((len_h-1)/2) -N)  //Высота треугольника(до полюса) для данного квадранта
				var/k = h/H//Схожесть подобных треугольников
				line.L += new/datum/polar_place(ax, min(ax+alpha*k, 360), ay, min(ay+alpha, 180))
			N++
			LIST += line


		N = 0
		for(var/ay=89.99-alpha/2, ay>=0, ay-=alpha)	//Я отчаялся, пока искал ошибку
			var/datum/array/line = new/datum/array()
			for(var/ax=0, ax<=360, ax+=alpha)
				var/h = h_place*( ((len_h-1)/2) -N)  //Высота треугольника(до полюса) для данного квадранта
				var/k = h/H//Схожесть подобных треугольников
				//if(ax<190)	world << "[k]-[ax]-[min(ax+alpha*k, 360)]"
				line.L += new/datum/polar_place(ax, min(ax+alpha*k, 360), ay, min(ay+alpha, 180))
			N++
			LIST = list(line) + LIST
		//Список полярных координат имеем. Теперь нужно для этого сделать квадранты в декартовых координатах


		for(var/datum/array/ARR in LIST)
			var/list/current_line = ARR.L
			for(var/i=2, i<=current_line.len, i++)//Сравниваем места и угол. Если что, обьединяем их угол в одном месте
				var/datum/polar_place/PP1 = current_line[i]
				var/datum/polar_place/PP0 = current_line[i-1]
				if( (PP1.place.bax+PP1.place.eax)+(PP0.place.bax+PP0.place.eax) < alpha )
					PP0.place = PP1.place
					PP0.place.eax += PP1.place.eax
					PP1.place.bax = PP0.place.bax




		//Места настроены. Теперь нужно убрать "шум" с картинки. Чтобы пиксели обьединялись
		for(var/y=1, y<=LIST.len, y++)
			//Берем линию и рассматриваем всем места в ней
			var/datum/array/ARR = LIST[y]
			var/list/datum/polar_place/current_line = ARR.L

			var/north_line
			if(y<len_h)
				ARR = LIST[y+1]
				north_line = ARR.L

			var/south_line
			if(y>1)
				ARR = LIST[y-1]
				south_line = ARR.L

			for(var/x=1, x<=current_line.len, x++)//Где то здесь
				var/datum/polar_place/PP = current_line[x]//Обрабатываемый квадрант
				//Сначала определим размер цвета соседей. Чем он больше, тем больше вероятность того, что примется этот цвет
				var/size_north = 1;		var/datum/polar_place/PP_north;
				var/size_west  = 1;		var/datum/polar_place/PP_west;
				var/size_south = 1;		var/datum/polar_place/PP_south;
				var/size_east  = 1;		var/datum/polar_place/PP_east;   //Ладно уж, сделаю одинарную проверку

				if(north_line)	PP_north = north_line[x]
				if(south_line)	PP_south = south_line[x]

				if(x>1)					PP_west = current_line[x-1]
				else					PP_west = current_line[current_line.len]
				if(x<current_line.len)	PP_east = current_line[x+1]
				else					PP_east = current_line[1]

				var/list/lst = list(PP_west, PP_east, PP_north, PP_south)

				for(var/datum/polar_place/entity in lst)
					for(var/datum/polar_place/entity2 in lst-entity)//По наличию сравниваем схожие квадранты
						if(entity==null || entity2==null)	continue

						if(entity.place.color==entity2.place.color)
							var/S
							if(entity2==PP_north)
								S=size_north
								size_north = 0
							else if(entity2==PP_east)
								S = size_east
								size_east  = 0
							else if(entity2==PP_south)
								S=size_south
								size_south = 0
							else
								S=size_west
								size_west  = 0

							if(entity==PP_north)		size_north 	+= S
							else if(entity==PP_east)	size_east 	+= S
							else if(entity==PP_south)	size_south 	+= S
							else						size_west 	+= S


				var/datum/polar_place/select_place
				if(PP_north)
					if(PP_south)	select_place = pick(prob(size_north*30);PP_north, prob(size_south*30);PP_south, prob(size_east*30);PP_east, prob(size_west*30);PP_west)
					else			select_place = pick(prob(size_north*30);PP_north, prob(size_east*30);PP_east, prob(size_west*30);PP_west)
				else
					if(PP_south)	select_place = pick(prob(size_south*30);PP_south, prob(size_east*30);PP_east, prob(size_west*30);PP_west)
					else			select_place = pick(prob(size_east*30);PP_east, prob(size_west*30);PP_west)
				PP.place.color = select_place.place.color

		return LIST


/datum/array
	var/list/L = list()

/datum/polar_place
	var bax//begin line
	var eax//end line
	var bay
	var eay
	var/datum/place/place

	New(var/bx, var/ex, var/by, var/ey)
		bax = bx
		eax = ex
		bay = by
		eay = ey
		place = new/datum/place(bax, eax)
		..()

/datum/place
	var/datum/paint/color
	var/bax
	var/eax
	New(var/bx, var/ex)
		bax = bx
		eax = ex
		color = pick_color()
		..()

datum/paint
	var/R = 0
	var/G = 0
	var/B = 0
	var/A = 255
	var/PROB = 5
	New(var/r, var/g, var/b, var/pr)
		R = r
		G = g
		B = b
		PROB =pr
		..()

proc/pick_color()
	//Сначала сортировка)
	var/list/colors = list(new/datum/paint(255,0,0,5), new/datum/paint(0,255,0,50), new/datum/paint(0,0,255,80))

	for(var/i=1, i<=colors.len, i++)
		var/min_i = i
		for(var/t=i+1, t<=colors.len, t++)
			var/datum/paint/P2 = colors[t]
			var/datum/paint/Pmin = colors[min_i]
			if(P2.PROB<Pmin.PROB)
				min_i=t
		if(min_i!=i)
			var/bufer = colors[i]
			colors[i] = colors[min_i]
			colors[min_i] = bufer


	for(var/datum/paint/P in colors)
		if(roll("1d100")<P.PROB)	//Процентная случайность
			return P

	return colors[colors.len]



var/datum/planet/PLANET
world/New()
	..()
	PLANET = new/datum/planet()


/mob/verb/turn_planet()
	PLANET.angle += 10
	if(PLANET.angle>=360)	PLANET.angle = 360-PLANET.angle
	PLANET.update_perspective()

	usr << browse_rsc(PLANET.ICON,"planet.jpg")
	usr << browse("<p><img src=planet.jpg width='128px' height='128px'></p>PLANET([PLANET.angle])","window=help")
