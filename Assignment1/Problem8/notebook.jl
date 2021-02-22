### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 7363c75e-7440-11eb-24ae-1910296f0114
using DataFrames

# ╔═╡ ffdcf7e0-73ad-11eb-268f-5d23e2c992d9
begin
	using Random
	using Distributions
end

# ╔═╡ 70a2f9b0-7440-11eb-3273-9f2a20482f86
md"# Q8. Investment with no Bankrupcy"

# ╔═╡ ffcc07f0-73ad-11eb-2a5b-050b1c070617
function Crich(N,p)
	d=Bernoulli(p)
	c=0
	v=0
	for _ in 1:N
		amount=10
		f=0
		for k in 1:20
			u=rand(d)
			if u==true
				amount=amount-1
			else
				amount=amount+1
			end
			
			if amount<=0
				f=1
		    end
		end
		if amount>=10
			v+=1
		end
			if f==0#not going bankrupt on any day
				c+=1
			end
		end
		return v/c
	end

# ╔═╡ 395a8732-73ae-11eb-143d-1d8648bc0b49
begin
	j=[Crich(1000000,n) for n in 0:0.1:0.9]
	f3=DataFrame(ValuesOfp=0:0.1:0.9, Probability=j)
end

# ╔═╡ Cell order:
# ╟─70a2f9b0-7440-11eb-3273-9f2a20482f86
# ╠═7363c75e-7440-11eb-24ae-1910296f0114
# ╠═ffdcf7e0-73ad-11eb-268f-5d23e2c992d9
# ╠═ffcc07f0-73ad-11eb-2a5b-050b1c070617
# ╠═395a8732-73ae-11eb-143d-1d8648bc0b49
