### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 65d63920-8700-11eb-0505-297588cb23ed
begin
	using Plots
	plotly()
end

# ╔═╡ 766622ce-89f5-11eb-0be2-bf98029f7f76
using PlutoUI

# ╔═╡ 78487760-89f5-11eb-1eb6-89625881ae22
using StatsPlots

# ╔═╡ c0c634a0-89f5-11eb-163c-ffd602e5c51e
using Distributions

# ╔═╡ f39f6890-89f7-11eb-2649-03b6c4faf274
using QuadGK

# ╔═╡ d6c3cce0-8a13-11eb-0fb8-9dd224a06c3b
using Random

# ╔═╡ bc47a3d0-8a15-11eb-06fe-9fcf0f620520
using FreqTables

# ╔═╡ d05e7650-8a15-11eb-1032-bd7c093748e4
using DataFrames

# ╔═╡ 6536d340-8ace-11eb-3d0d-fd64771965a9
using Dates

# ╔═╡ 79adb110-93d7-11eb-1312-81c3dd21a94e
using Statistics

# ╔═╡ e122a76e-db52-4510-af34-bdad1feae81b
using StatsBase

# ╔═╡ ce626290-8c62-11eb-04e0-a99973cb4d17
using CSV

# ╔═╡ 86bd6630-89fe-11eb-3d8a-ab03bb6f6478
md"### Question 1"

# ╔═╡ c1978700-89f8-11eb-1907-514f109afec7
Q=Normal(0,1)

# ╔═╡ 46da7540-9290-11eb-2a34-addad677a5ef
begin
	data1=DataFrame(v_value=[], KLDiv=[])
	for v in 1:5
	P=Distributions.TDist(v)
	cal= quadgk(x->pdf(P,x)log(pdf(P,x)/pdf(Q,x)),-20,20)[1]
		
	#Taking range for KLDiv calc as -20 to 20, the range is good enough to cover most of T distribution,  as KL div cannot be calculated from -Inf to Inf
		
	push!(data1,(v,cal))
		
	end
end

# ╔═╡ 8912c000-9292-11eb-1de7-9f84121be6e8
data1

# ╔═╡ 37dd98a0-89fe-11eb-0dec-05267da3169a
md"### Question 2"

# ╔═╡ 919aada5-18d5-4ba3-b34e-5d11017a6b12
U= Uniform(0,1)

# ╔═╡ 054fac2b-7a91-4ced-860a-d1d3f8e2fa25
begin
	conv(x) = sum(pdf(U,x-k)*pdf(U,k)*0.01 for k=-10:0.01:10)
	conv_arr= conv.(-10:0.01:10)
	plot([-10:.01:10], conv_arr, line=3, label="Uniform convoluted with Uniform")
end

# ╔═╡ 0a2dac5e-04f5-49c3-a95a-3f13a49259f0
begin
	Conv_pdfs=DataFrame() #This DATAFRAME will contain all pdf values of convoluted array
	insertcols!(Conv_pdfs,1,:c=>conv_arr,makeunique=true)
end

# ╔═╡ 4fec64dc-fc72-4ee5-b9b4-96ce0e0d4147
#incase shows error, kindly rerun this cell, should work

begin
	plot(-10:0.01:10,Conv_pdfs[!,1], label="n=2")
	plot!(-10:0.01:10,Conv_pdfs[!,2],label="n=3")
	plot!(-10:0.01:10,Conv_pdfs[!,3],label="n=4")
	plot!(-10:0.01:10,Conv_pdfs[!,4],label="n=5")
	plot!(-10:0.01:10,Conv_pdfs[!,5],label="n=6")
	plot!(-10:0.01:10,Conv_pdfs[!,6],label="n=7")
	plot!(-10:0.01:10,Conv_pdfs[!,7],label="n=8")
	plot!(-10:0.01:10,Conv_pdfs[!,8],label="n=9")
	plot!(-10:0.01:10,Conv_pdfs[!,9],label="n=10")

end

# ╔═╡ a0c9b5cf-8b2e-49ad-9a6b-6664b742fce1
# function to find convoluted array values as we keep increasing n

function Conv_calc(A)
	conv_arr2=zeros(2001)
	CV=A
	c=1
	for x in -10:0.01:10
		f=0
		tr=1
		for k in -10:0.01:10
			f=f+CV[tr]*pdf(U,x-k)*0.01 
			tr+=1
		end
		conv_arr2[c]=f
		c+=1
	end
	return conv_arr2
end

# ╔═╡ 7ec4f697-6b00-497a-be8f-82e8d4cfccf6
#function to calc mean
function mean_calc(C)
	CV=C
	tr=1
	means=0
	stdd=0
	for x in -10:0.01:10
			means=means+CV[tr]*x*0.01
			tr+=1
	end
	
	return means
end

# ╔═╡ 71ee4a53-75ca-41d6-9e8c-f7ca411d4b1f
#function to calc standard deviation
function std_calc(D,m)
	tr=1
	stdd=0
	CV=D
	means=m
	for x in -10:0.01:10
			stdd=stdd+CV[tr]*(x-means)^2*0.01
			tr+=1
	end
	return stdd^0.5
end

# ╔═╡ 2981b36e-6ca6-4b8e-bdee-d04714e19178
begin
	meanstdKld=DataFrame(meanvalue=Float64[],standDev=Float64[])
	meand=mean_calc(conv_arr)
	Stdd= std_calc(conv_arr,meand)
	push!(meanstdKld,[meand,Stdd])
end

# ╔═╡ 36f307ab-e619-4990-a255-daf18299a9f5
conv_arr


# ╔═╡ 485e379b-0ef7-4dd5-b915-bf1b5a7f5913
# loop to find convoluted array for n>2, also to find mean and std of pdf values for all n

begin
	for coco in 2:9
	cnew=Conv_calc(conv_arr)
	mean=mean_calc(cnew)
	Std= std_calc(cnew,mean)
	conv_arr=cnew
	push!(meanstdKld,[mean,Std])
	insertcols!(Conv_pdfs,coco,:c=>cnew,makeunique=true)
	end
end


# ╔═╡ 584185b6-06cc-41b4-95e3-1570be9cd0e4
#function to calc KL divergence
function klkl(N,D,n)
	tr=1001
	adin=0
	P=N
	CV=D
	lim=n
	for x in 0:0.01:lim
		adin=adin+(CV[tr]log(CV[tr]/pdf(P,x)))*0.01
		tr+=1
	end
	
	return adin
end

# ╔═╡ ce2968b6-7ac2-4183-bcdf-33bdb72a3035
begin
	lkd=zeros(9)
	n=2
	for jj in 1:9
		newnormal=Normal(meanstdKld[jj,1],meanstdKld[jj,2])
		lkd[jj]=klkl(newnormal,Conv_pdfs[!,jj],n)
		n+=1
	end
	insertcols!(meanstdKld,1,:N=>2:10,makeunique=true)
	insertcols!(meanstdKld,4,:KLDiv=>lkd,makeunique=true)
end

# ╔═╡ cc2fb44e-2867-4a13-ae35-80591fdc2c91
#incase shows error, kindly rerun this cell, should work

begin
	plot(-10:0.01:10,Conv_pdfs[!,1], label="n=2")
	plot!(-10:0.01:10,Conv_pdfs[!,2],label="n=3")
	plot!(-10:0.01:10,Conv_pdfs[!,3],label="n=4")
	plot!(-10:0.01:10,Conv_pdfs[!,4],label="n=5")
	plot!(-10:0.01:10,Conv_pdfs[!,5],label="n=6")
	plot!(-10:0.01:10,Conv_pdfs[!,6],label="n=7")
	plot!(-10:0.01:10,Conv_pdfs[!,7],label="n=8")
	plot!(-10:0.01:10,Conv_pdfs[!,8],label="n=9")
	plot!(-10:0.01:10,Conv_pdfs[!,9],label="n=10")
	plot!(Normal(meanstdKld[1,2],meanstdKld[1,3]),label="Normal n=2")
	plot!(Normal(meanstdKld[2,2],meanstdKld[2,3]),label="Normal n=3")
	plot!(Normal(meanstdKld[3,2],meanstdKld[3,3]),label="Normal n=4")
	plot!(Normal(meanstdKld[4,2],meanstdKld[4,3]),label="Normal n=5")
	plot!(Normal(meanstdKld[5,2],meanstdKld[5,3]),label="Normal n=6")
	plot!(Normal(meanstdKld[6,2],meanstdKld[6,3]),label="Normal n=7")
	plot!(Normal(meanstdKld[7,2],meanstdKld[7,3]),label="Normal n=8")
	plot!(Normal(meanstdKld[8,2],meanstdKld[8,3]),label="Normal n=9")
	plot!(Normal(meanstdKld[9,2],meanstdKld[9,3]),label="Normal n=10")
end

# ╔═╡ 2c3730ec-e275-40ba-9e48-3b59c892276f
# To show for n=3 we have smallest value of KL Divergence as we see maximum overlap
#incase shows error, kindly rerun this cell, should work

begin
	plot(-10:0.01:10,Conv_pdfs[!,2],label="n=3")
	plot!(Normal(meanstdKld[2,2],meanstdKld[2,3]),label="Normal n=3")
end

# ╔═╡ 5dc5c03e-1950-4dfc-aa78-4145828f0039
# Plotting KL Divergence value for all values of n
begin
	plot(2:10,meanstdKld[!,4])
	scatter!([2:10],meanstdKld[!,4])
end

# ╔═╡ 3ef6c170-92a5-11eb-10e6-5dc6425a72e8
md"### Question 3"

# ╔═╡ 10b4a000-8b8b-11eb-34af-61c75f5f0ef9
begin
	dataa=[]
	for k in 1:2905
		if k<=1100
			push!(dataa,1)
		elseif k<=2500
				push!(dataa,2)
			elseif k<=2800
					push!(dataa,3)
				elseif k<=2900
						push!(dataa,4)
					else
						push!(dataa,5)
		end
	end
			
	histogram(dataa,nbins=5)
	plot!([median(dataa),median(dataa)],[0,1500],label="Median", line=(3, :dot, :red))
	plot!([mean(dataa),mean(dataa)],[0,1500],label="Mean",line=(3,:orange))
end

# ╔═╡ 77a97210-8a12-11eb-3b45-e3b59c6d6057
md"### Question 4"

# ╔═╡ 6792966e-76bf-4399-b38e-af81d0f688fa
Random.seed!(0)

# ╔═╡ eaadea10-8a13-11eb-0265-2bddc71b9a4a
r=zeros(10000)

# ╔═╡ 826b20d0-8ab3-11eb-21b4-5db05c2eeaf0
c=Uniform(0,1)

# ╔═╡ 489af402-8a0b-11eb-1704-7dba6dee713f
function sample()
	v1=[rand(c) for i in 1:30]
	return v1
end

# ╔═╡ 70be3490-8a12-11eb-107c-5b1f55672c91
for i in 1:10000
	s=sample()
	r[i]= maximum(s)- minimum(s)
end 	

# ╔═╡ f062cec0-2a0f-492f-bb59-fbd797755dbb
h=fit(Histogram,r)

# ╔═╡ eb7e32a6-126b-4b48-87d2-46aea206e75a
begin
	# get the height of the most populated bin:
bin_max = maximum(h.weights)
mode_bin=mean(bin_max)
# get the position of this bin in the weights list:
i = findfirst(x -> x==bin_max, h.weights)

# get the values of the edges corresponding to this position
bin_pos = h.edges[1][i:i+1]

end

# ╔═╡ 528307b0-8a14-11eb-2046-491b6b441835
#Labelling mean, median, mode
begin
	histogram(r)
	plot!([mode(r),mode(r)],[0,600], label="Mode of Data", line=(3, :dash, :yellow),legend=:topleft)
	plot!([median(r),median(r)],[0,600],label="Median", line=(3, :dot, :red),legend=:topleft)
	plot!([mean(r),mean(r)],[0,600],label="Mean",line=(3,:orange),legend=:topleft)
	plot!([mean(bin_pos),mean(bin_pos)],[0,600],label="Mode of histogram",line=(3,:green),legend=:topleft)

end

# ╔═╡ 6e3f1bd0-8ab7-11eb-3709-f31a0025e8db
md"### Question 5"

# ╔═╡ 44358e10-8d2c-11eb-0923-c59fe041fd18
function rg(u,t,mi)
	rx=maximum(u)
	mix=minimum(u)
	mx=t+mi
	if rx>mx && mx<=1 && mix<=mi
		return 1
	else 
		return 0
	end
end

# ╔═╡ 9fd165f0-8d2c-11eb-26e1-01e3242366a6
begin
	data5=DataFrame(theta_val=[],min_limit_val=[],Probability=[], Absolute_err_with_theoretical=[])
	for min_limit in 0.1:0.1:0.9
	thet=rand(Uniform(0,1))
	ss=0
		for n in 1:100000
			ux=rand(Uniform(0,1),30)
			ss=ss+rg(ux,thet,min_limit)
			end
		px=ss/100000
		if thet+min_limit<=1
			er=abs(px-((1-(1-min_limit)^30)*(1-(thet+min_limit)^30)))
		else
			er= missing
		end
		push!(data5,(thet,min_limit,px,er))
		
		end
end


# ╔═╡ 10aae102-92a7-11eb-280a-c9f3efc93bc5
data5

# ╔═╡ f4f5de80-8ac0-11eb-38bb-3fd6c82c4905
md"### Question 6"

# ╔═╡ f1ff81e2-8ac0-11eb-0532-a50be13307a5
dat=CSV.read("C:\\Users\\Chrisvin\\Downloads\\states.csv",DataFrame)

# ╔═╡ 02b00e10-8c65-11eb-2fc4-db42556e5758
G=groupby(dat,:State)

# ╔═╡ 28f4a7c0-8c65-11eb-0686-538f8fef893b
begin
	wk = DataFrame()
	j1=1;
	for g in G
		weekly=zeros(106)
		for i in 1:nrow(g)
			if Dates.isleapyear(g[i,1])==true
				t=Dates.week(g[i,1])
				weekly[t]+=g[i,3]
			else
				t=Dates.week(g[i,1])
				weekly[t+52]+=g[i,3]
			end
		end
		
		insertcols!(wk,j1,:s=>weekly,makeunique=true)
		j1+=1
	end
end
		
	

# ╔═╡ db78ca70-8c79-11eb-1482-7b9a7bfe06bc
wk

# ╔═╡ 1cfc6f60-8c75-11eb-0565-d57c7ae1c8d1
function covmat(df)
   nc = ncol(df)
   t = zeros(nc, nc)
   for (i, c1) in enumerate(eachcol(df))
	   for (j, c2) in enumerate(eachcol(df))
		   sx, sy = skipmissings(c1, c2)
		   t[i, j] = cov(collect(sx), collect(sy))
	   end
   end
   return t
   end;

# ╔═╡ 15922490-8c7a-11eb-142d-9dbfd56b603f
covmat(wk)

# ╔═╡ 6d6c1270-8c7a-11eb-3376-4f7803a726e6
function cormat(df)
   nc = ncol(df)
   t = zeros(nc, nc)
   for (i, c1) in enumerate(eachcol(df))
	   for (j, c2) in enumerate(eachcol(df))
		   sx, sy = skipmissings(c1, c2)
		   t[i, j] = cor(collect(sx), collect(sy))
	   end
   end
   return t
   end;

# ╔═╡ 6ff4b920-8c7a-11eb-2603-ab7166cd53ff
cormat(wk)

# ╔═╡ 9a9c1710-8c82-11eb-3024-23d7e2e5e945
wks=copy(wk)

# ╔═╡ af935e80-8c82-11eb-0e3c-a9e20bcefe1d
for r1 in 1:38
		e=wks[!,r1]
		wks[!,r1]=[indexin(e[i], sort(e))[1] for i in 1:length(e)]
end

# ╔═╡ 84e44950-8c83-11eb-15ad-3f686caa6929
wks

# ╔═╡ c87ef520-8c83-11eb-25da-255c2ec86144
cormat(wks)

# ╔═╡ 77b0cfa0-8c84-11eb-2943-555319ac4326
#covariance matrix plotting
begin
	xs = [string("s", i) for i = 1:38]
	ys = [string("s", i) for i = 1:38]
	z = float(covmat(wk))
	heatmap(xs,ys,z)
end

# ╔═╡ ace2ab80-8c84-11eb-1437-296c35b0a5d4
#correlation matrix plotting

begin
	xs2 = [string("s", i) for i = 1:38]
	ys2 = [string("s", i) for i = 1:38]
	z2 = float(cormat(wk))
	heatmap(xs2,ys2,z2)
end

# ╔═╡ bade88d0-8c84-11eb-1de3-27bf9681cfa3
#Spearman correlation matrix plotting
begin
	xs3 = [string("s", i) for i = 1:38]
	ys3 = [string("s", i) for i = 1:38]
	z3 = float(covmat(wks))
	heatmap(xs3,ys3,z3)
end

# ╔═╡ 31fa7710-8ad4-11eb-1289-9d609a02f638
md"### Question 7"

# ╔═╡ f4a31360-8c5c-11eb-0c13-27da07d82ab5
function OneSidedTail(x)
	per=(100-x)/100
	cdf_n(y) = cdf(Normal(0, 1), y)
	cdf_n_inv(u) = minimum(filter((x) -> (cdf_n(x) >= u), -5:0.01:5))
	return cdf_n_inv(per)
end
	

# ╔═╡ 951ef2e0-8c5e-11eb-3b3c-6db1b0d0dd55
function OneSidedTailT(x)
	per=(100-x)/100
	cdf_nT(y) = cdf(TDist(10), y)
	cdf_n_invT(u) = minimum(filter((x) -> (cdf_nT(x) >= u), -5:0.01:5))
	return cdf_n_invT(per)
end
	

# ╔═╡ b9d59990-8c5e-11eb-32b6-c38a08bfea1d
begin
	plot(x->x,x->OneSidedTail(x),1,100,label="NormDist")
	scatter!([95],[OneSidedTail(95)], label="x=95 for NormDist")
	plot!(x->x,x->OneSidedTailT(x),1,100,label="TDist")
	scatter!([95],[OneSidedTailT(95)],label="x=95 for TDist")
end

# ╔═╡ Cell order:
# ╠═65d63920-8700-11eb-0505-297588cb23ed
# ╠═766622ce-89f5-11eb-0be2-bf98029f7f76
# ╠═78487760-89f5-11eb-1eb6-89625881ae22
# ╠═c0c634a0-89f5-11eb-163c-ffd602e5c51e
# ╠═f39f6890-89f7-11eb-2649-03b6c4faf274
# ╠═d6c3cce0-8a13-11eb-0fb8-9dd224a06c3b
# ╠═bc47a3d0-8a15-11eb-06fe-9fcf0f620520
# ╠═d05e7650-8a15-11eb-1032-bd7c093748e4
# ╠═6536d340-8ace-11eb-3d0d-fd64771965a9
# ╠═79adb110-93d7-11eb-1312-81c3dd21a94e
# ╟─86bd6630-89fe-11eb-3d8a-ab03bb6f6478
# ╠═c1978700-89f8-11eb-1907-514f109afec7
# ╠═46da7540-9290-11eb-2a34-addad677a5ef
# ╠═8912c000-9292-11eb-1de7-9f84121be6e8
# ╟─37dd98a0-89fe-11eb-0dec-05267da3169a
# ╠═919aada5-18d5-4ba3-b34e-5d11017a6b12
# ╠═054fac2b-7a91-4ced-860a-d1d3f8e2fa25
# ╠═0a2dac5e-04f5-49c3-a95a-3f13a49259f0
# ╠═4fec64dc-fc72-4ee5-b9b4-96ce0e0d4147
# ╠═a0c9b5cf-8b2e-49ad-9a6b-6664b742fce1
# ╠═7ec4f697-6b00-497a-be8f-82e8d4cfccf6
# ╠═71ee4a53-75ca-41d6-9e8c-f7ca411d4b1f
# ╠═2981b36e-6ca6-4b8e-bdee-d04714e19178
# ╠═36f307ab-e619-4990-a255-daf18299a9f5
# ╠═485e379b-0ef7-4dd5-b915-bf1b5a7f5913
# ╠═584185b6-06cc-41b4-95e3-1570be9cd0e4
# ╠═ce2968b6-7ac2-4183-bcdf-33bdb72a3035
# ╠═cc2fb44e-2867-4a13-ae35-80591fdc2c91
# ╠═2c3730ec-e275-40ba-9e48-3b59c892276f
# ╠═5dc5c03e-1950-4dfc-aa78-4145828f0039
# ╟─3ef6c170-92a5-11eb-10e6-5dc6425a72e8
# ╠═10b4a000-8b8b-11eb-34af-61c75f5f0ef9
# ╟─77a97210-8a12-11eb-3b45-e3b59c6d6057
# ╠═6792966e-76bf-4399-b38e-af81d0f688fa
# ╠═eaadea10-8a13-11eb-0265-2bddc71b9a4a
# ╠═826b20d0-8ab3-11eb-21b4-5db05c2eeaf0
# ╠═489af402-8a0b-11eb-1704-7dba6dee713f
# ╠═70be3490-8a12-11eb-107c-5b1f55672c91
# ╠═e122a76e-db52-4510-af34-bdad1feae81b
# ╠═eb7e32a6-126b-4b48-87d2-46aea206e75a
# ╠═f062cec0-2a0f-492f-bb59-fbd797755dbb
# ╠═528307b0-8a14-11eb-2046-491b6b441835
# ╟─6e3f1bd0-8ab7-11eb-3709-f31a0025e8db
# ╠═44358e10-8d2c-11eb-0923-c59fe041fd18
# ╠═9fd165f0-8d2c-11eb-26e1-01e3242366a6
# ╠═10aae102-92a7-11eb-280a-c9f3efc93bc5
# ╟─f4f5de80-8ac0-11eb-38bb-3fd6c82c4905
# ╠═ce626290-8c62-11eb-04e0-a99973cb4d17
# ╠═f1ff81e2-8ac0-11eb-0532-a50be13307a5
# ╠═02b00e10-8c65-11eb-2fc4-db42556e5758
# ╠═28f4a7c0-8c65-11eb-0686-538f8fef893b
# ╠═db78ca70-8c79-11eb-1482-7b9a7bfe06bc
# ╠═1cfc6f60-8c75-11eb-0565-d57c7ae1c8d1
# ╠═15922490-8c7a-11eb-142d-9dbfd56b603f
# ╠═6d6c1270-8c7a-11eb-3376-4f7803a726e6
# ╠═6ff4b920-8c7a-11eb-2603-ab7166cd53ff
# ╠═9a9c1710-8c82-11eb-3024-23d7e2e5e945
# ╠═af935e80-8c82-11eb-0e3c-a9e20bcefe1d
# ╠═84e44950-8c83-11eb-15ad-3f686caa6929
# ╠═c87ef520-8c83-11eb-25da-255c2ec86144
# ╠═77b0cfa0-8c84-11eb-2943-555319ac4326
# ╠═ace2ab80-8c84-11eb-1437-296c35b0a5d4
# ╠═bade88d0-8c84-11eb-1de3-27bf9681cfa3
# ╟─31fa7710-8ad4-11eb-1289-9d609a02f638
# ╠═f4a31360-8c5c-11eb-0c13-27da07d82ab5
# ╠═951ef2e0-8c5e-11eb-3b3c-6db1b0d0dd55
# ╠═b9d59990-8c5e-11eb-32b6-c38a08bfea1d
