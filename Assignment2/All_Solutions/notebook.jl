### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 35a28ee0-7f4c-11eb-0c8a-bd85b8e01809
begin
	using CategoricalArrays
	using DataFrames
	using Random
	using HTTP
	using JSON
	using Plots
end

# ╔═╡ 62b78ee0-7efb-11eb-3188-6f8bd7d0d786
using Statistics

# ╔═╡ 7203626e-7f14-11eb-0091-bf33d3d96783
md"# Q1. Reshape into narrow shape"

# ╔═╡ a81b3180-7f14-11eb-3532-db45cfd75238
md"**Step 1- Generating untidy data**"

# ╔═╡ 6fee7c7e-797f-11eb-11d5-79d090f691b4
begin
	Random.seed!(0)
	
	dat1=DataFrame(religion=["Agnostic","Atheist","Buddhist","Catholic","Don't know/refused","Evangelical Prot","Hindu","Historically Black prot","Jehovah's Witness","Jewish"],
		a=[rand(1:1500) for _ in 1:10],
		b=[rand(1:1500) for _ in 1:10],
		c=[rand(1:1500) for _ in 1:10],
		d=[rand(1:1500) for _ in 1:10],
		e=[rand(1:1500) for _ in 1:10],
		f=[rand(1:1500) for _ in 1:10])  

colnames11 = ["Religion","<10k","10-20k","20-30k","30-40k","40-50k","50-75k"]
	rename!(dat1, Symbol.(colnames11))
end

# ╔═╡ d49637a0-7f14-11eb-0e84-6ff14239ed3a
md"**Step 2- Tidy data**"

# ╔═╡ c8666e60-799b-11eb-0d7e-1bc4712feeec
begin
	new=sort(DataFrames.stack(dat1,2:7))
	colnames1 = ["Religion","Income","Frequency"]
	rename!(new, Symbol.(colnames1))
end


# ╔═╡ 24be3ca2-7f15-11eb-1c8b-6f961504e329
md"# Q2. Data to be transformed into a tidy dataset where each date is a single row. "

# ╔═╡ fb040ec2-7f15-11eb-1eeb-d5de33cf9c8f
md"**Step 1- Generating untidy data**"

# ╔═╡ 30d3017e-79d2-11eb-33ce-9b4ce43e51cb
## Generating the ID column and Temperature type Column

#keeping ids of 2019 for months 1,2,3 and of 2020 for months 1,2

begin
	ids=Matrix{Union{Nothing, String}}(nothing, 10, 1)
	temptype=Matrix{Union{Nothing, String}}(nothing, 10, 1)
	j19=1
	j20=7
	m19=1
	m20=1
	m=zeros(10,1)
	for i in 1:10
		if i<=6
			ids[i]=string("MX20D0",19)
			if j19<=6
				temptype[j19]="tmax"
				temptype[j19+1]="tmin"
				m[j19]=m[j19+1]=m19
				m19+=1
				j19+=2
			end
			
		else
			ids[i]=string("MX20D0",20)
			if j20<=10
				temptype[j20]="tmax"
				temptype[j20+1]="tmin"
				m[j20]=m[j20+1]=m20
				m20+=1
				j20+=2
			end
		end
	end	
end

# ╔═╡ 82e9ba50-79d6-11eb-2da1-f3080d412f76
## Generating the max and min temperature for first 30 days of each months

begin
	temptypeC=CategoricalArray(temptype)
	temp=zeros(10,30)
	for y in 1:30
		for t in 1:10
			if t%2==0
				temp[t,y]=rand(20.0:0.01:30.0)  #Value for minimum day temperature
			else
				temp[t,y]=rand(25.0:0.01:45.0)  #Value for maximum day temperature
			end
		end
	end
end

# ╔═╡ be4a5a20-79d9-11eb-0ec7-571d7914767e
## Generating the dataframe with missing values of temp.


begin
	Random.seed!(0)
	randg=20;
	dat2=DataFrame(id=[ids[j] for j in 1:10],Year=[2019,2019,2019,2019,2019,2019,2020,2020,2020,2020],month=[m[p] for p in 1:10],element=[temptypeC[u] for u in 1:10] )
	for k in 1:31
		colname=string("d",k)
		if k<=30
			dat2[!,colname]=temp[:,k]
		else
			dat2[!,colname]=[missing,missing,rand(25.0:0.01:45.0),rand(20.0:0.01:30.0),missing,missing,rand(25.0:0.01:45.0),rand(20.0:0.01:30.0),missing,missing]
		end
	end
	
	while(randg>=0)
		mi=rand(1:30)
		colname=string("d",mi)
		if mi%2==0
			dat2[!,colname]=[missing,missing,rand(25.0:0.01:45.0),rand(20.0:0.01:30.0),missing,missing,rand(25.0:0.01:45.0),rand(20.0:0.01:30.0),missing,missing]
		else
			dat2[!,colname]=[rand(25.0:0.01:45.0),rand(20.0:0.01:30.0),missing,missing,missing,missing,rand(25.0:0.01:45.0),rand(20.0:0.01:30.0),missing,missing]
		end
		randg=randg-1
	end
	dat2
end

# ╔═╡ d27e01d0-7f1b-11eb-1c24-a342ee52f1ff
md"**Step 2- Using 'groupby' to make two groups one with temptype=tmax and other with temptype=tmin**"

# ╔═╡ c37cd580-7b15-11eb-16e2-dbe7d4e38184
## using groupby on element column which contains temp type
dat22=groupby(dat2,:element)

# ╔═╡ 2638a36e-7f1c-11eb-3a81-81d68e4c12da
md"**Step 3- Using 'stack' and 'sort' to reshape groups into narrow form**"

# ╔═╡ 13e27ebe-7b21-11eb-35ae-919156123970
begin
	tempmax=DataFrames.stack(dat22[1],5:35)
	tempmin=DataFrames.stack(dat22[2],5:35)
	tempmaxs=sort(tempmax)
	tempmins=sort(tempmin)
end
	

# ╔═╡ 4b56a980-7b21-11eb-2c38-ebade07dd33c
## generating a date column with date as y-m-date from the untidy data available

begin
	list_d= Matrix{Union{String,Nothing}}(nothing,155, 1)
	list_d2= Matrix{Union{String,Nothing}}(nothing,155, 1)
	for i in 1:155
		date_tmax=tempmaxs[i,5]
		date_tmin=tempmins[i,5]
		number_as_string= split(date_tmax,"d")[end]
		number_as_string2=split(date_tmin,"d")[end]
		daytmax=parse(Int, number_as_string)
		daytmin=parse(Int, number_as_string2)
		
		list_d[i]=string(tempmaxs[i,2],"-",Int(tempmaxs[i,3]),"-",daytmax)
		list_d2[i]=string(tempmins[i,2],"-",Int(tempmins[i,3]),"-",daytmin)
	end 
	tempmaxs[!,"dates"]=list_d[:]
	tempmins[!,"dates"]=list_d2[:]
end

# ╔═╡ 586b3720-7f1e-11eb-05ff-a3baa16582a5
md" **Step 3- Using 'outerjoin' to get a cleaner format of data, telling daywise temperature along with ids**"

# ╔═╡ bffeb0a0-7b28-11eb-016d-9d929de8e569
## Generating required tidy dataframe

begin
	final_th= select(tempmaxs,:id,:dates,:value)
	final_tl=select(tempmins,:dates,:value)
	final=outerjoin(final_th,final_tl,on=:dates, makeunique=true)
	colnames = ["ID","Date","Tmax","Tmin"]
	rename!(final, Symbol.(colnames))
end
	

# ╔═╡ c13a9340-7f1e-11eb-37ea-bd4de3de0c24
md" # Q3- Generating two data frames as a part of the tidy dataset"

# ╔═╡ dad12c60-7f1e-11eb-321d-13282f483baf
md"**Step 1- Generating untidy data set with songs of three artist, two songs in year 2000, and one in year 2001**"

# ╔═╡ 69eb89f0-7b31-11eb-29a4-89ed0ef5ac55
## Generating undity dataset

begin
	datf3=DataFrame(Year=Int[], artist=String[], time=String[], track=String[],
	date=String[], week=Int[], rank=Int[])
	push!(datf3,(2000,"2 Pac","4:22","Baby Don't Cry","2000-02-26",  1 ,87)) 
	push!(datf3,(2000,"2 Pac","4:22","Baby Don't Cry","2000-03-04", 2 ,82 ))
	push!(datf3,(2000,"2 Pac","4:22","Baby Don't Cry","2000-03-11 ",  3 ,  72))
	push!(datf3,(2000,"2 Pac", "4:22","Baby Don't Cry","2000-03-18",  4 , 77))
	push!(datf3,(2000,"2 Pac","4:22","Baby Don't Cry","2000-03-25",   5 , 87 ))
	push!(datf3,(2000,"2 Pac","4:22","Baby Don't Cry","2000-04-01",6 , 94 ))
	push!(datf3,(2000,"2 Pac", "4:22","Baby Don't Cry","2000-04-08",7,99))
	push!(datf3,(2000,"3 Doors Down","3:53","Kryptonite","2000-04-08",1,81 ))
	push!(datf3,(2000,"3 Doors Down","3:53","Kryptonite","2000-04-15",2,70 ))
	push!(datf3,(2000,"3 Doors Down","3:53","Kryptonite","2000-04-22",3, 68 ))
	push!(datf3,(2000,"3 Doors Down","3:53","Kryptonite","2000-04-29", 4, 67)) 
	push!(datf3,(2000,"3 Doors Down","3:53","Kryptonite","2000-05-06",5,66 ))
	push!(datf3,(2001,"2Ge+her","3:15","The Hardest Part Of ...","2001-09-02",1,91 ))
	push!(datf3,(2001,"2Ge+her","3:15","The Hardest Part Of ...", "2001-09-09",2,87))
	push!(datf3,(2001,"2Ge+her","3:15","The Hardest Part Of ...","2001-09-16",3,92 ))
end

# ╔═╡ 825ed9a0-7f1f-11eb-38b2-134611a26146
md" **Step 2- Generating the required two dataframes (Giving index in second dataframe according to artist's song)**"

# ╔═╡ 86712530-7f2d-11eb-1d57-8784d116e28b
begin
	static=select(datf3,:Year,:artist,:time,:track)
	newstatic=DataFrame(Year=Int[],artist=String[], time=String[], track=String[])
	dynamic=select(datf3,:date,:rank)
	trow=nrow(datf3)
	songid=zeros(trow)
	songs=datf3[!,:track]
	songnumber=datf3[1,:track]
	ind=1
	checkid=1
	totalsongsindex=[]
	push!(totalsongsindex,1)
	for s in songs
		if songnumber!=s
			push!(totalsongsindex,ind)
			songnumber=s
			checkid+=1
			songid[ind]=checkid
		else
			songid[ind]=checkid
		end
		
		ind+=1
	end
	dynamic[!,:songID]=songid
	
	for t in totalsongsindex
		push!(newstatic,(static[t,:]))
	end
	
	newstatic,dynamic[!,[3,1,2]]
	
end	
	
	

# ╔═╡ a286f350-7f26-11eb-32e7-9f468c29850f
md"# Q4- Use split-apply-combine to report the aggregate number of confirmed, deceased, and recovered cases in each calendar month"

# ╔═╡ d1974a50-7f26-11eb-2821-a5868be5d3e6
begin
	md" **Step 1-
a) To parse the data availaible in url as json file
b) extracting case-time-series dictionary from json file as it contains the required columns
c) Transforming dictionary as DataFrame**"
end

# ╔═╡ 16455030-7a6c-11eb-1486-a975aed8d2cd
begin
	resp = HTTP.get("https://api.covid19india.org/data.json")
	str = String(resp.body)
	jobj = JSON.parse(str)
	count=1
	dat4=DataFrame(dailyconfirmed=String[],dailydeceased=String[],dailyrecovered=String[],date=String[],dateymd=String[],totalconfirmed=String[],totaldeceased=String[],totalrecovered=String[])
	
	dict4=jobj["cases_time_series"]
	for _ in dict4
		push!(dat4,dict4[count])
		count+=1
	end
	dat4
end

# ╔═╡ 7a762fae-7f27-11eb-31eb-0370690b3cc4
md" **Step 2- To group the data first by years and futher group yearwise data into month wise data**"

# ╔═╡ 159776e0-7ef4-11eb-3c51-2f3e64180bb9
# to get yearwise and month wise data, we split the given date in seperate columns of year, month and date

begin
	dat4[!,:dc] = parse.([Int],dat4[!,:dailyconfirmed])
	dat4[!,:dde] = parse.([Int],dat4[!,:dailydeceased])
	dat4[!,:dr] = parse.([Int],dat4[!,:dailyrecovered])
	final4=select(dat4,:dateymd,:dc,:dde,:dr)
	final4[!,:year]=[i[1] for i in [split(i,"-") for i in final4[!,:dateymd]]]
	final4[!,:month]=[i[2] for i in [split(i,"-") for i in final4[!,:dateymd]]]
	final4[!,:day]=[i[3] for i in [split(i,"-") for i in final4[!,:dateymd]]]
	fin4= select(final4,:year,:month,:day,:dc,:dde,:dr)

	group4=groupby(fin4,:year) #Contains yearwise groups, one of 2019, other of 2020
	
	group41=groupby(group4[1],:month) #Contains monthwise dates in year 2019
	group42=groupby(group4[2],:month) #Contains monthwise dates in year 2020

end
	

# ╔═╡ 26c339c0-7f28-11eb-05d7-5b2f6bf2ae28
md" **Step 3- Using 'combine' to get aggregated values of total number of confirmed cases, reported deaths and total recovery for each month in the yearwise group**"

# ╔═╡ d5b4e150-7f04-11eb-1af5-53e87140825a
Aggregate2020=combine(group41,:dc => sum =>"MonthlyTotalConfirmed",:dde=>sum=>"MonthlyTotalDeath",:dr=>sum=>"MonthlyTotalRecovery")

# ╔═╡ d7bd3470-7f04-11eb-18d5-f33c9b5b285d
Aggregate2021=combine(group42,:dc => sum=>"MonthlyTotalConfirmed",:dde=>sum=>"MonthlyTotalDeath",:dr=>sum=>"MonthlyTotalRecovery")

# ╔═╡ ed0e5150-7f28-11eb-042d-cfc4b4b44186
md"# Q5-To compute 7 preceding days’ moving average for each of the three columns - confirmed, deceased, and recovered as three new columns"

# ╔═╡ d3e0d5e0-7f0a-11eb-285e-53298605cdbd
#the dataframe with following columns- year, month, day, total confirmed cases, total deceased cases, total recovered cases

fin4

# ╔═╡ 371c2f00-7f2a-11eb-02d6-714ba792af1c

	arow=nrow(fin4) #to count number of column in dataframe fin4


# ╔═╡ 408707ee-7f29-11eb-2952-5f6bd92cf8e8
md"**Step 1- Extracting column of total confirmed (tc) cases and forming a new column with moving average taking 7 preceding inputs of tc column; The results are then plotted**"

# ╔═╡ ecba2130-7f04-11eb-1190-7de12254e35b
begin
	v1=select(fin4,:dc)
	v1[!,:movingavg]=zeros(arow)
	for i in 7:arow
		calc=0
		for k in i-6:i
			calc+=v1[k,:dc]
		end
		v1[i,:movingavg]=calc/7 #new moving avg column 
	end
end
		
		

# ╔═╡ 30100990-7f0a-11eb-0db7-57303610a69d
plot(1:arow,v1[!,:movingavg],ylabel="Moving Average for daily confirmed cases", xlabel="number of days since first covid case was reported", legend=false)

# ╔═╡ 02bc2f00-7f5f-11eb-1930-d54aaf5b242a
plot(1:arow,v1[!,:dc],ylabel="daily confirmed cases", xlabel="number of days since first covid case was reported", legend=false)

# ╔═╡ c5c5bfb0-7f29-11eb-2d46-fbf527609e01
md"**Step 2- Extracting column of total deaths registered (td) cases and forming a new column with moving average taking 7 preceding inputs of td column; The results are then plotted**"

# ╔═╡ 463cc3be-7f0a-11eb-102f-11ca55c7a56f
begin
	v2=select(fin4,:dde)
	v2[!,:movingavg]=zeros(arow)
	v2[!,:actualavg]=zeros(arow)
	for i in 7:arow
		calc=0
		for k in i-6:i
			calc+=v2[k,:dde]
		end
		v2[i,:movingavg]=calc/7
	end
	
end

# ╔═╡ 63b52af0-7f0a-11eb-20cd-5926e088fb5e
plot(1:arow,v2[!,:movingavg],ylabel="Moving Average for daily deaths reported", xlabel="number of days since first covid case was reported", legend=false)

# ╔═╡ df9f1410-7f5e-11eb-34cf-e369d81d9d40
plot(1:arow,v2[!,:dde],ylabel="daily deaths reported", xlabel="number of days since first covid case was reported", legend=false)

# ╔═╡ d3bc1ec0-7f29-11eb-1c07-6b29b10347a9
md"**Step 3- Extracting column of total recovered cases (tr) cases and forming a new column with moving average taking 7 preceding inputs of tr column; The results are then plotted**"

# ╔═╡ 88ec2530-7f0a-11eb-12c6-3fdb8ed3124e
begin
	v3=select(fin4,:dr)
	v3[!,:movingavg]=zeros(arow)
	for i in 7:arow
		calc=0
		for k in i-6:i
			calc+=v3[k,:dr]
		end
		v3[i,:movingavg]=calc/7
	end
	
end

# ╔═╡ 99f4cd50-7f0a-11eb-0840-9b81df8077c8
plot(1:arow,v3[!,:movingavg],ylabel="Moving Average for daily recovered cases", xlabel="number of days since first covid case was reported", legend=false)

# ╔═╡ 7d7b37e0-7f5f-11eb-3e0c-2f38798ef1cf
plot(1:arow,v3[!,:dr],ylabel="daily recovered cases", xlabel="number of days since first covid case was reported", legend=false)

# ╔═╡ Cell order:
# ╠═35a28ee0-7f4c-11eb-0c8a-bd85b8e01809
# ╟─7203626e-7f14-11eb-0091-bf33d3d96783
# ╟─a81b3180-7f14-11eb-3532-db45cfd75238
# ╠═6fee7c7e-797f-11eb-11d5-79d090f691b4
# ╟─d49637a0-7f14-11eb-0e84-6ff14239ed3a
# ╠═c8666e60-799b-11eb-0d7e-1bc4712feeec
# ╟─24be3ca2-7f15-11eb-1c8b-6f961504e329
# ╟─fb040ec2-7f15-11eb-1eeb-d5de33cf9c8f
# ╠═30d3017e-79d2-11eb-33ce-9b4ce43e51cb
# ╠═82e9ba50-79d6-11eb-2da1-f3080d412f76
# ╠═be4a5a20-79d9-11eb-0ec7-571d7914767e
# ╟─d27e01d0-7f1b-11eb-1c24-a342ee52f1ff
# ╠═c37cd580-7b15-11eb-16e2-dbe7d4e38184
# ╟─2638a36e-7f1c-11eb-3a81-81d68e4c12da
# ╠═13e27ebe-7b21-11eb-35ae-919156123970
# ╠═4b56a980-7b21-11eb-2c38-ebade07dd33c
# ╟─586b3720-7f1e-11eb-05ff-a3baa16582a5
# ╠═bffeb0a0-7b28-11eb-016d-9d929de8e569
# ╟─c13a9340-7f1e-11eb-37ea-bd4de3de0c24
# ╟─dad12c60-7f1e-11eb-321d-13282f483baf
# ╠═69eb89f0-7b31-11eb-29a4-89ed0ef5ac55
# ╠═825ed9a0-7f1f-11eb-38b2-134611a26146
# ╠═86712530-7f2d-11eb-1d57-8784d116e28b
# ╟─a286f350-7f26-11eb-32e7-9f468c29850f
# ╟─d1974a50-7f26-11eb-2821-a5868be5d3e6
# ╠═16455030-7a6c-11eb-1486-a975aed8d2cd
# ╠═62b78ee0-7efb-11eb-3188-6f8bd7d0d786
# ╟─7a762fae-7f27-11eb-31eb-0370690b3cc4
# ╠═159776e0-7ef4-11eb-3c51-2f3e64180bb9
# ╟─26c339c0-7f28-11eb-05d7-5b2f6bf2ae28
# ╠═d5b4e150-7f04-11eb-1af5-53e87140825a
# ╠═d7bd3470-7f04-11eb-18d5-f33c9b5b285d
# ╟─ed0e5150-7f28-11eb-042d-cfc4b4b44186
# ╠═d3e0d5e0-7f0a-11eb-285e-53298605cdbd
# ╠═371c2f00-7f2a-11eb-02d6-714ba792af1c
# ╟─408707ee-7f29-11eb-2952-5f6bd92cf8e8
# ╠═ecba2130-7f04-11eb-1190-7de12254e35b
# ╠═30100990-7f0a-11eb-0db7-57303610a69d
# ╠═02bc2f00-7f5f-11eb-1930-d54aaf5b242a
# ╟─c5c5bfb0-7f29-11eb-2d46-fbf527609e01
# ╠═463cc3be-7f0a-11eb-102f-11ca55c7a56f
# ╠═63b52af0-7f0a-11eb-20cd-5926e088fb5e
# ╠═df9f1410-7f5e-11eb-34cf-e369d81d9d40
# ╟─d3bc1ec0-7f29-11eb-1c07-6b29b10347a9
# ╠═88ec2530-7f0a-11eb-12c6-3fdb8ed3124e
# ╠═99f4cd50-7f0a-11eb-0840-9b81df8077c8
# ╠═7d7b37e0-7f5f-11eb-3e0c-2f38798ef1cf
