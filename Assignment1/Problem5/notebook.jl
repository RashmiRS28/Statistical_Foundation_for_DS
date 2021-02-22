### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ bc596110-73ae-11eb-1d99-9d4126f9e10f
using Random

# ╔═╡ cd2783e0-7440-11eb-31b8-55ef451fafcf
md"# Q.5 Cybersecurity- Modified Constraints"

# ╔═╡ ae587ab0-73ae-11eb-1eca-cd45dbf79df6
begin
	Random.seed!(0)
password=randstring(['A':'Z';'0':'9';'a':'z';'~';'!';'@';'#';'$';'%';'^';'&';'*';'(';')';'_';'+';'=';'-';'`'],8)

end

# ╔═╡ c0e3f240-73ae-11eb-1305-8d1a60acfe37
function checknp(N)
	c=0
	t=0
	for i in 1:N
		m=-1
		c=0
	    p=randstring(['A':'Z';'0':'9';'a':'z';'~';'!';'@';'#';'$';'%';'^';'&';
				'*';'(';')';'_';'+';'=';'-';'`'],8)
		for i in 1:8
			if p[i]==password[i]
				if m==-1
					m=i
					c+=1
				elseif m==i+1 || m==i-1 #Only counting if the new matched character                                             is adjacent to previos matched character
						c+=1
						c+=1
						m=i
					end
				
			end
		end
		if c>=2
			t+=1
		end
	end
	return t/N
end

# ╔═╡ cbf97880-73ae-11eb-2800-fb9f461809f3
newstored=checknp(1000000)#New Probability of random trial getting stored in database

# ╔═╡ Cell order:
# ╠═cd2783e0-7440-11eb-31b8-55ef451fafcf
# ╠═bc596110-73ae-11eb-1d99-9d4126f9e10f
# ╠═ae587ab0-73ae-11eb-1eca-cd45dbf79df6
# ╠═c0e3f240-73ae-11eb-1305-8d1a60acfe37
# ╠═cbf97880-73ae-11eb-2800-fb9f461809f3
