### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 8a6e72ce-73ae-11eb-2ab5-8bf41491aafc
using Random

# ╔═╡ aa306780-7440-11eb-3bbf-5bb387497923
md"# Q.4 Cybersecurity"

# ╔═╡ a1a8df20-7440-11eb-2759-e74d5e2abef1
md"**Q.4(a)**"

# ╔═╡ b1aee450-7440-11eb-3996-03b16382ac85
md" **Theoretically calculating probability- solved in google doc**"

# ╔═╡ bb203070-7440-11eb-0510-4169deb75650
md"**Q.4(b)**"

# ╔═╡ 999a92c0-73ae-11eb-0b5d-197720f4716a
password=randstring(['A':'Z';'0':'9';'a':'z';'~';'!';'@';'#';'$';'%';'^';'&';'*';'(';')';'_';'+';'=';'-';'`'],8)

# ╔═╡ 9f1a8070-73ae-11eb-1d96-17f1e8ed92aa
function checkp(N)
	c=0
	t=0
	for i in 1:N
		c=0
	    p=randstring(['A':'Z';'0':'9';'a':'z';'~';'!';'@';'#';'$';'%';'^';'&';
				'*';'(';')';'_';'+';'=';'-';'`'],8)
		for i in 1:8
			if p[i]==password[i]
				c+=1
			end
		end
		if c==0 || c==1
			t+=1
		end
	end
	return 1-t/N
end

# ╔═╡ a9a63d3e-73ae-11eb-2c4e-7f94ecc169d1
storedp=checkp(1000000)

# ╔═╡ Cell order:
# ╟─aa306780-7440-11eb-3bbf-5bb387497923
# ╠═8a6e72ce-73ae-11eb-2ab5-8bf41491aafc
# ╟─a1a8df20-7440-11eb-2759-e74d5e2abef1
# ╟─b1aee450-7440-11eb-3996-03b16382ac85
# ╟─bb203070-7440-11eb-0510-4169deb75650
# ╠═999a92c0-73ae-11eb-0b5d-197720f4716a
# ╠═9f1a8070-73ae-11eb-1d96-17f1e8ed92aa
# ╠═a9a63d3e-73ae-11eb-2c4e-7f94ecc169d1
