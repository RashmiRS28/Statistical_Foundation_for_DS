### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 39ef86e0-7440-11eb-3ef7-bf0da516836e
using DataFrames

# ╔═╡ 8f90f3b0-73ad-11eb-20dd-873610ea44d7
begin 
	using Random
	using Distributions
end

# ╔═╡ 4a736e9e-7440-11eb-2984-c309e2f1ef05
using LaTeXStrings

# ╔═╡ 2c8f7462-7440-11eb-3b95-37a67209fa05
md"# Q.6 Investment"

# ╔═╡ c570c2d0-73ad-11eb-0a52-8d6f9a335e64
function rich(N,p)
	d=Bernoulli(p)
	c=0
	for _ in 1:N
		amount=10
		for k in 1:20
			u=rand(d)
			if u==true
				amount=amount-1
			else
				amount+=1
			end
		end
		if amount>=10
			c+=1
		end
	end
	return c/N
			
end

# ╔═╡ deaa47d0-73ad-11eb-3f5e-4f2439f32a5c
begin
	p=[rich(1000000,i) for i in 0:0.1:0.9]
	f=DataFrame(ValuesOfp=0:0.1:0.9, Probability=p)
end

# ╔═╡ f8c36f10-7408-11eb-0aee-3fe591015d0f
md"# _Bonus Question Solution_"

# ╔═╡ 4ac2f002-7405-11eb-1a2b-5325d876374a

	md" We know that for person to have rupees 10 or more at the end of twenty days, 
he needs to win atleast as many games as he loses, or more

Using binomial ditribution, where success(r) is winning with a probability of (1-p), we get values of r as:" 

# ╔═╡ 0c512650-7407-11eb-1772-451d8867a483
L"10\leqslant r \leqslant20"


# ╔═╡ 1c2cc020-7407-11eb-22bf-0b6350dad227
md"Probablity that rupees>=10 at the end of 20 days ="

# ╔═╡ 414a17e2-7407-11eb-0890-55a07cd01cc9
L"\Sigma{ \binom{20}{r} * (1-p)^r *  (p)^{(20-r)} }"

# ╔═╡ Cell order:
# ╟─2c8f7462-7440-11eb-3b95-37a67209fa05
# ╠═39ef86e0-7440-11eb-3ef7-bf0da516836e
# ╠═8f90f3b0-73ad-11eb-20dd-873610ea44d7
# ╠═c570c2d0-73ad-11eb-0a52-8d6f9a335e64
# ╠═deaa47d0-73ad-11eb-3f5e-4f2439f32a5c
# ╠═4a736e9e-7440-11eb-2984-c309e2f1ef05
# ╟─f8c36f10-7408-11eb-0aee-3fe591015d0f
# ╟─4ac2f002-7405-11eb-1a2b-5325d876374a
# ╟─0c512650-7407-11eb-1772-451d8867a483
# ╟─1c2cc020-7407-11eb-22bf-0b6350dad227
# ╟─414a17e2-7407-11eb-0890-55a07cd01cc9
