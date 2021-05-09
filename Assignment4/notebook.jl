### A Pluto.jl notebook ###
# v0.14.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 384be000-a577-11eb-24a0-a59dcf2ff179
using Random

# ╔═╡ fc3ef603-a296-44be-9bc0-60ed1a8ba4f4
using PlutoUI

# ╔═╡ e301509c-f7b9-4f31-a8a4-0206404651af
using Distributions

# ╔═╡ 80d7056d-8988-44a7-97fd-b2eff933a1f2
begin
	using Plots
	plotly()
end

# ╔═╡ a199903d-c7f8-444a-ad17-834a53db1f51
using QuadGK

# ╔═╡ f52a7251-a351-47b6-90ca-f8f2da98b178
using DataFrames

# ╔═╡ 32825131-599e-438a-b8b4-f022e63cc0fe
using StatsBase

# ╔═╡ 36bb82ac-414e-461a-a3e1-14ebe1990992
using Statistics

# ╔═╡ 26ef9627-7086-49df-9205-f3703153e049
md"## Question 1"

# ╔═╡ c771182c-df8c-4f94-9462-0a9b3f85cfe3
md"**(a) Monte Carlo Simulation**"

# ╔═╡ 8fd0b758-678b-4dc5-834e-30f0f46ec530
function headcount(n)
	Random.seed!(0)
	c=0;
	for _ in 1:n
		p=sum([rand(0:1) for _ in 1:50])
		if p>=30
			c=c+1
		end
	end
	return c/n
end

# ╔═╡ acd543e6-a5a2-4197-bdff-d79425880375
headcount(10000000)  #

# ╔═╡ 447d57ac-21e9-4790-bd6a-8b07c5a7e558
md"**(b) Binomial Distribution**"

# ╔═╡ ec703d06-7505-4801-9874-3b7605316d4c
p=1/2 #Probability of geting heads in a toss

# ╔═╡ a4df2eb0-cf79-43ef-be50-f479abc59b9f
head_atleast30=sum([binomial(50,r)*p^(r)*(1-p)^(50-r) for r in 30:50]) 

# ╔═╡ 0440731f-3b8d-44e1-b717-3fb4c4b4eaa0
md"**(c) Central Limit theorm** :Here we can consider the random variable X=Total number of heads in 50 tosses, as the sum of 50 random variables corresponding to wheter throw was heads or tails "

# ╔═╡ 0f67c7ac-1009-49b1-83de-4c88f4ac6076
begin
	n=50;
	meanv=n*p;
	stdv=sqrt(n*p*(1-p));
end

# ╔═╡ 7bb7656d-1771-489b-a660-6eaa1608e6dc
density=Normal(meanv, stdv)

# ╔═╡ 6e91a900-a038-4b3b-ab88-13537ef3d473
x=[i for i in 0:50]

# ╔═╡ 35c44cd9-aeac-40f7-b343-0cf526fb85c6
y=[binomial(50,r)*p^(r)*(1-p)^(50-r) for r in 0:50]

# ╔═╡ 828c0e33-963c-4ece-8455-303a90c48d8f
begin
	plot([x[1],x[1]],[0,y[1]], label="Binomial Distribution", line=(20, :sticks, :red))
	for i in 2:51
		plot!([x[i],x[i]],[0,y[i]], label=false, line=(3, :sticks, :red))
	end
	plot!(0:0.05:50, [pdf(density, x) for x in 0:0.05:50], label="CLT")
end

# ╔═╡ f243fbf2-ee2e-4d24-9289-e4393bea7372
prob=quadgk(x->pdf(density,x),29.5,50)[1]

# ╔═╡ aaeac52f-3a49-4bd3-b33c-326b8319b1f4
md"## Question 2"

# ╔═╡ 2b92a3ad-3c0c-4b4a-b53f-1cd020397000
function CLTmintweak(p)
	v=0
	while(p<1)
		n=50;
		mean=n*p;
		stdval=sqrt(n*p*(1-p));
		density=Normal(mean, stdval)
		prob=quadgk(x->pdf(density,x),29.5,50)[1]
		if prob>=0.5
			v=prob
			break
		end
		p=p+0.0001
	end
	return p,v
end
			

# ╔═╡ b46ddae8-52aa-4543-9dd6-59f9bdc7c96c
function head_bino(p)
	v=0
	while(p<1)
		head_atleast30=sum([binomial(50,r)*p^(r)*(1-p)^(50-r) for r in 30:50])
		if head_atleast30>=0.5
			v=head_atleast30
			break
		end
		p=p+0.0001
	end
	return p,v
end
	

# ╔═╡ 2a62b87c-cdac-4343-be16-f646a9893413
function head_monte(p)
	v=0;
	
	while(p<1)
		Random.seed!(0)
		b= Bernoulli(p)
		c=0;
		s=0;
		n=10000
		for _ in 1:n
			s=sum([Int32(rand(b)) for _ in 1:50])
			if s>=30
				c=c+1
			end
		end
		if (c/n)>=0.5
			v=c/n
			break
		end
		p=p+0.0001
	end
	
	return p,v
end
	

# ╔═╡ bbb49120-0901-45e3-894b-61c1648f11d7
begin
	bino=head_bino(0.5)
	mon=head_monte(0.5)
	Prob_head=CLTmintweak(0.5)
end

# ╔═╡ 45dd2fcf-b6b5-46fc-ad83-ea9dd9f78b0f
begin
	df=DataFrame(method=[],prob_of_getting_head=[],chance_of_getting_atleast_30_heads=[])
	push!(df,("Binomial",bino[1],bino[2]*100))
	push!(df,("MonteCarlo",mon[1],mon[2]*100))
	push!(df,("CLT",Prob_head[1],Prob_head[2]*100))
end

# ╔═╡ dd22d3ba-ec1c-4ec6-89db-d91037dca299
md"## Question 3"

# ╔═╡ 65cedc1d-786a-4032-b65e-266e1eedc22f
xslider = @bind Space_S html"<input type=range min=20 max=35 step=1>"

# ╔═╡ 1c36d859-f29d-4277-a722-8e8db4817d24
Space_S  #Number of space suit

# ╔═╡ 62f5e4c5-0567-4862-97ec-bac9ac230b00
begin
	m=Space_S*100
	sd=sqrt(Space_S)*30
	dist=Normal(m,sd)
	sp=quadgk(x->pdf(dist,x),3000,5000)[1]
end


# ╔═╡ 3fda2060-1f4e-470f-8075-4375917e1218
begin
	plot(2000:0.05:5000, [pdf(dist, x) for x in 2000:0.05:5000], label=	Space_S)
	plot!([3000,3000],[0,pdf(dist,3000)], line=(1, :red), label=false)
	plot!(x->x, x->pdf(dist,x),3000,5000, fill=(0, :red),label=" Probability that suit will last atleast 3000 days")
	
end

# ╔═╡ 3e7749b0-d464-4bb6-801d-884732f7367f
md"## Question 4"

# ╔═╡ acdc3c06-5c10-4467-b618-ee7de7cf8859
md"**(a) Uniform Distribution with a=0 and b=1**"

# ╔═╡ 80947529-12b6-44de-8109-e21ff6ca3b57
df1=DataFrame(Distribution=[], samples=[], Mean_diff=[], Std_diff=[], Skew_diff=[],Kurt_diff=[])

# ╔═╡ a25a2560-b6f3-472d-9672-54b30abc9dbb
begin
	for n in 2:25
		
		dist=[sum(rand(Uniform(0,1),n)) for i in 1:100000]
		m1=mean(dist)
		std1=std(dist)
		
		sk1=(length(dist)/((length(dist)-1)*(length(dist)-2)))*sum((dist.-mean(dist)).^3)/std(dist)^3

		
		k1=(length(dist)*(length(dist)+1))/((length(dist)-1)*(length(dist)-2)*(length(dist)-3))*sum((dist.-mean(dist)).^4)/std(dist)^4-((3*(length(dist)-1)^2)/((length(dist)-2)*(length(dist)-3)))
		
		
		CLT_M1=n*mean(Uniform(0,1))                
		CLT_SD1=sqrt(n)*std(Uniform(0,1))
		Dist1=Normal(CLT_M1,CLT_SD1)
		CLT_Sk1=skewness(Dist1)
		CLT_K1=kurtosis(Dist1)
			
		
		diff1=abs(m1-CLT_M1)
		diff2=abs(std1-CLT_SD1)
		diff3=abs(sk1-CLT_Sk1)
		diff4=abs(k1-CLT_K1)
		
		if diff1<=0.1 && diff2<=0.1 && diff3<=0.1 && diff4<=0.1
			push!(df1,("Uniform with a=0 b=1",n,diff1,diff2,diff3,diff4))
			break
		end
	end
end

# ╔═╡ b7f724dc-086b-4ac7-a5d4-8426c9dc9b9f
md"**(b) Binomial Distribution with p=0.01**"

# ╔═╡ ce236f4e-9948-4f3f-b758-8aec3e8d5474
begin
	for n in 2:25
		
		distn2=[sum(rand(Binomial(100,0.01),n)) for i in 1:100000]
		m2=mean(distn2)
		std2=std(distn2)
		
		
		
		sk2=(length(distn2)/((length(distn2)-1)*(length(distn2)-2)))*sum((distn2.-mean(distn2)).^3)/std(distn2)^3

		
		k2=(length(distn2)*(length(distn2)+1))/((length(distn2)-1)*(length(distn2)-2)*(length(distn2)-3))*sum((distn2.-mean(distn2)).^4)/std(distn2)^4-((3*(length(distn2)-1)^2)/((length(distn2)-2)*(length(distn2)-3)))
		
		
		CLT_M2=n*mean(Binomial(100,0.01))                
		CLT_SD2=sqrt(n)*std(Binomial(100,0.01))
		Dist2=Normal(CLT_M2,CLT_SD2)
		CLT_Sk2=skewness(Dist2)
		CLT_K2=kurtosis(Dist2)
			
		
		diff1=abs(m2-CLT_M2)
		diff2=abs(std2-CLT_SD2)
		diff3=abs(sk2-CLT_Sk2)
		diff4=abs(k2-CLT_K2)
		
		if diff1<=0.1 && diff2<=0.1 && diff3<=0.1 && diff4<=0.1
			push!(df1,("Binomial with N=100,p=0.01",n,diff1,diff2,diff3,diff4))
			break
		end
	end
end

# ╔═╡ 07dbfaea-30fd-44c6-8f44-023a6baceed2
md"**(c) Binomial Distribution with p=0.5**"

# ╔═╡ b1148394-5255-42bc-a9f2-3ebb94cb500b
begin
	
	for n in 2:25
		
		distn3=[sum(rand(Binomial(100,.5),n)) for i in 1:100000]
		m3=mean(distn3)
		std3=std(distn3)
		
		#distn3=(dist3.-m3)./std3
		
		sk3=(length(distn3)/((length(distn3)-1)*(length(distn3)-2)))*
		sum((distn3.-mean(distn3)).^3)/std(distn3)^3

		
		k3=(length(distn3)*(length(distn3)+1))/((length(distn3)-1)*(length(distn3)-2)*(length(distn3)-3))*sum((distn3.-mean(distn3)).^4)/std(distn3)^4-((3*(length(distn3)-1)^2)/((length(distn3)-2)*(length(distn3)-3)))
		
		
		CLT_M3=n*mean(Binomial(100,0.5))                
		CLT_SD3=sqrt(n)*std(Binomial(100,0.5))
		Dist3=Normal(CLT_M3,CLT_SD3)
		CLT_Sk3=skewness(Dist3)
		CLT_K3=kurtosis(Dist3)
			
		
		diff1=abs(m3-CLT_M3)
		diff2=abs(std3-CLT_SD3)
		diff3=abs(sk3-CLT_Sk3)
		diff4=abs(k3-CLT_K3)
		
		if diff1<=0.1 && diff2<=0.1 && diff3<=0.1 && diff4<=0.1
			push!(df1,("Binomial with N=100,p=0.5",n,diff1,diff2,diff3,diff4))
			break
		end
	end
end

# ╔═╡ ec5e140d-a430-4371-9e3e-5c9bb84bb30c
md"**(d) Chi-square distribution with 3 degrees of freedom**"

# ╔═╡ 2fe5297e-f5d5-4f00-b76d-32ebaeff9119
begin
	for n in 2:120
		
		distn4=[sum(rand(Chi(3),n)) for i in 1:100000]
		m4=mean(distn4)
		std4=std(distn4)
		
	
		sk4=(length(distn4)/((length(distn4)-1)*(length(distn4)-2)))*sum((distn4.-mean(distn4)).^3)/std(distn4)^3

		
		k4=(length(distn4)*(length(distn4)+1))/((length(distn4)-1)*(length(distn4)-2)*(length(distn4)-3))*sum((distn4.-mean(distn4)).^4)/std(distn4)^4-((3*(length(distn4)-1)^2)/((length(distn4)-2)*(length(distn4)-3)))
		
		
		CLT_M4=n*mean(Chi(3))                
		CLT_SD4=sqrt(n)*std(Chi(3))
		Dist4=Normal(CLT_M4,CLT_SD4)
		CLT_Sk4=skewness(Dist4)
		CLT_K4=kurtosis(Dist4)
			
		
		diff1=abs(m4-CLT_M4)
		diff2=abs(std4-CLT_SD4)
		diff3=abs(sk4-CLT_Sk4)
		diff4=abs(k4-CLT_K4)
		
		if diff1<=0.1 && diff2<=0.1 && diff3<=0.1 && diff4<=0.1
			push!(df1,("Chi square dof=3",n,diff1,diff2,diff3,diff4))
			break
		end
	end
end

# ╔═╡ 15d95429-5d75-4481-8949-bbe0e42ba1f9
df1

# ╔═╡ Cell order:
# ╠═384be000-a577-11eb-24a0-a59dcf2ff179
# ╠═fc3ef603-a296-44be-9bc0-60ed1a8ba4f4
# ╠═e301509c-f7b9-4f31-a8a4-0206404651af
# ╠═80d7056d-8988-44a7-97fd-b2eff933a1f2
# ╠═a199903d-c7f8-444a-ad17-834a53db1f51
# ╠═f52a7251-a351-47b6-90ca-f8f2da98b178
# ╟─26ef9627-7086-49df-9205-f3703153e049
# ╟─c771182c-df8c-4f94-9462-0a9b3f85cfe3
# ╠═8fd0b758-678b-4dc5-834e-30f0f46ec530
# ╠═acd543e6-a5a2-4197-bdff-d79425880375
# ╟─447d57ac-21e9-4790-bd6a-8b07c5a7e558
# ╠═ec703d06-7505-4801-9874-3b7605316d4c
# ╠═a4df2eb0-cf79-43ef-be50-f479abc59b9f
# ╟─0440731f-3b8d-44e1-b717-3fb4c4b4eaa0
# ╠═0f67c7ac-1009-49b1-83de-4c88f4ac6076
# ╠═7bb7656d-1771-489b-a660-6eaa1608e6dc
# ╠═6e91a900-a038-4b3b-ab88-13537ef3d473
# ╠═35c44cd9-aeac-40f7-b343-0cf526fb85c6
# ╠═828c0e33-963c-4ece-8455-303a90c48d8f
# ╠═f243fbf2-ee2e-4d24-9289-e4393bea7372
# ╟─aaeac52f-3a49-4bd3-b33c-326b8319b1f4
# ╠═2b92a3ad-3c0c-4b4a-b53f-1cd020397000
# ╠═b46ddae8-52aa-4543-9dd6-59f9bdc7c96c
# ╠═2a62b87c-cdac-4343-be16-f646a9893413
# ╠═bbb49120-0901-45e3-894b-61c1648f11d7
# ╠═45dd2fcf-b6b5-46fc-ad83-ea9dd9f78b0f
# ╟─dd22d3ba-ec1c-4ec6-89db-d91037dca299
# ╠═65cedc1d-786a-4032-b65e-266e1eedc22f
# ╠═1c36d859-f29d-4277-a722-8e8db4817d24
# ╠═62f5e4c5-0567-4862-97ec-bac9ac230b00
# ╠═3fda2060-1f4e-470f-8075-4375917e1218
# ╟─3e7749b0-d464-4bb6-801d-884732f7367f
# ╠═32825131-599e-438a-b8b4-f022e63cc0fe
# ╠═36bb82ac-414e-461a-a3e1-14ebe1990992
# ╟─acdc3c06-5c10-4467-b618-ee7de7cf8859
# ╠═80947529-12b6-44de-8109-e21ff6ca3b57
# ╠═a25a2560-b6f3-472d-9672-54b30abc9dbb
# ╟─b7f724dc-086b-4ac7-a5d4-8426c9dc9b9f
# ╠═ce236f4e-9948-4f3f-b758-8aec3e8d5474
# ╟─07dbfaea-30fd-44c6-8f44-023a6baceed2
# ╠═b1148394-5255-42bc-a9f2-3ebb94cb500b
# ╟─ec5e140d-a430-4371-9e3e-5c9bb84bb30c
# ╠═2fe5297e-f5d5-4f00-b76d-32ebaeff9119
# ╠═15d95429-5d75-4481-8949-bbe0e42ba1f9
