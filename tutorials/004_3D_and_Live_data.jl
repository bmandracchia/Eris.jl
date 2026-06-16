### A JIVEbook.jl notebook ###
# v0.0.2

using Markdown
using InteractiveUtils
using JIVECore
using PlutoPlotly, PlutoUI
import Main.PlutoRunner.JIVECore.Data.image_data as image_data
import Main.PlutoRunner.JIVECore.Data.image_keys as image_keys

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ adb575a6-d444-47e8-9b68-dad4a2d3e73a
md"""
##### Load Image
$(@bind tmp1776330265046 PlutoUI.FilePicker())
"""


# ╔═╡ 98698242-f26e-4d25-81c1-408488424e91

            loaded_index1776330265046 = isnothing(tmp1776330265046) ? nothing :
                JIVECore.Files.loadImage!(image_data, image_keys, tmp1776330265046)
                nothing
            


# ╔═╡ 4c9af6d4-f530-4698-b80e-3684d5196ab6
md"""
##### $(@bind show_image1776330265046 PlutoUI.CheckBox()) Show image

"""


# ╔═╡ d452c560-15f5-4c9b-91ac-9d38f4b027e2

            if show_image1776330265046 && !isnothing(loaded_index1776330265046)
    
                JIVECore.Visualize.gif(
                    JIVECore.Process.autoContrast(image_data[loaded_index1776330265046])
                )
    
            end
            


# ╔═╡ 881e0530-bbd1-40e0-9cc6-5a12e1b86995
md"""
##### $(@bind show_info1776330265046 PlutoUI.CheckBox()) Show image info

"""


# ╔═╡ b03f8eec-a25c-4b2e-8d03-6880e9e0e7d4

            if show_info1776330265046 && !isnothing(loaded_index1776330265046)
                JIVECore.Files.showInfo(image_data[loaded_index1776330265046])
            end
            


# ╔═╡ ad1e2587-635f-4a06-afa0-cadd377b3299
md"""
##### Maximum Intensity Projection (ND Images)

Select image:
$(@bind proj_im1776330429598 Select([nothing, image_keys...]))
            
Method:
$(@bind proj_method1776330429598 Select([:max, :mean, :sum, :std, :median], default=:max))
                
"""


# ╔═╡ 5ab265ec-f56b-4322-b953-11d0849a3382


                dims = if isnothing(proj_im1776330429598)
                    [1,2,3]
                else
                    current_img = image_data[proj_im1776330429598]
                    current_img isa JIVECore.Data.AxisArray ?
                        collect(JIVECore.Data.axisnames(current_img)) :
                        collect(1:ndims(current_img))
                end
                
                md"""
                Projection dimension:
                $(@bind proj_dim1776330429598 Select(dims))
                """
                
                


# ╔═╡ 496b1991-2902-4cfc-b1d7-9e9d544e1663
md"""
# 🌄 Maximum Intensity Projection

This section allows you to **compute a Maximum Intensity Projection (MIP)** from an ND image along a selected dimension.

**Steps to use it:**

1. **Select the image**  
   Choose the image you want to project:
   $(@bind proj_im Select([nothing, image_keys...]))

2. **Select projection method**  
   Choose how pixel values are combined during projection:
   $(@bind proj_method Select([:max, :mean, :sum, :std, :median], default=:max))

3. **Select projection dimension**  
   After selecting the image, choose the dimension along which the projection is computed:
   $(@bind proj_dim Select(dims))

4. **Generate projection**  
   The system computes the projection and stores it as a new image in `image_data`.

   The resulting image is automatically saved with a name like:
   `original_name_proj_max` (or the selected method).

> 💡 Tip: Use `:max` for bright structures, and `:mean` for smoother overall intensity visualization.
"""

# ╔═╡ 4e5c12f7-fc15-4e7e-9837-82b0e31367a0

        
        proj_key1776330429598 = nothing
        let
        if !isnothing(proj_im1776330429598) && !isnothing(proj_dim1776330429598)
        
            img = image_data[proj_im1776330429598]
        
            # 1 Projection (Symbol version)
            projected = JIVECore.Data.imProject(
                img,
                proj_dim1776330429598;
                method=proj_method1776330429598
            )
        
            # 4 Store
            base_name = string(proj_im1776330429598, "_proj_", proj_method1776330429598)
            key = JIVECore.Data.keyCheck(image_data, base_name)
        
            image_data[key] = projected
        
            if !(key in image_keys)
                push!(image_keys, key)
            end
        
            global proj_key1776330429598
            proj_key1776330429598 = key
            println("Projection stored as ", key)
        end
        end
        
        nothing
            


# ╔═╡ f8bcaa39-3c5f-43dd-bb9d-56c3c2f85075
md"""
# 🎨 RGB Channel Composition

This section allows you to **combine multiple image channels into an RGB (or multi-channel) color image**.

**Steps to use it:**

1. **Select the image**  
   Choose the image you want to convert into an RGB composition:  
   $(@bind rgb_im Select([nothing, image_keys...]))

2. **Enable auto contrast (optional)**  
   Improve visibility by automatically adjusting intensity levels:  
   $(@bind rgb_contrast PlutoUI.CheckBox(default=true))

3. **Assign channels to colors**  
   Depending on the number of channels in the image, you can map each one to a color component:
   - Channel 1 → Red / Green / Blue / other color maps
   - Channel 2 (if available)
   - Channel 3 (if available)
   - Channel 4+ (if available)

   Each channel can be assigned independently.

4. **Generate RGB image**  
   The system converts the selected channels into a single RGB composite image and stores it in `image_data`.

   The output will be saved with a name like:
   `original_name_rgb`

5. **Display RGB image (optional)**  
   You can visualize the resulting RGB image by enabling:
   $(@bind rgb_show PlutoUI.CheckBox(default=false))

> 💡 Tip: Use different channel mappings (e.g. R=protein marker, G=nucleus, B=membrane) to highlight structures in microscopy images.
"""

# ╔═╡ f5b23cc2-9bad-4cc8-94bc-ac908ad1a2da
md"""
##### RGB Channel Composition

Select image:
$(@bind rgb_im1776338015615 Select([nothing, image_keys...]))

Apply auto contrast:
$(@bind rgb_contrast1776338015615 PlutoUI.CheckBox(default=true))
            
"""


# ╔═╡ f588618a-a69d-4a92-b1e4-56f96f240325

            if isnothing(rgb_im1776338015615)
                nC = 0
            else
                img_col = image_data[rgb_im1776338015615]

                if img_col isa JIVECore.Data.AxisArray
                    names = JIVECore.Data.axisnames(img_col)
                    c_idx = findfirst(x -> lowercase(string(x)) == "c", names)
                    nC = !isnothing(c_idx) ? size(parent(img_col), c_idx) : 3
                else
                    nC = ndims(img_col) == 3 ? size(img_col, 3) : 1
                end
            end
						nothing
            


# ╔═╡ 9ce63d72-6d67-4c57-9a46-317e0303bec8

        channels = Symbol[]
        
        push!(channels, Symbol(rgb_r1776338015615))
        
        if nC ≥ 2
            push!(channels, Symbol(rgb_g1776338015615))
        end
        
        if nC ≥ 3
            push!(channels, Symbol(rgb_b1776338015615))
        end
        
        if nC ≥ 4
            push!(channels, Symbol(rgb_c41776338015615))
        end
        
        if nC ≥ 5
            push!(channels, Symbol(rgb_c51776338015615))
        end
        
        nothing
        


# ╔═╡ 58c77138-85a3-4268-97bc-ede8be4353c6


            rgb_key1776338015615 = nothing

            let

            if !isnothing(rgb_im1776338015615)

                img = copy(image_data[rgb_im1776338015615])

                rgb_img = JIVECore.Data.im2rgb(
                    img;
                    channels=channels
                )

                if rgb_contrast1776338015615
                    rgb_img = JIVECore.Process.autoContrast(rgb_img)
                end

                base_name = string(rgb_im1776338015615, "_rgb")

                key = JIVECore.Data.keyCheck(image_data, base_name)

                image_data[key] = rgb_img

                if !(key in image_keys)
                    push!(image_keys, key)
                end

                global rgb_key1776338015615
                rgb_key1776338015615 = key

            end

            end

            nothing
            


# ╔═╡ 42f5e8df-404d-46b2-b896-dccddc66d2af
md"""
##### $(@bind rgb_show1776338015615 PlutoUI.CheckBox(default=false)) Show RGB image

"""


# ╔═╡ bb7571df-c9a0-4631-97da-2df7ae7639d8


if rgb_show1776338015615 && !isnothing(rgb_key1776338015615)
    JIVECore.Visualize.gif(image_data[rgb_key1776338015615])
end



# ╔═╡ 9ef5c919-4443-409f-b94b-e28936bdbfdd
md"""
# 🏷️ Convert Image to AxisArray Annotation

This section allows you to **convert a standard image into an AxisArray format by assigning meaningful axis labels**.

**Steps to use it:**

1. **Select the image**  
   Choose the image you want to convert:  
   $(@bind axis_im Select([nothing, image_keys...]))

2. **Define axis labels**  
   Enter the names of the axes as a comma-separated list:  
   $(@bind axis_labels TextField(default="X,Y,Z,C"))

   Example: `X,Y,Z,T` or `X,Y,C`

3. **Convert image to AxisArray**  
   The image is converted into an AxisArray structure using the provided labels.  
   This adds semantic meaning to each dimension (e.g., spatial, channel, time).

4. **Store result**  
   The converted image is saved in `image_data` with a name like:  
   `original_name_axis`

   The system also prints:
   - Image type  
   - Dimensions  
   - Axis names

> 💡 Tip: Use correct axis ordering (e.g. X,Y,Z,T,C) so downstream tools like projections and analysis work correctly.
"""

# ╔═╡ 09e03b55-22df-44de-8031-8194c99d7e75
md"""
##### Convert Image to AxisArray

Select image:
$(@bind axis_im1776424986618 Select([nothing, image_keys...]))
        
Axis labels (comma separated):
$(@bind axis_labels1776424986618 TextField(default="X,Y,Z,C"))
                
"""


# ╔═╡ afaf27e8-e90a-4655-801c-175991a3946a

        
                axis_key1776424986618 = nothing
        
                let
        
                if !isnothing(axis_im1776424986618)
        
                    img = copy(image_data[axis_im1776424986618])
        
                    # Parse axis labels
                    axes_tuple = Tuple(Symbol.(strip.(split(axis_labels1776424986618, ","))))
        
                    axis_img = JIVECore.Data.im2axis(
                        img;
                        axes=axes_tuple
                    )
        
                    base_name = string(axis_im1776424986618, "_axis")
        
                    key = JIVECore.Data.keyCheck(image_data, base_name)
                
                    image_data[key] = axis_img
        
                    if !(key in image_keys)
                        push!(image_keys, key)
                    end

                    println("Image stored as \"$(key)\" ")
                    println("Type: ", typeof(axis_img))
                    println("Dimensions: ", size(axis_img))
                    println("Axes: ", JIVECore.Data.axisnames(axis_img))
        
                    global axis_key1776424986618
                    axis_key1776424986618 = key
        
                end
                end
        
                nothing
            


# ╔═╡ 4b2651ce-d1a9-4313-a0ba-60d5b8bd001e


# ╔═╡ e76ac8c7-3466-4af2-a683-1f7c13c14e5a
track = JIVECore.Files.loadImage("/Users/yi/JIVE/Demo Images/Confocal/Tracking.tif");

# ╔═╡ 073aa532-a566-4f40-8fb7-0dd6704d2522
track2 = JIVECore.Data.im2axis(track, :x, :y, :time, :c);

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

# ╔═╡ c73f9a99-8436-45a6-a847-3e278a08ed50


# ╔═╡ 692d9b01-66ae-401c-be81-a0e8456befe2
# ╠═╡ disabled = true
#=╠═╡

blocks = Any[]

channel_sym = [:r,:g,:b,:m,:y,:c,:gray]
channel_names = [rgb_r1776338015615, rgb_g1776338015615, rgb_b1776338015615]

for n in nC
push!(blocks, md"""
Channel 1:
$(@bind channel_names[n] Select(channel_sym, default=channel_sym[n]))
""")

end
blocks
            

  ╠═╡ =#

# ╔═╡ 29afa4eb-ddee-473d-a99d-3ced01eb12f8

blocks = Any[]

push!(blocks, md"""
Channel 1:
$(@bind rgb_r1776338015615 Select([:r,:g,:b,:m,:y,:c,:gray]))
""")

if nC ≥ 2
    push!(blocks, md"Channel 2: $(@bind rgb_g1776338015615 Select([:r,:g,:b,:m,:y,:c,:gray]))")
end

if nC ≥ 3
    push!(blocks, md"Channel 3: $(@bind rgb_b1776338015615 Select([:r,:g,:b,:m,:y,:c,:gray]))")
end

if nC ≥ 4
    push!(blocks, md"Channel 4: $(@bind rgb_c41776338015615 Select([:r,:g,:b,:m,:y,:c,:gray]))")
end

if nC ≥ 5
    push!(blocks, md"Channel 5: $(@bind rgb_c51776338015615  Select([:r,:g,:b,:m,:y,:c,:gray]))")
end

blocks
            


# ╔═╡ Cell order:
# ╟─adb575a6-d444-47e8-9b68-dad4a2d3e73a
# ╟─98698242-f26e-4d25-81c1-408488424e91
# ╟─4c9af6d4-f530-4698-b80e-3684d5196ab6
# ╟─d452c560-15f5-4c9b-91ac-9d38f4b027e2
# ╟─881e0530-bbd1-40e0-9cc6-5a12e1b86995
# ╟─b03f8eec-a25c-4b2e-8d03-6880e9e0e7d4
# ╟─496b1991-2902-4cfc-b1d7-9e9d544e1663
# ╟─ad1e2587-635f-4a06-afa0-cadd377b3299
# ╟─5ab265ec-f56b-4322-b953-11d0849a3382
# ╟─4e5c12f7-fc15-4e7e-9837-82b0e31367a0
# ╟─f8bcaa39-3c5f-43dd-bb9d-56c3c2f85075
# ╟─f5b23cc2-9bad-4cc8-94bc-ac908ad1a2da
# ╟─f588618a-a69d-4a92-b1e4-56f96f240325
# ╠═29afa4eb-ddee-473d-a99d-3ced01eb12f8
# ╠═692d9b01-66ae-401c-be81-a0e8456befe2
# ╟─9ce63d72-6d67-4c57-9a46-317e0303bec8
# ╟─58c77138-85a3-4268-97bc-ede8be4353c6
# ╟─42f5e8df-404d-46b2-b896-dccddc66d2af
# ╟─bb7571df-c9a0-4631-97da-2df7ae7639d8
# ╟─9ef5c919-4443-409f-b94b-e28936bdbfdd
# ╟─09e03b55-22df-44de-8031-8194c99d7e75
# ╟─afaf27e8-e90a-4655-801c-175991a3946a
# ╠═4b2651ce-d1a9-4313-a0ba-60d5b8bd001e
# ╠═e76ac8c7-3466-4af2-a683-1f7c13c14e5a
# ╠═073aa532-a566-4f40-8fb7-0dd6704d2522
# ╠═dcdc6961-8962-41c4-8441-e233844b0134
# ╠═d188c381-e4d5-40c5-9f09-54bb62b3f03a
# ╠═58514a11-c110-4c78-8f50-0e3da6edfd16
# ╠═25316aaf-33df-4beb-9c24-9bd5a5ef0e7d
# ╠═b9b218d2-d12d-4ad4-9871-0a9bb5b4b78a
# ╠═350d3b0b-34ff-48b0-978c-cb2b2096ea19
# ╠═d88a33e9-a281-4690-844f-50c733ce290a
# ╠═fcd2f98b-670c-4835-bcaf-1bbbf9493fa7
# ╠═80dcf140-7862-47a5-bd24-44698fa289e7
# ╠═c73f9a99-8436-45a6-a847-3e278a08ed50
