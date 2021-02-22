### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ c83ee9a0-743f-11eb-1861-377bd8b6185a
using DataFrames

# ╔═╡ f89e7c30-73ab-11eb-0252-09cb9e8303a9
begin
	using Plots
	pyplot()
end

# ╔═╡ d9035f40-73af-11eb-0717-c70481233191
using Random

# ╔═╡ 0536d2a0-7440-11eb-3eff-bb395cf18103
md"# Previous info of Q2 needed for Q3 solution below"

# ╔═╡ 124c6de0-73ac-11eb-19a2-0901e5064c42
function pickjackR(n,j)
	count=0
	np=zeros(5)
	pack=collect(1:52)	#n is picking card ntimes
		
		for exp in 1:n
		
			card=rand(pack)  #A card picked
			for v in 49:52     #checking if picked card is a jack
				if card==v
					count+=1
				end
			end
	    end
	if count==j
		return 1
	else 
		return 0
	end
end

# ╔═╡ 10bbbbc0-73ac-11eb-2071-bd8aebb34af9
begin
	jackR=zeros(5)
	for h in 1:5
		jackR[h]=sum([pickjackR(5,h) for i in 1:100000])/100000
	end
	jackR
end

# ╔═╡ 30fba760-73ac-11eb-14f6-1f4225d312e4
function pickjackNR(n,j)
	
	count=0
	p=0	
	pack1=collect(1:52)
	packc=copy(pack1)	#n is picking card ntimes
		
	for exp in 1:n
		card=rand(packc)  #A card picked
		for v in 1:4     #checking if picked card is a jack
			if card==v
				count+=1
			end
			
	    end
		deleteat!(packc,findfirst(x->x==card,packc))
	end
		
	if count==j
		return 1
	else 
		return 0
	end
end
	

# ╔═╡ 367db7f0-73ac-11eb-21ff-43a18eb65e1d
begin
	jackWR=zeros(4)
	for k in 1:4
		jackWR[k]=sum([pickjackNR(5,k) for _ in 1:10000])/10000
	end
	jackWR
end

# ╔═╡ a35af160-743f-11eb-01da-8f05aee62a93
md"# Q3.Pack of cards-Theoretical Approach"

# ╔═╡ 97c58cc0-743f-11eb-0ba8-435aac8757d1
md" **Q3.(a) Without Replacement- Follows HYPERGEOMETRIC distribution**"

# ╔═╡ 768774d0-73ac-11eb-1435-e1408b271e5d
function withoutR(j)
	i=5-j
	return((binomial(48,i)*binomial(4,j))/binomial(52,5))
end

# ╔═╡ 7bd7ee10-73ac-11eb-2545-b7e368129e04
begin
	jackgeo=zeros(4)
	for a in 1:4
		jackgeo[a]=withoutR(a)
	end
	vie=DataFrame(jacks=1:4, Probability=jackgeo)
end

# ╔═╡ bc5aa1b0-743f-11eb-0d55-f57a8c2fe25a
md" **Q3.(b) With Replacement- Follows BINOMIAL distribution**"

# ╔═╡ 3b3fd3e0-73ac-11eb-10b5-c7e832f05c61
function withR(j)
	p=4/52
	return (binomial(5,j)*p^j*(1-p)^(5-j))
end

# ╔═╡ 5abf7cc0-73ac-11eb-00a5-b3522693cc0a
begin
	jackbino=zeros(5)
	for x in 1:5
		jackbino[x]=withR(x)
	end
	view=DataFrame(jacks=1:5, Probability=jackbino)
end

# ╔═╡ e407f322-743f-11eb-134a-c7393317e8e5
md" **ERROR CALCULATION WHEN COMPARING experimental and theoretical results**"

# ╔═╡ 832fd00e-73ac-11eb-07cd-5dfb58274525
begin
	e=zeros(5)
	for op in 1:5
		e[op]=abs(jackR[op]-jackbino[op])*10^3; #Calculating absolute error
	end
	scatter(1:5,e, ylabel="Absolute error (10^(-3))",xlabel="Number of jacks present in 5 picked cards (With Replacement case)",legend=false)
end

# ╔═╡ 8b888040-73ac-11eb-39de-f3438f99484c
begin
	enr=zeros(4)
	for opp in 1:4
		enr[opp]=abs(jackWR[opp]-jackgeo[opp])*10^(2);
	end
	scatter(1:4,enr,ylabel="Absolute error (10^(-2))",xlabel="Number of jacks present in 5 picked cards (Without Replacement case)", legend=false)
end

# ╔═╡ Cell order:
# ╠═0536d2a0-7440-11eb-3eff-bb395cf18103
# ╠═c83ee9a0-743f-11eb-1861-377bd8b6185a
# ╠═f89e7c30-73ab-11eb-0252-09cb9e8303a9
# ╠═d9035f40-73af-11eb-0717-c70481233191
# ╠═124c6de0-73ac-11eb-19a2-0901e5064c42
# ╠═10bbbbc0-73ac-11eb-2071-bd8aebb34af9
# ╠═30fba760-73ac-11eb-14f6-1f4225d312e4
# ╠═367db7f0-73ac-11eb-21ff-43a18eb65e1d
# ╠═a35af160-743f-11eb-01da-8f05aee62a93
# ╠═97c58cc0-743f-11eb-0ba8-435aac8757d1
# ╠═768774d0-73ac-11eb-1435-e1408b271e5d
# ╠═7bd7ee10-73ac-11eb-2545-b7e368129e04
# ╠═bc5aa1b0-743f-11eb-0d55-f57a8c2fe25a
# ╠═3b3fd3e0-73ac-11eb-10b5-c7e832f05c61
# ╠═5abf7cc0-73ac-11eb-00a5-b3522693cc0a
# ╠═e407f322-743f-11eb-134a-c7393317e8e5
# ╠═832fd00e-73ac-11eb-07cd-5dfb58274525
# ╠═8b888040-73ac-11eb-39de-f3438f99484c
