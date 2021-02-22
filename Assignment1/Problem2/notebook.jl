### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 5bd66130-743f-11eb-17e5-454cb7906819
using DataFrames

# ╔═╡ 5ecf7c32-73ab-11eb-390a-b74fa9ef1a08
using Random

# ╔═╡ 2a0ae1d0-743f-11eb-373e-358f9efd2266
md"# Q2. Deck of playing cards"

# ╔═╡ 3b21bac0-743f-11eb-039a-cfe857684b7a
md" **Q2.(a) Without Replacement**"

# ╔═╡ 67873c50-73ab-11eb-07ac-872568559253
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
	

# ╔═╡ 8ce2ae80-73ab-11eb-13a5-6b47ebf1248f
begin
	jackWR=zeros(4)
	for k in 1:4
		jackWR[k]=sum([pickjackNR(5,k) for _ in 1:10000])/10000
	end
	v=DataFrame(jacks=1:4, Probability=jackWR)
end

# ╔═╡ 5ec65470-73ab-11eb-2974-8f0d688f7a41
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

# ╔═╡ 83ba2b30-73ab-11eb-34e2-4fa9a61f32cb
begin
	jackR=zeros(5)
	for h in 1:5
		jackR[h]=sum([pickjackR(5,h) for i in 1:100000])/100000
	end
	vi=DataFrame(jacks=1:5, Probability=jackR)
end

# ╔═╡ Cell order:
# ╟─2a0ae1d0-743f-11eb-373e-358f9efd2266
# ╠═5bd66130-743f-11eb-17e5-454cb7906819
# ╠═5ecf7c32-73ab-11eb-390a-b74fa9ef1a08
# ╟─3b21bac0-743f-11eb-039a-cfe857684b7a
# ╠═67873c50-73ab-11eb-07ac-872568559253
# ╠═8ce2ae80-73ab-11eb-13a5-6b47ebf1248f
# ╠═5ec65470-73ab-11eb-2974-8f0d688f7a41
# ╠═83ba2b30-73ab-11eb-34e2-4fa9a61f32cb
