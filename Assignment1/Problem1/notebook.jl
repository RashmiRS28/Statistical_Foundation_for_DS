### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 02ff26d0-73ab-11eb-00d1-b30167641d0b
begin
	using Plots
	pyplot()
end

# ╔═╡ 2c316a90-73ab-11eb-0b2a-e12b163b23f4
using Random

# ╔═╡ f7097a80-743e-11eb-3dbf-718d449c0343
md"# Q1. Law of Large Numbers"

# ╔═╡ 2c2d9a00-73ab-11eb-1d38-bb122c1a9283
n_slider = @bind n_samples html"<input type=range min=100 max=1000 step=100>"

# ╔═╡ 2c220140-73ab-11eb-399f-73cf010dbac9
n_samples

# ╔═╡ 3e03f260-73ab-11eb-3be9-3591e1aa047c
function LLN(n_samples)
	Random.seed!(0)
	return sum([rand(Int) for _ in 1:n_samples])/n_samples
end

# ╔═╡ 479e7160-73ab-11eb-2c8a-8b1a22bd3792
Mval=[LLN(r) for r in 1:n_samples]

# ╔═╡ 4d7d47f0-73ab-11eb-05bc-fd200ec3ed8f
plot(1:n_samples,Mval)

# ╔═╡ Cell order:
# ╠═f7097a80-743e-11eb-3dbf-718d449c0343
# ╠═02ff26d0-73ab-11eb-00d1-b30167641d0b
# ╠═2c316a90-73ab-11eb-0b2a-e12b163b23f4
# ╠═2c2d9a00-73ab-11eb-1d38-bb122c1a9283
# ╠═2c220140-73ab-11eb-399f-73cf010dbac9
# ╠═3e03f260-73ab-11eb-3be9-3591e1aa047c
# ╠═479e7160-73ab-11eb-2c8a-8b1a22bd3792
# ╠═4d7d47f0-73ab-11eb-05bc-fd200ec3ed8f
