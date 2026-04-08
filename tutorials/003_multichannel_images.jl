### A JIVEbook.jl notebook ###
# v0.0.2

using Markdown
using InteractiveUtils
using JIVECore
using PlutoPlotly, PlutoUI
import Main.PlutoRunner.JIVECore.Data.image_data as image_data
import Main.PlutoRunner.JIVECore.Data.image_keys as image_keys

# ╔═╡ 28edfd72-e57d-4355-9cf2-a9a99c5b754f
img = JIVECore.Files.loadImage("/Users/yi/JIVE/Demo Images/Widefield Images/DIC and Fluorescent/FITC.tif");

# ╔═╡ dd38ffc8-bb70-4b44-aab3-259f338f34b9
JIVECore.Files.showInfo(img)

# ╔═╡ c25cdceb-ed28-4caa-8566-25ed0aa5556c
img2 = JIVECore.Data.im2bit(img)

# ╔═╡ 51ab7c42-3810-41f8-b102-da586f807ed5
JIVECore.Files.showInfo(img2)

# ╔═╡ f448376c-b486-4fef-bcf7-4e0093ab2aad
img_lut = JIVECore.Data.gray2lut(img2, :nuuk, metadata=true)

# ╔═╡ 3579eda4-2715-4565-965f-2fb335220592
JIVECore.Files.showInfo(img_lut)

# ╔═╡ 401bbc69-eca3-4db2-9f98-93d1d04546c4
JIVECore.Draw.colorbar!(img_lut, corner=:topleft, fontsize=0.03, scheme=:nuuk)

# ╔═╡ a8d1c8e8-ccec-42f0-9500-ad2dc23de3d0
fitc = JIVECore.Files.loadImage("/Users/yi/JIVE/Demo Images/Widefield Images/DIC and Fluorescent/FITC.tif");
dapi = JIVECore.Files.loadImage("/Users/yi/JIVE/Demo Images/Widefield Images/DIC and Fluorescent/DAPI.tif");
dic = JIVECore.Files.loadImage("/Users/yi/JIVE/Demo Images/Widefield Images/DIC and Fluorescent/DIC.tif");

# ╔═╡ 0882a3c0-83e7-4b1c-84a0-232cc5b0de06
fitc2 = JIVECore.Data.im2rgb(fitc, :r);
dapi2 = JIVECore.Data.im2rgb(dapi, :b);
dic2 = JIVECore.Data.im2rgb(dic);

# ╔═╡ b63eae3d-381c-404f-9dfc-85f894cb4d77
JIVECore.Data.im2rgb(fitc, dapi, dic; channels=[:r, :g, :b])

# ╔═╡ Cell order:
# ╠═28edfd72-e57d-4355-9cf2-a9a99c5b754f
# ╠═dd38ffc8-bb70-4b44-aab3-259f338f34b9
# ╠═c25cdceb-ed28-4caa-8566-25ed0aa5556c
# ╠═51ab7c42-3810-41f8-b102-da586f807ed5
# ╠═f448376c-b486-4fef-bcf7-4e0093ab2aad
# ╠═3579eda4-2715-4565-965f-2fb335220592
# ╠═401bbc69-eca3-4db2-9f98-93d1d04546c4
# ╠═a8d1c8e8-ccec-42f0-9500-ad2dc23de3d0
# ╠═0882a3c0-83e7-4b1c-84a0-232cc5b0de06
# ╠═b63eae3d-381c-404f-9dfc-85f894cb4d77
