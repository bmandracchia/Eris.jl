### A JIVEbook.jl notebook ###
# v0.0.2

using Markdown
using InteractiveUtils
using JIVECore
using PlutoPlotly, PlutoUI
import Main.PlutoRunner.JIVECore.Data.image_data as image_data
import Main.PlutoRunner.JIVECore.Data.image_keys as image_keys

# ╔═╡ 24aeb312-f260-427f-9597-fc290a384b7e
JIVECore.Files.showInfo("/Users/yi/JIVE/Demo Images/Confocal/LeGO Stack.tif")

# ╔═╡ 5ef7fcab-8d18-4f97-bd02-c5fe39814a93
img = JIVECore.Files.loadImage("/Users/yi/JIVE/Demo Images/Confocal/LeGO Stack.tif");

# ╔═╡ 04130657-8dd1-4bb0-9e52-a0044f5b2dae
JIVECore.Files.showInfo(img)

# ╔═╡ 1b66ee6d-cfdf-40cb-9e0b-6e3c59f7fb0e
JIVECore.Process.autoContrast(JIVECore.Data.im2rgb(JIVECore.Data.imProject(img, 3)))

# ╔═╡ 65161f6a-14a3-4e2f-824b-9f7006fad39d
JIVECore.Process.autoContrast(JIVECore.Data.im2rgb(JIVECore.Data.imProject(img, 2)))

# ╔═╡ 7e80090f-cf49-4e1a-a790-e447eec39250
JIVECore.Process.autoContrast(JIVECore.Data.im2rgb(JIVECore.Data.imProject(img, 1)))

# ╔═╡ cd51ad2e-fde3-477e-b442-175176a44c26
img2 = JIVECore.Data.im2axis(img, :x, :y, :z, :c);

# ╔═╡ 98575285-77da-4142-b306-d03129613f40
JIVECore.Process.autoContrast(JIVECore.Data.im2rgb(JIVECore.Data.imProject(img2, :z).data))

# ╔═╡ e76ac8c7-3466-4af2-a683-1f7c13c14e5a
track = JIVECore.Files.loadImage("/Users/yi/JIVE/Demo Images/Confocal/Tracking.tif");

# ╔═╡ c0e3a6a5-6516-42e6-adbc-33250b46d4ec
track2 = JIVECore.Data.im2axis(track, :x, :y, :time, :c);
JIVECore.Process.autoContrast(track2[time=1, c=1])

# ╔═╡ dcdc6961-8962-41c4-8441-e233844b0134
JIVECore.Process.autoContrast(JIVECore.Data.im2rgb(JIVECore.Data.imProject(track2, :x, method=:mean).data, channels=[:r, :c]))

# ╔═╡ d188c381-e4d5-40c5-9f09-54bb62b3f03a
track_avg = JIVECore.Data.imProject(track2, :time, method=:mean);
JIVECore.Process.autoContrast(track_avg[c=1])

# ╔═╡ 58514a11-c110-4c78-8f50-0e3da6edfd16
track3_ch1 = JIVECore.Data.imCalculate(track2[c=1], track_avg[c=1], -, remove_negatives=true);
# track3_ch2 = track2[c=2] .- track_avg[:,:,2]
JIVECore.Process.autoContrast(track3_ch1[:,:,1])

# ╔═╡ 25316aaf-33df-4beb-9c24-9bd5a5ef0e7d
JIVECore.Process.autoContrast(JIVECore.Data.imProject(track2[c=1], :x, method=:mean))

# ╔═╡ b9b218d2-d12d-4ad4-9871-0a9bb5b4b78a
JIVECore.Process.autoContrast((JIVECore.Data.imProject(track3_ch1, 1)))

# ╔═╡ 350d3b0b-34ff-48b0-978c-cb2b2096ea19
JIVECore.Process.autoContrast(JIVECore.Data.imTimeColor(track[:,:,:,1]))

# ╔═╡ d88a33e9-a281-4690-844f-50c733ce290a
JIVECore.Draw.show_color_scheme(:batlowW)

# ╔═╡ fcd2f98b-670c-4835-bcaf-1bbbf9493fa7
# JIVECore.Files.saveVideo(img2[c=1])

# ╔═╡ 80dcf140-7862-47a5-bd24-44698fa289e7
JIVECore.Files.saveVideo("a.avi",track3_ch1)

# ╔═╡ Cell order:
# ╠═24aeb312-f260-427f-9597-fc290a384b7e
# ╠═5ef7fcab-8d18-4f97-bd02-c5fe39814a93
# ╠═04130657-8dd1-4bb0-9e52-a0044f5b2dae
# ╠═1b66ee6d-cfdf-40cb-9e0b-6e3c59f7fb0e
# ╠═65161f6a-14a3-4e2f-824b-9f7006fad39d
# ╠═7e80090f-cf49-4e1a-a790-e447eec39250
# ╠═cd51ad2e-fde3-477e-b442-175176a44c26
# ╠═98575285-77da-4142-b306-d03129613f40
# ╠═e76ac8c7-3466-4af2-a683-1f7c13c14e5a
# ╠═c0e3a6a5-6516-42e6-adbc-33250b46d4ec
# ╠═dcdc6961-8962-41c4-8441-e233844b0134
# ╠═d188c381-e4d5-40c5-9f09-54bb62b3f03a
# ╠═58514a11-c110-4c78-8f50-0e3da6edfd16
# ╠═25316aaf-33df-4beb-9c24-9bd5a5ef0e7d
# ╠═b9b218d2-d12d-4ad4-9871-0a9bb5b4b78a
# ╠═350d3b0b-34ff-48b0-978c-cb2b2096ea19
# ╠═d88a33e9-a281-4690-844f-50c733ce290a
# ╠═fcd2f98b-670c-4835-bcaf-1bbbf9493fa7
# ╠═80dcf140-7862-47a5-bd24-44698fa289e7
