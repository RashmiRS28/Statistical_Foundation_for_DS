### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 6169e170-7440-11eb-3071-f5f235f6fcc4
using DataFrames

# ╔═╡ 365fda40-73ad-11eb-247e-67a671278ce9
using Random

# ╔═╡ aae7b360-73ad-11eb-2822-adc5c58066cb
using Distributions

# ╔═╡ 567a32b0-7440-11eb-201d-873a7ad87675
md"# Q.7 Going Bankrupt"

# ╔═╡ 5d528e40-73ad-11eb-2f84-f71ec3478c07
function bankr(N,p)
	d=Bernoulli(p)
	c=0
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
			if f==0 #not going bankrupt on any day
				c+=1
			end
		end
		return 1-c/N
	end

# ╔═╡ 5d415030-73ad-11eb-1e4e-4f5cd43b2e1e
begin
	val=[bankr(100000,y) for y in 0:0.1:0.9]
	f2=DataFrame(ValuesOfp=0:0.1:0.9, Probability=val)
end

# ╔═╡ 7349e090-73ad-11eb-1566-d1b1db6fc7f6


# ╔═╡ Cell order:
# ╠═567a32b0-7440-11eb-201d-873a7ad87675
# ╠═6169e170-7440-11eb-3071-f5f235f6fcc4
# ╠═365fda40-73ad-11eb-247e-67a671278ce9
# ╠═aae7b360-73ad-11eb-2822-adc5c58066cb
# ╠═5d528e40-73ad-11eb-2f84-f71ec3478c07
# ╠═5d415030-73ad-11eb-1e4e-4f5cd43b2e1e
# ╠═7349e090-73ad-11eb-1566-d1b1db6fc7f6
