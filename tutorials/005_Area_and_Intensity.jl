### A JIVEbook.jl notebook ###
# v0.0.2

using Markdown
using InteractiveUtils
using JIVECore
using PlutoPlotly, PlutoUI
import Main.PlutoRunner.JIVECore.Data.image_data as image_data
import Main.PlutoRunner.JIVECore.Data.image_keys as image_keys

# ╔═╡ ea391bf4-4fa1-4759-8fe0-06c12c6a9de6
JIVECore.Visualize.jive_theme()

# ╔═╡ 87d2020e-c20a-4489-b826-b444dfc3afae
img_path = "/Users/yi/JIVE/Demo Images/Widefield Images/Fluorescence Measurment/Fluoro 01.tif"
JIVECore.Files.showInfo(img_path)

# ╔═╡ 3508a7ee-69d7-48f5-abc9-3e7375ae1c98
img = JIVECore.Files.loadImage(img_path);

# ╔═╡ 129e9223-e760-42b4-88a1-5bb5a0dd22c6
JIVECore.Files.showInfo(img)

# ╔═╡ ea64ddc7-273e-4914-9570-025d5edea6a6
img

# ╔═╡ 26a005dc-7ae6-41ed-b3ca-78f3b6a3ca16
R,G,B = JIVECore.Data.im2separate(img)
JIVECore.Visualize.mosaicview(R, G, B, nrow=1)

# ╔═╡ ded538ba-9944-4edb-aca4-1e0c34224211
using Unitful
RR = JIVECore.Data.im2axis(R, :x,:y)
RR = JIVECore.Data.imCalibrate(RR, x=.1u"mm",y=1u"mm");

# ╔═╡ cef37598-7ccf-46f6-baff-2e7e5edd5f6a
JIVECore.Process.imHistogram(R, true, normalize=true)

# ╔═╡ f36ee379-7b86-47d0-9a08-c00a819ac275
R2 = JIVECore.Process.im2BW(R)

# ╔═╡ a5ff87ed-ebaa-4357-b171-55467cb3a267
D = JIVECore.Analyze.stats_table(RR)

# ╔═╡ 9a06395b-9671-49ef-a18c-6929ae08a6d5
D = JIVECore.Analyze.stats_table(RR, threshold="auto", df=D)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
Unitful = "~1.27.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "17429589116d695bb88fd87d339679b35d67f75e"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c25751629f5baaa27fef307f96536db62e1d754e"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.27.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    ForwardDiffExt = "ForwardDiff"
    InverseFunctionsUnitfulExt = "InverseFunctions"
    LatexifyExt = ["Latexify", "LaTeXStrings"]
    NaNMathExt = "NaNMath"
    PrintfExt = "Printf"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"
    LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
    Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
    NaNMath = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
    Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"
"""

# ╔═╡ Cell order:
# ╠═ea391bf4-4fa1-4759-8fe0-06c12c6a9de6
# ╠═87d2020e-c20a-4489-b826-b444dfc3afae
# ╠═3508a7ee-69d7-48f5-abc9-3e7375ae1c98
# ╠═129e9223-e760-42b4-88a1-5bb5a0dd22c6
# ╠═ea64ddc7-273e-4914-9570-025d5edea6a6
# ╠═26a005dc-7ae6-41ed-b3ca-78f3b6a3ca16
# ╠═cef37598-7ccf-46f6-baff-2e7e5edd5f6a
# ╠═f36ee379-7b86-47d0-9a08-c00a819ac275
# ╠═ded538ba-9944-4edb-aca4-1e0c34224211
# ╠═a5ff87ed-ebaa-4357-b171-55467cb3a267
# ╠═9a06395b-9671-49ef-a18c-6929ae08a6d5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
